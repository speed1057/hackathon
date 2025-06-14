class Submission {
  final String id;
  final String teamId;
  final String eventId;
  final String projectTitle;
  final String githubLink;
  final String description;
  final DateTime submittedAt;

  Submission({
    required this.id,
    required this.teamId,
    required this.eventId,
    required this.projectTitle,
    required this.githubLink,
    required this.description,
    required this.submittedAt,
  });

  Submission copyWith({
    String? id,
    String? teamId,
    String? eventId,
    String? projectTitle,
    String? githubLink,
    String? description,
    DateTime? submittedAt,
  }) {
    return Submission(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      eventId: eventId ?? this.eventId,
      projectTitle: projectTitle ?? this.projectTitle,
      githubLink: githubLink ?? this.githubLink,
      description: description ?? this.description,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      'eventId': eventId,
      'projectTitle': projectTitle,
      'githubLink': githubLink,
      'description': description,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      eventId: json['eventId'] as String,
      projectTitle: json['projectTitle'] as String,
      githubLink: json['githubLink'] as String,
      description: json['description'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Submission{id: $id, teamId: $teamId, eventId: $eventId, projectTitle: $projectTitle, githubLink: $githubLink, description: $description, submittedAt: $submittedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Submission &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          teamId == other.teamId &&
          eventId == other.eventId &&
          projectTitle == other.projectTitle &&
          githubLink == other.githubLink &&
          description == other.description &&
          submittedAt == other.submittedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      teamId.hashCode ^
      eventId.hashCode ^
      projectTitle.hashCode ^
      githubLink.hashCode ^
      description.hashCode ^
      submittedAt.hashCode;
}
