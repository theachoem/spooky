// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tab;
import 'package:storypad/core/services/analytics_service.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class UrlOpenerService {
  static Future<bool> launchUrlString(
    String url, {
    bool deeplinkOnly = false,
  }) {
    final uri = Uri.parse(url);

    return launchUrl(
      uri,
      mode: deeplinkOnly ? launcher.LaunchMode.externalNonBrowserApplication : launcher.LaunchMode.platformDefault,
    );
  }

  static Future<bool> launchUrl(
    Uri uri, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
  }) async {
    if (await launcher.canLaunchUrl(uri)) {
      bool launched = false;

      try {
        launched = await launcher.launchUrl(uri, mode: mode);
      } catch (e) {
        debugPrint('$UrlOpenerService.launchUrl failed $e');
      }

      if (launched) {
        AnalyticsService.instance.logLaunchUrl(
          url: uri.toString(),
        );
      }

      return launched;
    } else {
      return false;
    }
  }

  static Future<void> openInCustomTab(
    BuildContext context,
    String url, {
    bool prefersDeepLink = false,
  }) async {
    Color? toolbarColor = Theme.of(context).appBarTheme.backgroundColor;
    Color? foregroundColor = Theme.of(context).appBarTheme.foregroundColor;

    AnalyticsService.instance.logOpenLinkInCustomTab(
      url: url,
    );

    await custom_tab.launchUrl(
      Uri.parse(url),
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: custom_tab.CustomTabsOptions(
        colorSchemes: custom_tab.CustomTabsColorSchemes.defaults(
          toolbarColor: toolbarColor,
        ),
      ),
      safariVCOptions: custom_tab.SafariViewControllerOptions(
        preferredBarTintColor: toolbarColor,
        preferredControlTintColor: foregroundColor,
        dismissButtonStyle: custom_tab.SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}
