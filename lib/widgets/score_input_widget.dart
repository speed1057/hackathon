import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/models.dart';
import '../services/services.dart';

class ScoreInputWidget extends HookWidget {
  final String currentJudgeName;
  final JudgeScore? existingScore;
  final Function(int score, String comment) onScoreSubmitted;

  const ScoreInputWidget({
    super.key,
    required this.currentJudgeName,
    required this.existingScore,
    required this.onScoreSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final scoreController = useTextEditingController(
      text: existingScore?.score.toString() ?? '',
    );
    final commentController = useTextEditingController(
      text: existingScore?.comment ?? '',
    );
    final selectedScore = useState<int?>(existingScore?.score);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Judge: $currentJudgeName',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Score selection
          const Text(
            'Score (1-10):',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(10, (index) {
              final score = index + 1;
              final isSelected = selectedScore.value == score;
              return FilterChip(
                label: Text('$score'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    selectedScore.value = score;
                    scoreController.text = score.toString();
                  }
                },
                backgroundColor: isSelected ? Colors.blue.shade100 : null,
                selectedColor: Colors.blue.shade200,
              );
            }),
          ),

          // Score description
          if (selectedScore.value != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                ScoringService.getScoreDescription(selectedScore.value!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Comment input
          TextFormField(
            controller: commentController,
            decoration: const InputDecoration(
              labelText: 'Comments (optional)',
              border: OutlineInputBorder(),
              hintText: 'Enter your feedback for this project...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Submit button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedScore.value != null
                      ? () {
                          onScoreSubmitted(
                            selectedScore.value!,
                            commentController.text.trim(),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    existingScore != null ? 'Update Score' : 'Submit Score',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          // Show existing score info
          if (existingScore != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You scored this ${existingScore!.score}/10 on ${existingScore!.scoredAt.day}/${existingScore!.scoredAt.month}/${existingScore!.scoredAt.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
