import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class JudgePage extends HookConsumerWidget {
  const JudgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judgeNameController = useTextEditingController(
      text: 'Judge',
    ); // Default judge name
    final currentJudgeName = useState('Judge');

    // Get all submissions, teams, and events
    final submissions = ref.watch(submissionsProvider);
    final teams = ref.watch(teamsProvider);
    final events = ref.watch(eventsProvider);
    final judgeScores = ref.watch(judgeScoresProvider);

    // Function to get team name by ID
    String getTeamName(String teamId) {
      final team = teams.where((t) => t.id == teamId).firstOrNull;
      return team?.name ?? 'Unknown Team';
    }

    // Function to get event name by ID
    String getEventName(String eventId) {
      final event = events.where((e) => e.id == eventId).firstOrNull;
      return event?.name ?? 'Unknown Event';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Judge Projects'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          // Judge name input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 120,
              child: TextFormField(
                controller: judgeNameController,
                decoration: const InputDecoration(
                  labelText: 'Judge Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                style: const TextStyle(fontSize: 12),
                onChanged: (value) {
                  currentJudgeName.value = value.trim();
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: [
                const Icon(Icons.gavel, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Projects to Judge',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (submissions.isNotEmpty)
                  InfoChip(
                    label: '${submissions.length} submissions',
                    icon: Icons.assignment,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Submissions list
            if (submissions.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: submissions.length,
                  itemBuilder: (context, index) {
                    final submission = submissions[index];
                    final teamName = getTeamName(submission.teamId);
                    final eventName = getEventName(submission.eventId);

                    // Get existing score for this judge
                    final existingScore = judgeScores
                        .where(
                          (score) =>
                              score.submissionId == submission.id &&
                              score.judgeName == currentJudgeName.value,
                        )
                        .firstOrNull;

                    // Get all scores for this submission
                    final allScores = judgeScores
                        .where((score) => score.submissionId == submission.id)
                        .toList();

                    final averageScore = allScores.isNotEmpty
                        ? allScores.fold(0, (sum, score) => sum + score.score) /
                              allScores.length
                        : null;

                    return SubmissionJudgeCard(
                      submission: submission,
                      teamName: teamName,
                      eventName: eventName,
                      currentJudgeName: currentJudgeName.value,
                      existingScore: existingScore,
                      averageScore: averageScore,
                      allScoresCount: allScores.length,
                      onScoreSubmitted: (score, comment) {
                        final judgeScore = JudgeScore(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          submissionId: submission.id,
                          judgeName: currentJudgeName.value,
                          score: score,
                          comment: comment,
                          scoredAt: DateTime.now(),
                        );

                        ref
                            .read(judgeScoresProvider.notifier)
                            .addScore(judgeScore);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Score $score/10 submitted for "${submission.projectTitle}"',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ] else ...[
              // Empty state
              Expanded(
                child: EmptyStateWidget(
                  icon: Icons.assignment_outlined,
                  title: 'No Submissions Yet',
                  description:
                      'Teams need to submit their projects before judging can begin.',
                  buttonText: 'Submit a Project',
                  onButtonPressed: () => context.go('/submission'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
