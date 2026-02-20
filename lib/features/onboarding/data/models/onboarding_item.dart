import 'package:flutter/material.dart';

/// Represents a single onboarding screen's content.
class OnboardingItem {
  /// Translation key for the title.
  final String titleKey;

  /// Translation key for the description.
  final String descriptionKey;

  /// Icon displayed on the onboarding screen.
  final IconData icon;

  /// Primary color accent for this screen.
  final Color color;

  const OnboardingItem({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.color,
  });
}
