import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({
    super.key,
    required this.database,
    required this.templates,
    required this.enabledCategories,
    this.initialCategory,
    this.onLock,
    this.showLockButton = false,
  });

  final AppDatabase database;
  final Map<JournalCategory, String> templates;
  final List<JournalCategory> enabledCategories;
  final JournalCategory? initialCategory;
  final VoidCallback? onLock;
  final bool showLockButton;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _entryController = TextEditingController();
  final FocusNode _editorFocusNode = FocusNode();

  StreamSubscription<List<JournalEntry>>? _entriesSub;
  StreamSubscription<List<JournalTracker>>? _trackersSub;
  StreamSubscription<List<JournalTrackerValue>>? _valuesSub;

  List<JournalEntry> _entries = const [];
  List<JournalTracker> _trackers = const [];
  List<JournalTrackerValue> _values = const [];

  late JournalCategory _activeCategory;
  late DateTime _selectedDay;
  late DateTime _calendarMonth;
  bool _isDirty = false;
  bool _isApplyingControllerValue = false;

  List<JournalCategory> _effectiveCategories() {
    if (widget.enabledCategories.isEmpty) {
      return const [JournalCategory.personal];
    }
    return List<JournalCategory>.from(widget.enabledCategories);
  }

  String _templateForCategory(JournalCategory category) {
    return widget.templates[category] ?? '';
  }

  String _categoryLabel(AppLocalizations loc, JournalCategory category) {
    switch (category) {
      case JournalCategory.personal:
        return loc.journalCategoryPersonal;
      case JournalCategory.work:
        return loc.journalCategoryWork;
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _calendarMonth = DateTime(now.year, now.month, 1);
    final categories = _effectiveCategories();
    final initial = widget.initialCategory;
    if (initial != null && categories.contains(initial)) {
      _activeCategory = initial;
    } else {
      _activeCategory = categories.first;
    }
    _tabController = TabController(length: 2, vsync: this);
    _entryController.addListener(_handleControllerChanged);
    _subscribeEntries();
    _trackersSub = widget.database.watchJournalTrackers().listen((trackers) {
      if (!mounted) return;
      setState(() {
        _trackers = trackers;
      });
    });
    _valuesSub = widget.database.watchJournalTrackerValues().listen((values) {
      if (!mounted) return;
      setState(() {
        _values = values;
      });
    });
  }

  void _subscribeEntries() {
    _entriesSub?.cancel();
    _entriesSub = widget.database
        .watchJournalEntries(_activeCategory)
        .listen((entries) {
      if (!mounted) {
        return;
      }
      setState(() {
        _entries = entries;
      });
      _syncCurrentEntry();
    });
  }

  @override
  void didUpdateWidget(covariant JournalPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCategories = oldWidget.enabledCategories.isEmpty
        ? const [JournalCategory.personal]
        : List<JournalCategory>.from(oldWidget.enabledCategories);
    final newCategories = _effectiveCategories();
    bool categoriesChanged = oldCategories.length != newCategories.length;
    if (!categoriesChanged) {
      for (var i = 0; i < newCategories.length; i++) {
        if (oldCategories[i] != newCategories[i]) {
          categoriesChanged = true;
          break;
        }
      }
    }
    if (!newCategories.contains(_activeCategory)) {
      _activeCategory = newCategories.first;
      _subscribeEntries();
      if (!_isDirty) {
        _applyControllerText(_templateForCategory(_activeCategory));
      }
    } else if (categoriesChanged) {
      _subscribeEntries();
    }

    final oldTemplate = oldWidget.templates[_activeCategory] ?? '';
    final newTemplate = _templateForCategory(_activeCategory);
    if (newTemplate != oldTemplate && !_isDirty) {
      final current = _currentEntry;
      if (current == null ||
          _normalizeToDay(current.entryDate) != _normalizeToDay(_selectedDay)) {
        _applyControllerText(newTemplate);
      }
    }
  }

  @override
  void dispose() {
    _entriesSub?.cancel();
    _trackersSub?.cancel();
    _valuesSub?.cancel();
    _tabController.dispose();
    _entryController
      ..removeListener(_handleControllerChanged)
      ..dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (_isApplyingControllerValue) {
      return;
    }
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  JournalEntry? get _currentEntry {
    final normalized = _normalizeToDay(_selectedDay);
    for (final entry in _entries) {
      if (_normalizeToDay(entry.entryDate) == normalized) {
        return entry;
      }
    }
    return null;
  }

  void _syncCurrentEntry() {
    final entry = _currentEntry;
    if (entry == null) {
      if (!_isDirty) {
        _applyControllerText(_templateForCategory(_activeCategory));
      }
      return;
    }
    if (_isDirty) {
      return;
    }
    _applyControllerText(entry.content);
  }

  void _applyControllerText(String text) {
    _isApplyingControllerValue = true;
    _entryController
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    _isApplyingControllerValue = false;
    setState(() {
      _isDirty = false;
    });
  }

  Set<DateTime> get _highlightedDays {
    final days = <DateTime>{};
    for (final entry in _entries) {
      days.add(_normalizeToDay(entry.entryDate));
    }
    for (final value in _values) {
      days.add(_normalizeToDay(value.entryDate));
    }
    return days;
  }

  DateTime _normalizeToDay(DateTime date) {
    final local = date.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  Future<void> _changeMonth(int delta) async {
    setState(() {
      _calendarMonth = DateTime(
        _calendarMonth.year,
        _calendarMonth.month + delta,
        1,
      );
    });
  }

  Future<void> _selectDay(DateTime day) async {
    if (_normalizeToDay(day) == _normalizeToDay(_selectedDay)) {
      return;
    }
    if (_isDirty) {
      final action = await _promptPendingChanges();
      if (!mounted || action == _PendingChangeAction.cancel) {
        return;
      }
      if (action == _PendingChangeAction.save) {
        final success = await _saveEntry(showFeedback: false);
        if (!success || !mounted) {
          return;
        }
      } else if (action == _PendingChangeAction.discard) {
        setState(() {
          _isDirty = false;
        });
      }
    }
    setState(() {
      _selectedDay = _normalizeToDay(day);
      _calendarMonth = DateTime(day.year, day.month, 1);
    });
    _syncCurrentEntry();
  }

  Future<void> _changeCategory(JournalCategory category) async {
    if (_activeCategory == category) {
      return;
    }
    if (_isDirty) {
      final action = await _promptPendingChanges();
      if (!mounted || action == _PendingChangeAction.cancel) {
        return;
      }
      if (action == _PendingChangeAction.save) {
        final success = await _saveEntry(showFeedback: false);
        if (!success || !mounted) {
          return;
        }
      } else if (action == _PendingChangeAction.discard) {
        setState(() {
          _isDirty = false;
        });
      }
    }
    setState(() {
      _activeCategory = category;
      _entries = const [];
    });
    _applyControllerText(_templateForCategory(category));
    _subscribeEntries();
  }

  Future<_PendingChangeAction> _promptPendingChanges() async {
    final loc = AppLocalizations.of(context);
    final result = await showDialog<_PendingChangeAction>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.journalUnsavedChangesTitle),
          content: Text(loc.journalUnsavedChangesMessage),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(_PendingChangeAction.cancel),
              child: Text(loc.commonCancel),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(_PendingChangeAction.discard),
              child: Text(loc.journalDiscardChanges),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_PendingChangeAction.save),
              child: Text(loc.commonSave),
            ),
          ],
        );
      },
    );
    return result ?? _PendingChangeAction.cancel;
  }

  Future<bool> _saveEntry({bool showFeedback = true}) async {
    final loc = AppLocalizations.of(context);
    final content = _entryController.text.trim();
    try {
      await widget.database.upsertJournalEntry(
        date: _selectedDay,
        content: content,
        category: _activeCategory,
      );
      if (!mounted) {
        return true;
      }
      setState(() {
        _isDirty = false;
      });
      if (showFeedback) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.journalEntrySaved)));
      }
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.journalEntrySaveError)));
      return false;
    }
  }

  Future<void> _deleteEntry() async {
    final loc = AppLocalizations.of(context);
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.journalDeleteEntryTitle),
            content: Text(loc.journalDeleteEntryMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(loc.commonDelete),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await widget.database.deleteJournalEntry(
      _selectedDay,
      _activeCategory,
    );
    if (!mounted) {
      return;
    }
    _applyControllerText(_templateForCategory(_activeCategory));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.journalEntryDeleted)));
  }

  Future<void> _applyTemplate() async {
    final template = _templateForCategory(_activeCategory);
    if (_entryController.text.trim() == template.trim()) {
      return;
    }
    if (_isDirty) {
      final loc = AppLocalizations.of(context);
      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(loc.journalApplyTemplateTitle),
              content: Text(loc.journalApplyTemplateMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(loc.commonCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(loc.journalApplyTemplateButton),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirmed) {
        return;
      }
    }
    _applyControllerText(template);
  }

  JournalTrackerValue? _valueForTracker(int trackerId) {
    final targetDay = _normalizeToDay(_selectedDay);
    for (final value in _values) {
      if (value.trackerId == trackerId &&
          _normalizeToDay(value.entryDate) == targetDay) {
        return value;
      }
    }
    return null;
  }

  Future<void> _setTrackerValue({
    required JournalTracker tracker,
    required int value,
  }) async {
    await widget.database.setJournalTrackerValue(
      trackerId: tracker.id,
      date: _selectedDay,
      value: value,
    );
  }

  Future<void> _clearTrackerValue(JournalTracker tracker) async {
    await widget.database.clearJournalTrackerValue(
      trackerId: tracker.id,
      date: _selectedDay,
    );
  }

  Future<void> _handleReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final updated = List<JournalTracker>.from(_trackers);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    setState(() {
      _trackers = updated;
    });
    await widget.database.reorderJournalTrackers(
      updated.map((tracker) => tracker.id).toList(),
    );
  }

  Future<void> _promptAddTracker() async {
    final loc = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    JournalTrackerKind kind = JournalTrackerKind.checkbox;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.journalAddTrackerTitle),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: loc.journalTrackerNameLabel,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.journalTrackerNameError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<JournalTrackerKind>(
                    value: kind,
                    decoration: InputDecoration(
                      labelText: loc.journalTrackerKindLabel,
                    ),
                    items: JournalTrackerKind.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value == JournalTrackerKind.checkbox
                                  ? loc.journalTrackerKindCheckbox
                                  : loc.journalTrackerKindRating,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        kind = value;
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: loc.journalTrackerDescriptionLabel,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.commonCancel),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  Navigator.of(context).pop(true);
                },
                child: Text(loc.commonCreate),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await widget.database.insertJournalTracker(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      kind: kind,
    );
  }

  Future<void> _promptEditTracker(JournalTracker tracker) async {
    final loc = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: tracker.name);
    final descriptionController = TextEditingController(
      text: tracker.description,
    );
    JournalTrackerKind kind = tracker.kind;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.journalEditTrackerTitle),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: loc.journalTrackerNameLabel,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.journalTrackerNameError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<JournalTrackerKind>(
                    value: kind,
                    decoration: InputDecoration(
                      labelText: loc.journalTrackerKindLabel,
                    ),
                    items: JournalTrackerKind.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value == JournalTrackerKind.checkbox
                                  ? loc.journalTrackerKindCheckbox
                                  : loc.journalTrackerKindRating,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        kind = value;
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: loc.journalTrackerDescriptionLabel,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.commonCancel),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  Navigator.of(context).pop(true);
                },
                child: Text(loc.commonSave),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await widget.database.updateJournalTracker(
      tracker.copyWith(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        kind: kind,
      ),
    );
  }

  Future<void> _deleteTracker(JournalTracker tracker) async {
    final loc = AppLocalizations.of(context);
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.journalDeleteTrackerTitle),
            content: Text(loc.journalDeleteTrackerMessage(tracker.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(loc.commonDelete),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await widget.database.deleteJournalTracker(tracker.id);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final calendar = _buildCalendarCard(loc, theme);
    final editor = _buildEditorCard(loc, theme);
    final trends = _buildTrendsCard(loc, theme);
    final trackers = _buildTrackerCard(loc, theme);

    final isWide = MediaQuery.of(context).size.width >= 1100;
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [calendar, const SizedBox(height: 16), trends],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView(
              children: [editor, const SizedBox(height: 16), trackers],
            ),
          ),
        ],
      );
    }

    return ListView(
      children: [
        calendar,
        const SizedBox(height: 16),
        trends,
        const SizedBox(height: 16),
        editor,
        const SizedBox(height: 16),
        trackers,
      ],
    );
  }

  Widget _buildCalendarCard(AppLocalizations loc, ThemeData theme) {
    final dateFormat = DateFormat.yMMMM(loc.localeName);
    final weekdayFormat = DateFormat.E(loc.localeName);
    final monthLabel = dateFormat.format(_calendarMonth);
    final days = _generateMonthDays(_calendarMonth);
    final highlight = _highlightedDays;

    final weekdayNames = List.generate(7, (index) {
      final date = DateTime(2023, 1, 2 + index);
      return weekdayFormat.format(date);
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: loc.journalCalendarPrevious,
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text(monthLabel, style: theme.textTheme.titleMedium),
                  ),
                ),
                IconButton(
                  tooltip: loc.journalCalendarNext,
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final name in weekdayNames)
                  Center(child: Text(name, style: theme.textTheme.labelSmall)),
                for (final day in days)
                  _JournalCalendarDay(
                    day: day,
                    isSelected:
                        _normalizeToDay(day.date) ==
                        _normalizeToDay(_selectedDay),
                    hasActivity: highlight.contains(_normalizeToDay(day.date)),
                    onSelected: _selectDay,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsCard(AppLocalizations loc, ThemeData theme) {
    if (_trackers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.journalTrendsTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(loc.journalTrendsEmpty, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    final today = _normalizeToDay(DateTime.now());
    final start = today.subtract(const Duration(days: 29));
    final shortFormat = DateFormat.Md(loc.localeName);
    final dateRangeLabel = loc.journalTrendDateRange(
      shortFormat.format(start),
      shortFormat.format(today),
    );

    final children = <Widget>[
      Text(loc.journalTrendsTitle, style: theme.textTheme.titleMedium),
      const SizedBox(height: 4),
      Text(loc.journalTrendsDescription, style: theme.textTheme.bodyMedium),
      const SizedBox(height: 4),
      Text(dateRangeLabel, style: theme.textTheme.bodySmall),
      const SizedBox(height: 16),
    ];

    for (final tracker in _trackers) {
      final samples = _buildTrendSamplesForTracker(
        tracker: tracker,
        start: start,
        end: today,
      );
      final hasData = samples.any((sample) => sample.value != null);
      final legendText = tracker.kind == JournalTrackerKind.checkbox
          ? loc.journalTrendLegendCheckbox
          : loc.journalTrendLegendRating;

      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tracker.name, style: theme.textTheme.titleMedium),
            if (tracker.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  tracker.description,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(legendText, style: theme.textTheme.labelSmall),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: hasData
                  ? _TrackerTrendChart(
                      samples: samples,
                      maxValue: _maxValueForTracker(tracker),
                      dateFormat: shortFormat,
                    )
                  : Center(
                      child: Text(
                        loc.journalTrendNoData,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 16));
    }
    if (children.isNotEmpty) {
      children.removeLast();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  List<_TrendSample> _buildTrendSamplesForTracker({
    required JournalTracker tracker,
    required DateTime start,
    required DateTime end,
  }) {
    final normalizedStart = _normalizeToDay(start);
    final normalizedEnd = _normalizeToDay(end);
    final map = <DateTime, double>{};
    for (final value in _values) {
      if (value.trackerId != tracker.id) {
        continue;
      }
      final date = _normalizeToDay(value.entryDate);
      if (date.isBefore(normalizedStart) || date.isAfter(normalizedEnd)) {
        continue;
      }
      final sanitized = tracker.kind == JournalTrackerKind.checkbox
          ? (value.value >= 1 ? 1.0 : 0.0)
          : value.value.clamp(0, 5).toDouble();
      map[date] = sanitized;
    }

    final totalDays = normalizedEnd.difference(normalizedStart).inDays + 1;
    return List.generate(totalDays, (index) {
      final date = normalizedStart.add(Duration(days: index));
      final double? stored = map[date];
      return _TrendSample(date: date, value: stored);
    });
  }

  double _maxValueForTracker(JournalTracker tracker) {
    return tracker.kind == JournalTrackerKind.checkbox ? 1 : 5;
  }

  Widget _buildEditorCard(AppLocalizations loc, ThemeData theme) {
    final entry = _currentEntry;
    final subtitle = entry == null
        ? loc.journalNoEntryForDay
        : loc.journalLastUpdated(
            DateFormat.yMMMMd(
              loc.localeName,
            ).add_Hm().format(entry.updatedAt.toLocal()),
          );
    final categories = _effectiveCategories();
    final hasMultipleCategories = categories.length > 1;
    final bool canSave = _isDirty || entry == null;
    final actions = <Widget>[
      FilledButton.icon(
        onPressed: canSave ? () => _saveEntry() : null,
        icon: const Icon(Icons.save),
        label: Text(loc.commonSave),
      ),
      const SizedBox(width: 8),
      OutlinedButton.icon(
        onPressed: _applyTemplate,
        icon: const Icon(Icons.replay),
        label: Text(loc.journalApplyTemplateButton),
      ),
      const SizedBox(width: 8),
      if (entry != null)
        TextButton.icon(
          onPressed: _deleteEntry,
          icon: const Icon(Icons.delete),
          label: Text(loc.commonDelete),
        ),
      if (widget.showLockButton && widget.onLock != null) ...[
        const SizedBox(width: 8),
        IconButton(
          tooltip: loc.journalLockTooltip,
          onPressed: widget.onLock,
          icon: const Icon(Icons.lock_outline),
        ),
      ],
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMEEEEd(loc.localeName).format(_selectedDay),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            if (hasMultipleCategories) ...[
              Text(
                loc.journalCategorySelectionLabel,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<JournalCategory>(
                segments: categories
                    .map(
                      (category) => ButtonSegment(
                        value: category,
                        label: Text(_categoryLabel(loc, category)),
                      ),
                    )
                    .toList(),
                selected: <JournalCategory>{_activeCategory},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) {
                    return;
                  }
                  final category = selection.first;
                  _changeCategory(category);
                },
              ),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: loc.journalTabEdit),
                        Tab(text: loc.journalTabPreview),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 320,
              child: TabBarView(
                controller: _tabController,
                children: [
                  TextField(
                    controller: _entryController,
                    focusNode: _editorFocusNode,
                    maxLines: null,
                    expands: true,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: loc.journalEditorHint,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: _entryController.text.trim().isEmpty
                        ? Center(
                            child: Text(
                              loc.journalPreviewEmpty,
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Markdown(
                            data: _entryController.text,
                            styleSheet: MarkdownStyleSheet.fromTheme(theme),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: actions),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackerCard(AppLocalizations loc, ThemeData theme) {
    final tiles = _trackers;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    loc.journalTrackersSectionTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                FilledButton.icon(
                  onPressed: _promptAddTracker,
                  icon: const Icon(Icons.add),
                  label: Text(loc.journalAddTrackerButton),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (tiles.isEmpty)
              Text(loc.journalTrackersEmpty, style: theme.textTheme.bodyMedium)
            else
              ReorderableListView.builder(
                itemCount: tiles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: _handleReorder,
                buildDefaultDragHandles: false,
                itemBuilder: (context, index) {
                  final tracker = tiles[index];
                  final value = _valueForTracker(tracker.id);
                  return ListTile(
                    key: ValueKey<int>(tracker.id),
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    title: Text(tracker.name),
                    subtitle: tracker.description.isEmpty
                        ? null
                        : Text(tracker.description),
                    trailing: _buildTrackerTrailing(loc, tracker, value),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackerTrailing(
    AppLocalizations loc,
    JournalTracker tracker,
    JournalTrackerValue? value,
  ) {
    final theme = Theme.of(context);
    switch (tracker.kind) {
      case JournalTrackerKind.checkbox:
        final checked = value?.value == 1;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: checked,
              onChanged: (selected) {
                if (selected == true) {
                  _setTrackerValue(tracker: tracker, value: 1);
                } else {
                  _clearTrackerValue(tracker);
                }
              },
            ),
            PopupMenuButton<_TrackerMenuAction>(
              onSelected: (action) => _handleTrackerMenu(action, tracker),
              itemBuilder: (context) => _trackerMenuItems(loc, tracker),
            ),
          ],
        );
      case JournalTrackerKind.rating:
        final rating = value?.value ?? 0;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                tooltip: loc.journalTrackerRatingTooltip(i),
                icon: Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  color: i <= rating
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () => _setTrackerValue(tracker: tracker, value: i),
              ),
            IconButton(
              tooltip: loc.journalTrackerClearTooltip,
              icon: const Icon(Icons.close),
              onPressed: () => _clearTrackerValue(tracker),
            ),
            PopupMenuButton<_TrackerMenuAction>(
              onSelected: (action) => _handleTrackerMenu(action, tracker),
              itemBuilder: (context) => _trackerMenuItems(loc, tracker),
            ),
          ],
        );
    }
  }

  List<PopupMenuEntry<_TrackerMenuAction>> _trackerMenuItems(
    AppLocalizations loc,
    JournalTracker tracker,
  ) {
    return [
      PopupMenuItem(
        value: _TrackerMenuAction.edit,
        child: Text(loc.commonEdit),
      ),
      PopupMenuItem(
        value: _TrackerMenuAction.delete,
        child: Text(loc.commonDelete),
      ),
    ];
  }

  void _handleTrackerMenu(_TrackerMenuAction action, JournalTracker tracker) {
    switch (action) {
      case _TrackerMenuAction.edit:
        _promptEditTracker(tracker);
        break;
      case _TrackerMenuAction.delete:
        _deleteTracker(tracker);
        break;
    }
  }

  List<_CalendarDayEntry> _generateMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDay.weekday % 7;
    final daysBefore = firstWeekday;
    final firstDisplayDay = firstDay.subtract(Duration(days: daysBefore));
    final totalDays = 42;
    return List.generate(totalDays, (index) {
      final date = firstDisplayDay.add(Duration(days: index));
      final isCurrentMonth = date.month == month.month;
      return _CalendarDayEntry(date: date, isCurrentMonth: isCurrentMonth);
    });
  }
}

enum _PendingChangeAction { save, discard, cancel }

enum _TrackerMenuAction { edit, delete }

class _TrendSample {
  const _TrendSample({required this.date, this.value});

  final DateTime date;
  final double? value;
}

class _TrackerTrendChart extends StatelessWidget {
  const _TrackerTrendChart({
    required this.samples,
    required this.maxValue,
    required this.dateFormat,
  });

  final List<_TrendSample> samples;
  final double maxValue;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: _TrendChartPainter(
        samples: samples,
        maxValue: maxValue,
        lineColor: colorScheme.primary,
        gridColor: colorScheme.outlineVariant,
        labelColor: colorScheme.onSurface.withValues(
          alpha: colorScheme.onSurface.a * 0.7,
        ),
        dateFormat: dateFormat,
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  _TrendChartPainter({
    required this.samples,
    required this.maxValue,
    required this.lineColor,
    required this.gridColor,
    required this.labelColor,
    required this.dateFormat,
  });

  final List<_TrendSample> samples;
  final double maxValue;
  final Color lineColor;
  final Color gridColor;
  final Color labelColor;
  final DateFormat dateFormat;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty || maxValue <= 0) {
      return;
    }

    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    const double labelSpace = 20;
    final double chartHeight = math.max(0.0, size.height - labelSpace);
    if (chartHeight <= 0) {
      return;
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final baselinePaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final axisPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final subdivisions = maxValue == 1 ? 1 : 5;
    for (var i = 0; i <= subdivisions; i++) {
      final y = chartHeight - (i / subdivisions) * chartHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    canvas.drawLine(
      Offset(0, chartHeight),
      Offset(size.width, chartHeight),
      baselinePaint,
    );

    final int tickCount = samples.length <= 1 ? 1 : 4;
    for (var i = 0; i <= tickCount; i++) {
      final double fraction = tickCount == 0 ? 0 : i / tickCount;
      final double x = size.width * fraction;
      canvas.drawLine(
        Offset(x, chartHeight),
        Offset(x, chartHeight + 4),
        axisPaint,
      );
      final int index = samples.length <= 1
          ? 0
          : (fraction * (samples.length - 1)).round().clamp(
              0,
              samples.length - 1,
            );
      final String label = dateFormat.format(samples[index].date);
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: labelColor, fontSize: 10),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      final double maxLabelX = math.max(0.0, size.width - textPainter.width);
      final double desired = x - textPainter.width / 2;
      final double labelX = math.max(0.0, math.min(maxLabelX, desired));
      textPainter.paint(canvas, Offset(labelX, chartHeight + 6));
    }

    final denominator = samples.length <= 1
        ? 1.0
        : (samples.length - 1).toDouble();
    final path = Path();
    var hasSegment = false;
    for (var i = 0; i < samples.length; i++) {
      final sample = samples[i];
      final value = sample.value;
      if (value == null) {
        hasSegment = false;
        continue;
      }
      final clamped = value.clamp(0.0, maxValue);
      final x = samples.length <= 1
          ? size.width / 2
          : (i / denominator) * size.width;
      final y = chartHeight - (clamped / maxValue) * chartHeight;
      if (!hasSegment) {
        path.moveTo(x, y);
        hasSegment = true;
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    for (var i = 0; i < samples.length; i++) {
      final value = samples[i].value;
      if (value == null) {
        continue;
      }
      final clamped = value.clamp(0.0, maxValue);
      final x = samples.length <= 1
          ? size.width / 2
          : (i / denominator) * size.width;
      final y = chartHeight - (clamped / maxValue) * chartHeight;
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return true;
  }
}

class _CalendarDayEntry {
  const _CalendarDayEntry({required this.date, required this.isCurrentMonth});

  final DateTime date;
  final bool isCurrentMonth;
}

class _JournalCalendarDay extends StatelessWidget {
  const _JournalCalendarDay({
    required this.day,
    required this.isSelected,
    required this.hasActivity,
    required this.onSelected,
  });

  final _CalendarDayEntry day;
  final bool isSelected;
  final bool hasActivity;
  final ValueChanged<DateTime> onSelected;

  bool get _isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(day.date.year, day.date.month, day.date.day);
    return date == today;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = theme.textTheme.bodyMedium?.color;
    final fadedColor = baseColor?.withValues(alpha: baseColor.a * 0.6);
    final textStyle = day.isCurrentMonth
        ? theme.textTheme.bodyMedium
        : theme.textTheme.bodyMedium?.copyWith(color: fadedColor);
    final backgroundColor = isSelected
        ? colorScheme.primaryContainer
        : Colors.transparent;
    final borderColor = _isToday
        ? colorScheme.primary
        : isSelected
        ? colorScheme.primary
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onSelected(day.date),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${day.date.day}', style: textStyle),
                if (hasActivity)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
