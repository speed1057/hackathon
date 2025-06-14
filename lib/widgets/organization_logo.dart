import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/providers.dart';

class OrganizationLogo extends ConsumerWidget {
  final double size;
  final bool showFallback;

  const OrganizationLogo({super.key, this.size = 40, this.showFallback = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whiteLabelConfig = ref.watch(whiteLabelConfigProvider);

    // If there's a logo asset path or URL, show it
    if (whiteLabelConfig.logoAssetPath != null) {
      return Image.asset(
        whiteLabelConfig.logoAssetPath!,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackLogo(whiteLabelConfig.organizationName);
        },
      );
    }

    if (whiteLabelConfig.logoUrl != null) {
      return Image.network(
        whiteLabelConfig.logoUrl!,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackLogo(whiteLabelConfig.organizationName);
        },
      );
    }

    // Show fallback logo if enabled
    if (showFallback) {
      return _buildFallbackLogo(whiteLabelConfig.organizationName);
    }

    return const SizedBox.shrink();
  }

  Widget _buildFallbackLogo(String organizationName) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade300, Colors.purple.shade300],
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(organizationName),
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials(String organizationName) {
    final words = organizationName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'HH'; // Hackathon Hub fallback
  }
}
