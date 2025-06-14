import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/white_label_config.dart';
import '../services/white_label_service.dart';

// Provider for the current white label configuration
final whiteLabelConfigProvider = Provider<WhiteLabelConfig>((ref) {
  return WhiteLabelService.getCurrentConfig();
});

// Provider for the current organization ID
final currentOrganizationProvider = Provider<String>((ref) {
  return WhiteLabelService.getCurrentOrganizationId();
});

// Provider for checking if custom branding is active
final hasCustomBrandingProvider = Provider<bool>((ref) {
  return WhiteLabelService.hasCustomBranding();
});

// Provider for organization-specific messages
final welcomeMessageProvider = Provider<String>((ref) {
  return WhiteLabelService.getWelcomeMessage();
});

final eventCreationMessageProvider = Provider<String>((ref) {
  return WhiteLabelService.getEventCreationMessage();
});

// State notifier for dynamic organization changes (useful for testing)
class WhiteLabelNotifier extends StateNotifier<WhiteLabelConfig> {
  WhiteLabelNotifier() : super(WhiteLabelService.getCurrentConfig());

  void setOrganization(String? orgId) {
    WhiteLabelService.setOrganization(orgId);
    state = WhiteLabelService.getCurrentConfig();
  }

  void refreshConfig() {
    WhiteLabelService.clearCache();
    state = WhiteLabelService.getCurrentConfig();
  }
}

final whiteLabelNotifierProvider =
    StateNotifierProvider<WhiteLabelNotifier, WhiteLabelConfig>((ref) {
      return WhiteLabelNotifier();
    });
