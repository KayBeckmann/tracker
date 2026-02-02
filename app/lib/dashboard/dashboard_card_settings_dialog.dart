import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import 'dashboard_card_settings.dart';

/// Dialog to configure a single dashboard card.
Future<DashboardCardConfig?> showDashboardCardSettingsDialog({
  required BuildContext context,
  required String cardTitle,
  required DashboardCardConfig currentConfig,
  required Set<DashboardCardSettingType> availableSettings,
}) {
  return showDialog<DashboardCardConfig>(
    context: context,
    builder: (context) => _DashboardCardSettingsDialog(
      cardTitle: cardTitle,
      currentConfig: currentConfig,
      availableSettings: availableSettings,
    ),
  );
}

class _DashboardCardSettingsDialog extends StatefulWidget {
  const _DashboardCardSettingsDialog({
    required this.cardTitle,
    required this.currentConfig,
    required this.availableSettings,
  });

  final String cardTitle;
  final DashboardCardConfig currentConfig;
  final Set<DashboardCardSettingType> availableSettings;

  @override
  State<_DashboardCardSettingsDialog> createState() =>
      _DashboardCardSettingsDialogState();
}

class _DashboardCardSettingsDialogState
    extends State<_DashboardCardSettingsDialog> {
  late bool _visible;
  late DashboardCardSize _size;
  late int _itemCount;
  late DashboardCardPeriod _period;
  late DashboardCardSortOrder _sortOrder;

  @override
  void initState() {
    super.initState();
    _visible = widget.currentConfig.visible;
    _size = widget.currentConfig.size;
    _itemCount = widget.currentConfig.itemCount;
    _period = widget.currentConfig.period;
    _sortOrder = widget.currentConfig.sortOrder;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final available = widget.availableSettings;

    return AlertDialog(
      title: Text(loc.cardSettingsDialogTitle(widget.cardTitle)),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (available.contains(DashboardCardSettingType.visible)) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(loc.cardSettingsVisibilityLabel),
                  value: _visible,
                  onChanged: (value) => setState(() => _visible = value),
                ),
                const SizedBox(height: 8),
              ],
              if (available.contains(DashboardCardSettingType.size)) ...[
                Text(
                  loc.cardSettingsSizeLabel,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<DashboardCardSize>(
                  segments: [
                    ButtonSegment(
                      value: DashboardCardSize.compact,
                      label: Text(loc.cardSettingsSizeCompact),
                    ),
                    ButtonSegment(
                      value: DashboardCardSize.normal,
                      label: Text(loc.cardSettingsSizeNormal),
                    ),
                    ButtonSegment(
                      value: DashboardCardSize.large,
                      label: Text(loc.cardSettingsSizeLarge),
                    ),
                  ],
                  selected: {_size},
                  onSelectionChanged: (value) =>
                      setState(() => _size = value.first),
                ),
                const SizedBox(height: 16),
              ],
              if (available.contains(DashboardCardSettingType.itemCount)) ...[
                Text(
                  loc.cardSettingsItemCountLabel(_itemCount),
                  style: theme.textTheme.titleSmall,
                ),
                Slider(
                  value: _itemCount.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _itemCount.toString(),
                  onChanged: (value) =>
                      setState(() => _itemCount = value.round()),
                ),
                const SizedBox(height: 8),
              ],
              if (available.contains(DashboardCardSettingType.period)) ...[
                Text(
                  loc.cardSettingsPeriodLabel,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                DropdownButton<DashboardCardPeriod>(
                  isExpanded: true,
                  value: _period,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _period = value);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: DashboardCardPeriod.today,
                      child: Text(loc.cardSettingsPeriodToday),
                    ),
                    DropdownMenuItem(
                      value: DashboardCardPeriod.week,
                      child: Text(loc.cardSettingsPeriodWeek),
                    ),
                    DropdownMenuItem(
                      value: DashboardCardPeriod.month,
                      child: Text(loc.cardSettingsPeriodMonth),
                    ),
                    DropdownMenuItem(
                      value: DashboardCardPeriod.all,
                      child: Text(loc.cardSettingsPeriodAll),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (available.contains(DashboardCardSettingType.sortOrder)) ...[
                Text(
                  loc.cardSettingsSortOrderLabel,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                DropdownButton<DashboardCardSortOrder>(
                  isExpanded: true,
                  value: _sortOrder,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sortOrder = value);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: DashboardCardSortOrder.newest,
                      child: Text(loc.cardSettingsSortNewest),
                    ),
                    DropdownMenuItem(
                      value: DashboardCardSortOrder.oldest,
                      child: Text(loc.cardSettingsSortOldest),
                    ),
                    DropdownMenuItem(
                      value: DashboardCardSortOrder.alphabetical,
                      child: Text(loc.cardSettingsSortAlphabetical),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () {
            final config = DashboardCardConfig(
              visible: _visible,
              size: _size,
              itemCount: _itemCount,
              period: _period,
              sortOrder: _sortOrder,
            );
            Navigator.of(context).pop(config);
          },
          child: Text(loc.save),
        ),
      ],
    );
  }
}
