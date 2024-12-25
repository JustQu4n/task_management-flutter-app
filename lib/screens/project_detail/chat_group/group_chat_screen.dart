import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GroupChatScreen extends StatefulWidget {
  final String projectId;

  const GroupChatScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<GroupChatScreen> {
  bool _isAttachmentUploading = false;

  void _handleOnSendPressed(types.PartialText message) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('groupChat')
          .add({
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Unknown',
        'message': message.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  Future<void> _handleAttachmentPressed() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('File'),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      _setAttachmentUploading(true);
      final downloadUrl = await _uploadFileToStorage(filePath, 'images');
      if (downloadUrl != null) {
        final message = types.PartialImage(
          name: path.basename(filePath),
          size: File(filePath).lengthSync(),
          uri: downloadUrl,
        );
        _sendMessage(message);
        _setAttachmentUploading(false);
      }
    }
  }

  Future<void> _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      _setAttachmentUploading(true);
      final downloadUrl = await _uploadFileToStorage(filePath, 'files');
      if (downloadUrl != null) {
        final message = types.PartialFile(
          name: path.basename(filePath),
          size: File(filePath).lengthSync(),
          uri: downloadUrl,
        );
        _sendMessage(message);
        _setAttachmentUploading(false);
      }
    }
  }

  Future<String?> _uploadFileToStorage(String filePath, String folder) async {
    try {
      final fileName = path.basename(filePath);
      final ref = FirebaseStorage.instance
          .ref()
          .child('$folder/${widget.projectId}/$fileName');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  void _sendMessage(dynamic message) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final messageData = {
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (message is types.PartialText) {
        // Handling a text message
        messageData['message'] = message.text;
        messageData['isFile'] = false;
      } else
      if (message is types.PartialFile || message is types.PartialImage) {
        // Handling a file or image message
        messageData['message'] = message.uri;
        messageData['isFile'] = true;
        messageData['fileName'] = message.name;
        messageData['fileSize'] = message.size;
      } else {
        print("Unsupported message type");
        return;
      }

      // Saving the message to Firestore
      FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('groupChat')
          .add(messageData);
    }
  }


  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentDir/${message.name}';

        if (!File(localPath).existsSync()) {
          await File(localPath).writeAsBytes(bytes);
        }
        OpenFilex.open(localPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Project Chat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .collection('groupChat')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          // Check if snapshot has data and map messages
          final messages = snapshot.data?.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final isFile = data['isFile'] ?? false;
            final timestamp = data['timestamp'] as Timestamp?;
            final createdAt = timestamp?.millisecondsSinceEpoch ?? DateTime
                .now()
                .millisecondsSinceEpoch;

            final author = types.User(
              id: data['senderId'] ?? '',
              firstName: data['senderName'] ?? 'Unknown',
              imageUrl: data['senderAvatar'] ?? '',
            );

            if (isFile) {
              return types.FileMessage(
                author: author,
                createdAt: createdAt,
                id: doc.id,
                name: data['fileName'] ?? 'Unknown file',
                size: data['fileSize'] ?? 0,
                uri: data['message'] ?? '',
              );
            } else {
              return types.TextMessage(
                author: author,
                createdAt: createdAt,
                id: doc.id,
                text: data['message'] ?? '',
              );
            }
          }).toList() ?? [];

          return Chat(
            messages: messages,
            onSendPressed: _handleOnSendPressed,
            onAttachmentPressed: _handleAttachmentPressed,
            isAttachmentUploading: _isAttachmentUploading,
            onMessageTap: _handleMessageTap,
            user: types.User(
              id: user?.uid ?? '',
              imageUrl: user?.photoURL ?? '',
            ),
          );
        },
      ),
    );
  }
}