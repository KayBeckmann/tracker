import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/features/settings/application/settings_controller.dart';
import 'package:tracker/features/settings/presentation/widgets/settings_section.dart';

const _systemLanguageCode = 'system';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    final colorOptions = <_ColorOption>[
      _ColorOption(
        color: const Color(0xFF009688),
        label: l10n.settingsColorTeal,
      ),
      _ColorOption(
        color: const Color(0xFF1F8FFF),
        label: l10n.settingsColorBlue,
      ),
      _ColorOption(
        color: const Color(0xFFE65100),
        label: l10n.settingsColorAmber,
      ),
      _ColorOption(
        color: const Color(0xFF8E24AA),
        label: l10n.settingsColorPurple,
      ),
      _ColorOption(
        color: const Color(0xFF00695C),
        label: l10n.settingsColorForest,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        SettingsSection(
          title: l10n.settingsSectionAccount,
          subtitle: l10n.settingsSectionAccountDescription,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(l10n.settingsAccountSignIn),
              subtitle: Text(l10n.settingsAccountSignInDescription),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showComingSoon(context, l10n),
            ),
            ListTile(
              leading: const Icon(Icons.security_outlined),
              title: Text(l10n.settingsAccountSecurity),
              subtitle: Text(l10n.settingsAccountSecurityDescription),
              onTap: () => _showComingSoon(context, l10n),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsSectionAppearance,
          subtitle: l10n.settingsSectionAppearanceDescription,
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: Text(l10n.settingsAppearanceTheme),
              subtitle: Text(l10n.settingsAppearanceThemeDescription),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      controller.setThemeMode(mode);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n.settingsThemeSystem),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n.settingsThemeLight),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n.settingsThemeDark),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(l10n.settingsAppearanceLanguage),
              subtitle: Text(l10n.settingsAppearanceLanguageDescription),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: settings.languageCode ?? _systemLanguageCode,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    controller.setLanguageCode(
                      value == _systemLanguageCode ? null : value,
                    );
                  },
                  items: [
                    DropdownMenuItem(
                      value: _systemLanguageCode,
                      child: Text(l10n.settingsLanguageSystem),
                    ),
                    DropdownMenuItem(
                      value: 'de',
                      child: Text(l10n.settingsLanguageGerman),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(l10n.settingsLanguageEnglish),
                    ),
                    DropdownMenuItem(
                      value: 'sv',
                      child: Text(l10n.settingsLanguageSwedish),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsAppearanceAccent,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsAppearanceAccentDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: colorOptions
                        .map(
                          (option) => ChoiceChip(
                            label: Text(option.label),
                            avatar: CircleAvatar(
                              backgroundColor: option.color,
                              radius: 10,
                            ),
                            selected: option.color == settings.seedColor,
                            onSelected: (_) =>
                                controller.setSeedColor(option.color),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsSectionSync,
          subtitle: l10n.settingsSectionSyncDescription,
          children: [
            SwitchListTile.adaptive(
              value: settings.syncEnabled,
              onChanged: controller.setSyncEnabled,
              secondary: const Icon(Icons.sync_outlined),
              title: Text(l10n.settingsSyncStatus),
              subtitle: Text(l10n.settingsSyncStatusDescription),
            ),
            SwitchListTile.adaptive(
              value: settings.autoSyncEnabled,
              onChanged: settings.syncEnabled
                  ? controller.setAutoSyncEnabled
                  : null,
              secondary: const Icon(Icons.cloud_upload_outlined),
              title: Text(l10n.settingsSyncAuto),
              subtitle: Text(
                settings.syncEnabled
                    ? l10n.settingsSyncAutoDescription
                    : l10n.settingsSyncAutoDisabled,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsSectionSubscription,
          subtitle: l10n.settingsSectionSubscriptionDescription,
          children: [
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text(l10n.settingsSubscriptionPlan),
              subtitle: Text(l10n.settingsSubscriptionPlanDescription),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showComingSoon(context, l10n),
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: Text(l10n.settingsSubscriptionPaymentMethods),
              subtitle: Text(
                l10n.settingsSubscriptionPaymentMethodsDescription,
              ),
              onTap: () => _showComingSoon(context, l10n),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsSectionPrivacy,
          subtitle: l10n.settingsSectionPrivacyDescription,
          children: [
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(l10n.settingsPrivacyExport),
              subtitle: Text(l10n.settingsPrivacyExportDescription),
              onTap: () => _showComingSoon(context, l10n),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: Text(l10n.settingsPrivacyDelete),
              subtitle: Text(l10n.settingsPrivacyDeleteDescription),
              onTap: () => _showComingSoon(context, l10n),
            ),
          ],
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsComingSoon)));
  }
}

class _ColorOption {
  const _ColorOption({required this.color, required this.label});

  final Color color;
  final String label;
}
