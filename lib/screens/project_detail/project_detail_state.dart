part of 'project_detail_cubit.dart';

@freezed
class ProjectDetailState with _$ProjectDetailState {
  const factory ProjectDetailState({
    Project? project,
    @Default([]) List<Task> tasks,
    @Default([]) List<Task> tasksCopy,
    @Default([]) List<Attachment> attachments,
    @Default([]) List<UserDto> members,
    @Default([]) List<Notes> notes,
    @Default(0.0) double progress,
    @Default('') String projectName,
    @Default('') String projectDescription,
    DateTime? startDate,
    DateTime? endDate,
    @Default(false) bool projectNotification,
}) = _ProjectDetailState;
}
