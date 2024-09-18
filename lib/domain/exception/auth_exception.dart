import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:room_master_app/l10n/l10n.dart';

class AuthException implements Exception {
  static AuthException handleFirebaseAuthException(FirebaseAuthException exception) {
    log(exception.code);
    switch (exception.code) {
      case 'invalid-email':
        return InvalidEmailException();
      case 'user-disabled':
        return UserDisabledException();
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return WrongPasswordException();
      default:
        return AuthException();
    }
  }

  String errorMessage(BuildContext context) {
    // Fallback for general exceptions
    return 'Please ensure you fill in email and password field.';
  }
}

class InvalidEmailException extends AuthException {
  @override
  String errorMessage(BuildContext context) {
    return context.l10n.invalid_email_exception;
  }
}

class UserDisabledException extends AuthException {
  @override
  String errorMessage(BuildContext context) {
    return context.l10n.user_disabled_exception;
  }
}

class UserNotFoundException extends AuthException {
  @override
  String errorMessage(BuildContext context) {
    return context.l10n.user_not_found_exception;
  }
}

class WrongPasswordException extends AuthException {
  @override
  String errorMessage(BuildContext context) {
    return 'Wrong password'; // You can also localize this message if needed.
  }
}