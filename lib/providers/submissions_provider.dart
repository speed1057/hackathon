import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

// Submissions management
class SubmissionsNotifier extends StateNotifier<List<Submission>> {
  SubmissionsNotifier() : super([]);

  // Initialize and load data
  Future<void> initialize() async {
    final submissions = await DataPersistenceService.loadSubmissions();
    state = submissions;
  }

  Future<void> addSubmission(Submission submission) async {
    state = [...state, submission];
    await DataPersistenceService.saveSubmissions(state);
  }

  Future<void> removeSubmission(String submissionId) async {
    state = state.where((submission) => submission.id != submissionId).toList();
    await DataPersistenceService.saveSubmissions(state);
  }

  Future<void> updateSubmission(Submission updatedSubmission) async {
    state = state.map((submission) {
      if (submission.id == updatedSubmission.id) {
        return updatedSubmission;
      }
      return submission;
    }).toList();
    await DataPersistenceService.saveSubmissions(state);
  }

  Future<void> clearSubmissions() async {
    state = [];
    await DataPersistenceService.saveSubmissions(state);
  }

  Submission? getSubmissionById(String submissionId) {
    try {
      return state.firstWhere((submission) => submission.id == submissionId);
    } catch (e) {
      return null;
    }
  }

  List<Submission> getSubmissionsByEventId(String eventId) {
    return state.where((submission) => submission.eventId == eventId).toList();
  }

  List<Submission> getSubmissionsByTeamId(String teamId) {
    return state.where((submission) => submission.teamId == teamId).toList();
  }

  bool hasTeamSubmitted(String teamId) {
    return state.any((submission) => submission.teamId == teamId);
  }
}

// Provider for managing submissions
final submissionsProvider =
    StateNotifierProvider<SubmissionsNotifier, List<Submission>>((ref) {
      return SubmissionsNotifier();
    });

// Provider for getting submissions by event ID
final submissionsByEventProvider = Provider.family<List<Submission>, String>((
  ref,
  eventId,
) {
  final submissions = ref.watch(submissionsProvider);
  return submissions
      .where((submission) => submission.eventId == eventId)
      .toList();
});

// Provider for getting submissions by team ID
final submissionsByTeamProvider = Provider.family<List<Submission>, String>((
  ref,
  teamId,
) {
  final submissions = ref.watch(submissionsProvider);
  return submissions
      .where((submission) => submission.teamId == teamId)
      .toList();
});

// Provider for checking if team has already submitted
final hasTeamSubmittedProvider = Provider.family<bool, String>((ref, teamId) {
  final submissions = ref.watch(submissionsProvider);
  return submissions.any((submission) => submission.teamId == teamId);
});
