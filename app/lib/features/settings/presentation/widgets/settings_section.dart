import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(subtitle!, style: theme.textTheme.bodySmall),
              ),
            const SizedBox(height: 8),
            ..._joinChildren(children),
          ],
        ),
      ),
    );
  }

  List<Widget> _joinChildren(List<Widget> widgets) {
    final List<Widget> spaced = [];
    for (var i = 0; i < widgets.length; i++) {
      spaced.add(widgets[i]);
      if (i != widgets.length - 1) {
        spaced.add(const Divider(height: 1));
      }
    }
    return spaced;
  }
}
