/// A Data Transfer Object (DTO) representing the parameters required
/// for updating a user's objective progress.
class UpdateObjectiveProgressDTO {
  /// The ID of the user whose objectives are being updated.
  final String userId;

  /// The action type (e.g., create, update, attend) to match in the objectives.
  final String actionType;

  /// The feature (e.g., events, meetings) to match in the objectives.
  final List<String> feature;

  /// The progress increment to apply to the user's objective.
  final int progress;

  /// Constructs an [UpdateObjectiveProgressDTO] with the given parameters.
  const UpdateObjectiveProgressDTO({
    required this.userId,
    required this.actionType,
    required this.feature,
     this.progress=1,
  });

  /// Creates a copy of this DTO with the option to modify specific fields.
  ///
  /// If a field is not provided, the current value is retained.
  UpdateObjectiveProgressDTO copyWith({
    String? userId,
    String? actionType,
    List<String>? feature,
    int? progress,
  }) {
    return UpdateObjectiveProgressDTO(
      userId: userId ?? this.userId,
      actionType: actionType ?? this.actionType,
      feature: feature ?? this.feature,
      progress: progress ?? this.progress,
    );
  }

}
