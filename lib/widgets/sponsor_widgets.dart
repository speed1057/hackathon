import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// A sponsor logo card
class SponsorCard extends ConsumerWidget {
  final Sponsor sponsor;
  final double? width;
  final double? height;

  const SponsorCard({
    super.key,
    required this.sponsor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whiteLabelConfig = ref.watch(whiteLabelConfigProvider);

    return GestureDetector(
      onTap: sponsor.websiteUrl != null
          ? () => _launchUrl(sponsor.websiteUrl!)
          : null,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: width ?? 160,
          height: height ?? 100,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: whiteLabelConfig.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  sponsor.logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.business_rounded,
                    size: 32,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sponsor.name,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (sponsor.tier == 'platinum') ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade300, width: 1),
                  ),
                  child: Text(
                    'PLATINUM',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber.shade800,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// A job opportunity card
class JobCard extends ConsumerWidget {
  final JobOpportunity job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whiteLabelConfig = ref.watch(whiteLabelConfigProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: whiteLabelConfig.primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company logo and basic info
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.network(
                    job.companyLogoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.work_rounded,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.company,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: whiteLabelConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Job details
            Text(
              job.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: job.tags
                  .take(3)
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: whiteLabelConfig.primaryColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: whiteLabelConfig.primaryColor.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: whiteLabelConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Location, salary, prize info
            Row(
              children: [
                if (job.location != null) ...[
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.location!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (job.salary != null) ...[
                        Text(
                          job.salary!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                      if (job.prize != null) ...[
                        Text(
                          job.prize!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.amber.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Apply button and deadline
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(job.applyUrl),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Apply Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteLabelConfig.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (job.hasDeadline) ...[
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Deadline',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        _formatDate(job.applicationDeadline!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h left';
    } else {
      return 'Expired';
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
