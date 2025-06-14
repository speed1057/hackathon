import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'project_info_header.dart';
import 'score_input_widget.dart';

class SubmissionJudgeCard extends HookWidget {
  final Submission submission;
  final String teamName;
  final String eventName;
  final String currentJudgeName;
  final JudgeScore? existingScore;
  final double? averageScore;
  final int allScoresCount;
  final Function(int score, String comment) onScoreSubmitted;

  const SubmissionJudgeCard({
    super.key,
    required this.submission,
    required this.teamName,
    required this.eventName,
    required this.currentJudgeName,
    required this.existingScore,
    required this.averageScore,
    required this.allScoresCount,
    required this.onScoreSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with project info
            ProjectInfoHeader(
              submission: submission,
              teamName: teamName,
              eventName: eventName,
              averageScore: averageScore,
              allScoresCount: allScoresCount,
              isExpanded: isExpanded.value,
              onToggleExpanded: () => isExpanded.value = !isExpanded.value,
            ),

            // Expandable content
            if (isExpanded.value) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Project description
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                submission.description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // GitHub link
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (ValidationService.isValidGitHubUrl(
                        submission.githubLink,
                      )) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening: ${submission.githubLink}'),
                            action: SnackBarAction(
                              label: 'Copy',
                              onPressed: () {
                                // In a real app, you'd copy to clipboard here
                              },
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid GitHub URL'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Scoring section
              ScoreInputWidget(
                currentJudgeName: currentJudgeName,
                existingScore: existingScore,
                onScoreSubmitted: onScoreSubmitted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
