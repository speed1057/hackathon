import 'package:flutter/material.dart';
import '../models/models.dart';

class ProjectInfoHeader extends StatelessWidget {
  final Submission submission;
  final String teamName;
  final String eventName;
  final double? averageScore;
  final int allScoresCount;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const ProjectInfoHeader({
    super.key,
    required this.submission,
    required this.teamName,
    required this.eventName,
    required this.averageScore,
    required this.allScoresCount,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                submission.projectTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.group, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    teamName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.event, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    eventName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Average score and expand button
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (averageScore != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Avg: ${averageScore!.toStringAsFixed(1)}/10',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$allScoresCount judge${allScoresCount != 1 ? 's' : ''}',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
            IconButton(
              onPressed: onToggleExpanded,
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ),
          ],
        ),
      ],
    );
  }
}
