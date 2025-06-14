import '../models/models.dart';

class ScoringService {
  static double? calculateAverageScore(List<JudgeScore> scores) {
    if (scores.isEmpty) return null;

    final totalScore = scores.fold(0, (sum, score) => sum + score.score);
    return totalScore / scores.length;
  }

  static Map<String, double> calculateScoreStatistics(List<JudgeScore> scores) {
    if (scores.isEmpty) {
      return {'average': 0.0, 'min': 0.0, 'max': 0.0, 'count': 0.0};
    }

    final scoreValues = scores.map((s) => s.score).toList();
    scoreValues.sort();

    return {
      'average': calculateAverageScore(scores) ?? 0.0,
      'min': scoreValues.first.toDouble(),
      'max': scoreValues.last.toDouble(),
      'count': scores.length.toDouble(),
    };
  }

  static List<({String submissionId, double averageScore})> rankSubmissions(
    List<Submission> submissions,
    List<JudgeScore> allScores,
  ) {
    final rankings = <({String submissionId, double averageScore})>[];

    for (final submission in submissions) {
      final submissionScores = allScores
          .where((score) => score.submissionId == submission.id)
          .toList();

      final avgScore = calculateAverageScore(submissionScores) ?? 0.0;
      rankings.add((submissionId: submission.id, averageScore: avgScore));
    }

    // Sort by average score (highest first)
    rankings.sort((a, b) => b.averageScore.compareTo(a.averageScore));

    return rankings;
  }

  static bool isValidScore(int score) {
    return score >= 1 && score <= 10;
  }

  static String getScoreDescription(int score) {
    switch (score) {
      case 1:
      case 2:
        return 'Poor';
      case 3:
      case 4:
        return 'Below Average';
      case 5:
      case 6:
        return 'Average';
      case 7:
      case 8:
        return 'Good';
      case 9:
      case 10:
        return 'Excellent';
      default:
        return 'Invalid';
    }
  }

  static bool hasJudgeAlreadyScored(
    List<JudgeScore> scores,
    String submissionId,
    String judgeName,
  ) {
    return scores.any(
      (score) =>
          score.submissionId == submissionId && score.judgeName == judgeName,
    );
  }
}
