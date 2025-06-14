import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

// Judge Scores management
class JudgeScoresNotifier extends StateNotifier<List<JudgeScore>> {
  JudgeScoresNotifier() : super([]);

  // Initialize and load data
  Future<void> initialize() async {
    final scores = await DataPersistenceService.loadJudgeScores();
    state = scores;
  }

  Future<void> addScore(JudgeScore score) async {
    // Remove existing score for the same submission by the same judge
    state = state
        .where(
          (s) =>
              !(s.submissionId == score.submissionId &&
                  s.judgeName == score.judgeName),
        )
        .toList();
    // Add new score
    state = [...state, score];
    await DataPersistenceService.saveJudgeScores(state);
  }

  Future<void> removeScore(String scoreId) async {
    state = state.where((score) => score.id != scoreId).toList();
    await DataPersistenceService.saveJudgeScores(state);
  }

  Future<void> updateScore(JudgeScore updatedScore) async {
    state = state.map((score) {
      if (score.id == updatedScore.id) {
        return updatedScore;
      }
      return score;
    }).toList();
    await DataPersistenceService.saveJudgeScores(state);
  }

  Future<void> clearScores() async {
    state = [];
    await DataPersistenceService.saveJudgeScores(state);
  }

  JudgeScore? getScoreById(String scoreId) {
    try {
      return state.firstWhere((score) => score.id == scoreId);
    } catch (e) {
      return null;
    }
  }

  List<JudgeScore> getScoresBySubmissionId(String submissionId) {
    return state.where((score) => score.submissionId == submissionId).toList();
  }

  List<JudgeScore> getScoresByJudge(String judgeName) {
    return state.where((score) => score.judgeName == judgeName).toList();
  }

  double? getAverageScore(String submissionId) {
    final scores = getScoresBySubmissionId(submissionId);
    if (scores.isEmpty) return null;

    final totalScore = scores.fold(0, (sum, score) => sum + score.score);
    return totalScore / scores.length;
  }

  JudgeScore? getScoreBySubmissionAndJudge(
    String submissionId,
    String judgeName,
  ) {
    try {
      return state.firstWhere(
        (score) =>
            score.submissionId == submissionId && score.judgeName == judgeName,
      );
    } catch (e) {
      return null;
    }
  }
}

// Provider for managing judge scores
final judgeScoresProvider =
    StateNotifierProvider<JudgeScoresNotifier, List<JudgeScore>>((ref) {
      return JudgeScoresNotifier();
    });

// Provider for getting scores by submission ID
final scoresBySubmissionProvider = Provider.family<List<JudgeScore>, String>((
  ref,
  submissionId,
) {
  final scores = ref.watch(judgeScoresProvider);
  return scores.where((score) => score.submissionId == submissionId).toList();
});

// Provider for getting average score for a submission
final averageScoreProvider = Provider.family<double?, String>((
  ref,
  submissionId,
) {
  final scores = ref.watch(scoresBySubmissionProvider(submissionId));
  if (scores.isEmpty) return null;

  final totalScore = scores.fold(0, (sum, score) => sum + score.score);
  return totalScore / scores.length;
});

// Provider for checking if a judge has scored a submission
final hasJudgeScoredProvider =
    Provider.family<bool, ({String submissionId, String judgeName})>((
      ref,
      params,
    ) {
      final scores = ref.watch(judgeScoresProvider);
      return scores.any(
        (score) =>
            score.submissionId == params.submissionId &&
            score.judgeName == params.judgeName,
      );
    });
