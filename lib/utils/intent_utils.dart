import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class IntentUtils {
  IntentUtils._();

  static Future<void> launchGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri(
      scheme: "google.navigation",
      queryParameters: {'q': '$latitude,$longitude'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch Google Maps');
    }
  }
}
