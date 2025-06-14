import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class WhiteLabelDemo extends ConsumerWidget {
  const WhiteLabelDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentConfig = ref.watch(whiteLabelConfigProvider);
    final hasCustomBranding = ref.watch(hasCustomBrandingProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'White Label Demo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (hasCustomBranding)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: currentConfig.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: currentConfig.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              'Current Organization: ${currentConfig.organizationName}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              'App Title: ${currentConfig.appTitle}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Text('Primary Color: ', style: TextStyle(fontSize: 14)),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: currentConfig.primaryColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: currentConfig.secondaryColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Text(
              'Try these URLs:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            ...WhiteLabelConfig.predefinedConfigs.keys.map((orgId) {
              final config = WhiteLabelConfig.predefinedConfigs[orgId]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: config.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '?org=$orgId → ${config.organizationName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.preview, size: 16),
                      onPressed: () {
                        ref
                            .read(whiteLabelNotifierProvider.notifier)
                            .setOrganization(orgId);
                      },
                      tooltip: 'Preview ${config.organizationName}',
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),

            Row(
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(whiteLabelNotifierProvider.notifier)
                        .setOrganization(null);
                  },
                  child: const Text('Reset to Default'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref
                        .read(whiteLabelNotifierProvider.notifier)
                        .refreshConfig();
                  },
                  child: const Text('Refresh from URL'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
