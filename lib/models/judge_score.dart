class JudgeScore {
  final String id;
  final String submissionId;
  final String judgeName;
  final int score;
  final String comment;
  final DateTime scoredAt;

  JudgeScore({
    required this.id,
    required this.submissionId,
    required this.judgeName,
    required this.score,
    required this.comment,
    required this.scoredAt,
  });

  JudgeScore copyWith({
    String? id,
    String? submissionId,
    String? judgeName,
    int? score,
    String? comment,
    DateTime? scoredAt,
  }) {
    return JudgeScore(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      judgeName: judgeName ?? this.judgeName,
      score: score ?? this.score,
      comment: comment ?? this.comment,
      scoredAt: scoredAt ?? this.scoredAt,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'submissionId': submissionId,
      'judgeName': judgeName,
      'score': score,
      'comment': comment,
      'scoredAt': scoredAt.toIso8601String(),
    };
  }

  factory JudgeScore.fromJson(Map<String, dynamic> json) {
    return JudgeScore(
      id: json['id'] as String,
      submissionId: json['submissionId'] as String,
      judgeName: json['judgeName'] as String,
      score: json['score'] as int,
      comment: json['comment'] as String,
      scoredAt: DateTime.parse(json['scoredAt'] as String),
    );
  }

  @override
  String toString() {
    return 'JudgeScore{id: $id, submissionId: $submissionId, judgeName: $judgeName, score: $score, comment: $comment, scoredAt: $scoredAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JudgeScore &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          submissionId == other.submissionId &&
          judgeName == other.judgeName &&
          score == other.score &&
          comment == other.comment &&
          scoredAt == other.scoredAt;

  @override
  int get hashCode =>
      id.hashCode ^
      submissionId.hashCode ^
      judgeName.hashCode ^
      score.hashCode ^
      comment.hashCode ^
      scoredAt.hashCode;
}
