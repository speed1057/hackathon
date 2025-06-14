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
  final bool isCompact;

  const SponsorCard({
    super.key,
    required this.sponsor,
    this.width,
    this.height,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whiteLabelConfig = ref.watch(whiteLabelConfigProvider);
    final bool isPlatinum = sponsor.tier == 'platinum';

    // Optimized sizing
    final cardWidth = width ?? (isCompact ? 120 : 140);
    final cardHeight = height ?? (isCompact ? 80 : 100);
    final cardPadding = isCompact ? 10.0 : 12.0;

    return GestureDetector(
      onTap: sponsor.websiteUrl != null
          ? () => _launchUrl(sponsor.websiteUrl!)
          : null,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: whiteLabelConfig.primaryColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: isPlatinum ? 3 : 2,
                child: Image.network(
                  sponsor.logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.business_rounded,
                    size: isCompact ? 20 : 24,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              SizedBox(height: isCompact ? 4 : 6),
              Text(
                sponsor.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isCompact ? 10 : 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isPlatinum) ...[
                const SizedBox(height: 3),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 4 : 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber.shade300, width: 1),
                  ),
                  child: Text(
                    'PLATINUM',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber.shade800,
                      fontSize: isCompact ? 8 : 9,
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
  final bool isCompact;

  const JobCard({super.key, required this.job, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whiteLabelConfig = ref.watch(whiteLabelConfigProvider);
    final cardPadding = isCompact ? 12.0 : 14.0;
    final logoSize = isCompact ? 36.0 : 40.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: whiteLabelConfig.primaryColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with company logo and basic info
            Row(
              children: [
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.network(
                    job.companyLogoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.work_rounded,
                      color: Colors.grey[600],
                      size: isCompact ? 16 : 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: isCompact ? 12 : 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.company,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: whiteLabelConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: isCompact ? 10 : 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: isCompact ? 8 : 10),

            // Job details - more concise
            Text(
              job.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.3,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.75),
                fontSize: isCompact ? 10 : 11,
              ),
              maxLines: isCompact ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: isCompact ? 8 : 10),

            // Tags - limit to 2-3 tags for compactness
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: job.tags
                  .take(isCompact ? 2 : 3)
                  .map(
                    (tag) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 5 : 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: whiteLabelConfig.primaryColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: whiteLabelConfig.primaryColor.withValues(
                            alpha: 0.25,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: whiteLabelConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: isCompact ? 9 : 10,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            SizedBox(height: isCompact ? 8 : 10),

            // Location and salary info - more compact
            if (job.location != null || job.salary != null || job.prize != null)
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isCompact ? 4 : 6,
                  horizontal: isCompact ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    if (job.location != null) ...[
                      Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          job.location!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: isCompact ? 9 : 10,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (job.salary != null) ...[
                      if (job.location != null)
                        Container(
                          width: 1,
                          height: 10,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                      Expanded(
                        child: Text(
                          job.salary!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: isCompact ? 9 : 10,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (job.prize != null) ...[
                      if (job.location != null || job.salary != null)
                        Container(
                          width: 1,
                          height: 10,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                      Expanded(
                        child: Text(
                          job.prize!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.amber.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: isCompact ? 9 : 10,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            SizedBox(height: isCompact ? 10 : 12),

            // Apply button and deadline
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(job.applyUrl),
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: isCompact ? 14 : 16,
                    ),
                    label: Text(
                      'Apply Now',
                      style: TextStyle(fontSize: isCompact ? 11 : 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteLabelConfig.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isCompact ? 6 : 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),
                if (job.hasDeadline) ...[
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Deadline',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: isCompact ? 8 : 9,
                        ),
                      ),
                      Text(
                        _formatDate(job.applicationDeadline!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isCompact ? 9 : 10,
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
