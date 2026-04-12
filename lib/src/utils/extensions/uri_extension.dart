import 'package:url_launcher/url_launcher.dart';

/// Extension on Uri to provide convenient launch methods
extension UriLaunchExtension on Uri {
  /// Launches the URL with in-app web view if possible, falls back to platform default
  /// 
  /// Returns true if the URL was successfully launched
  /// 
  /// Example:
  /// ```dart
  /// final uri = Uri.parse('https://example.com');
  /// await uri.launch();
  /// ```
  Future<bool> launch({LaunchMode? mode}) async {
    if (await canLaunchUrl(this)) {
      return await launchUrl(this, mode: mode ?? LaunchMode.inAppWebView);
    } else {
      return await launchUrl(this, mode: mode ?? LaunchMode.platformDefault);
    }
  }
  Future<bool> launchCall() async {
      if (await canLaunchUrl(this)) {
        return await launchUrl(this, mode: LaunchMode.externalNonBrowserApplication);
      } else {
        return await launchUrl(this, mode: LaunchMode.platformDefault);
      }
  }
  /// Launches the URL with in-app web view if possible, falls back to platform default
  /// 
  /// The [title] parameter can be used by the consuming code to set a webview title,
  /// though it's not directly used by url_launcher (it's passed through webOnlyWindowName)
  /// 
  /// Returns true if the URL was successfully launched
  /// 
  /// Example:
  /// ```dart
  /// final uri = Uri.parse('https://example.com');
  /// await uri.launchWithTitle('Example Page');
  /// ```
  Future<bool> launchWithTitle(String title) async {
    if (await canLaunchUrl(this)) {
      return await launchUrl(
        this,
        mode: LaunchMode.inAppWebView,
        webOnlyWindowName: title,
      );
    } else {
      return await launchUrl(this, mode: LaunchMode.platformDefault);
    }
  }
}

