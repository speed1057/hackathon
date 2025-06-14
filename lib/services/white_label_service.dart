import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import '../models/white_label_config.dart';

class WhiteLabelService {
  static String? _cachedOrgId;
  static WhiteLabelConfig? _cachedConfig;

  /// Detects the organization ID from the URL query parameters
  static String? detectOrganizationFromUrl() {
    if (_cachedOrgId != null) return _cachedOrgId;

    try {
      if (kIsWeb) {
        // For web, use Uri.base to get the current URL
        final uri = Uri.base;
        _cachedOrgId = uri.queryParameters['org'];
      } else {
        // For mobile/desktop, you might want to handle this differently
        // For now, return null as mobile apps typically don't have URL parameters
        _cachedOrgId = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error detecting organization from URL: $e');
      }
      _cachedOrgId = null;
    }

    return _cachedOrgId;
  }

  /// Gets the white label configuration for the current organization
  static WhiteLabelConfig getCurrentConfig() {
    if (_cachedConfig != null) return _cachedConfig!;

    final orgId = detectOrganizationFromUrl();
    _cachedConfig = WhiteLabelConfig.getConfig(orgId);

    if (kDebugMode) {
      print('White label config loaded for org: ${orgId ?? 'default'}');
      print('Organization name: ${_cachedConfig!.organizationName}');
      print('App title: ${_cachedConfig!.appTitle}');
    }

    return _cachedConfig!;
  }

  /// Updates the browser title based on the organization
  static void updateBrowserTitle() {
    if (kIsWeb) {
      try {
        final config = getCurrentConfig();
        html.document.title = config.appTitle;
      } catch (e) {
        if (kDebugMode) {
          print('Error updating browser title: $e');
        }
      }
    }
  }

  /// Clears the cached configuration (useful for testing)
  static void clearCache() {
    _cachedOrgId = null;
    _cachedConfig = null;
  }

  /// Manually set organization (useful for testing or mobile apps)
  static void setOrganization(String? orgId) {
    _cachedOrgId = orgId;
    _cachedConfig = WhiteLabelConfig.getConfig(orgId);
    updateBrowserTitle();
  }

  /// Get organization-specific welcome message
  static String getWelcomeMessage() {
    final config = getCurrentConfig();
    if (config.organizationId ==
        WhiteLabelConfig.defaultConfig.organizationId) {
      return 'Welcome to Hackathon Hub';
    }
    return 'Welcome to ${config.organizationName} Hackathon Hub';
  }

  /// Get organization-specific event creation message
  static String getEventCreationMessage() {
    final config = getCurrentConfig();
    if (config.organizationId ==
        WhiteLabelConfig.defaultConfig.organizationId) {
      return 'Create a new hackathon event';
    }
    return 'Create a new ${config.organizationName} hackathon event';
  }

  /// Check if current organization has custom branding
  static bool hasCustomBranding() {
    final config = getCurrentConfig();
    return config.organizationId !=
        WhiteLabelConfig.defaultConfig.organizationId;
  }

  /// Get current organization ID
  static String getCurrentOrganizationId() {
    return getCurrentConfig().organizationId;
  }

  /// Get current organization name
  static String getCurrentOrganizationName() {
    return getCurrentConfig().organizationName;
  }
}
