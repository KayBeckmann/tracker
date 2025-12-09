import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import '../notes/note_drawing_page.dart';
import '../notes/note_edit_page.dart';
import '../time_tracking/time_tracking_types.dart';
import 'task_edit_page.dart';
import 'task_time_section.dart';

enum TaskSortMode { dueDateAsc, dueDateDesc, priority, status }

class TasksPage extends StatefulWidget {
  const TasksPage({
    super.key,
    required this.database,
    required this.timeTrackingRounding,
  });

  final AppDatabase database;
  final TimeTrackingRounding timeTrackingRounding;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateTime? _selectedDay;
  late DateTime _calendarMonth;
  final Set<TaskStatus> _selectedStatuses = {...TaskStatus.values};
  final Set<TaskPriority> _selectedPriorities = {...TaskPriority.values};
  TaskSortMode _sortMode = TaskSortMode.dueDateAsc;
  bool _showFilters = true;
  List<TaskEntry> _tasks = const <TaskEntry>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _calendarMonth = DateTime(now.year, now.month, 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openTaskForm({TaskEntry? task}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditPage(
          database: widget.database,
          task: task,
          timeTrackingRounding: widget.timeTrackingRounding,
        ),
      ),
    );
  }

  Future<void> _previewLinkedNote(TaskEntry task) async {
    if (task.noteId == null) return;
    final note = await widget.database.getNoteEntryById(task.noteId!);
    if (note == null || !mounted) return;
    await _showNotePreview(note);
  }

  Future<void> _updateTaskStatus(TaskEntry task, TaskStatus status) async {
    if (task.status == status) {
      return;
    }
    final updated = task.copyWith(status: status);
    await widget.database.updateTaskEntry(updated);
  }

  Future<void> _setTaskArchived(TaskEntry task, bool archived) async {
    await widget.database.setTaskArchived(id: task.id, archived: archived);
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<TaskEntry> _applyFilters(List<TaskEntry> tasks) {
    return tasks
        .where(
          (task) =>
              _selectedStatuses.contains(task.status) &&
              _selectedPriorities.contains(task.priority),
        )
        .toList();
  }

  List<TaskEntry> _applySort(List<TaskEntry> tasks) {
    switch (_sortMode) {
      case TaskSortMode.dueDateAsc:
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSortMode.dueDateDesc:
        tasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        break;
      case TaskSortMode.priority:
        final priorityOrder = <TaskPriority, int>{
          TaskPriority.high: 0,
          TaskPriority.medium: 1,
          TaskPriority.low: 2,
        };
        tasks.sort((a, b) {
          final diff = priorityOrder[a.priority]!.compareTo(
            priorityOrder[b.priority]!,
          );
          if (diff != 0) {
            return diff;
          }
          return a.dueDate.compareTo(b.dueDate);
        });
        break;
      case TaskSortMode.status:
        final statusOrder = <TaskStatus, int>{
          TaskStatus.todo: 0,
          TaskStatus.inProgress: 1,
          TaskStatus.done: 2,
        };
        tasks.sort((a, b) {
          final diff = statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
          if (diff != 0) {
            return diff;
          }
          return a.dueDate.compareTo(b.dueDate);
        });
        break;
    }
    return tasks;
  }

  void _toggleStatus(TaskStatus status) {
    setState(() {
      if (!_selectedStatuses.add(status)) {
        _selectedStatuses.remove(status);
      }
      if (_selectedStatuses.isEmpty) {
        _selectedStatuses.addAll(TaskStatus.values);
      }
    });
  }

  void _togglePriority(TaskPriority priority) {
    setState(() {
      if (!_selectedPriorities.add(priority)) {
        _selectedPriorities.remove(priority);
      }
      if (_selectedPriorities.isEmpty) {
        _selectedPriorities.addAll(TaskPriority.values);
      }
    });
  }

  void _changeSort(TaskSortMode mode) {
    setState(() {
      _sortMode = mode;
    });
  }

  String _sortLabel(AppLocalizations loc, TaskSortMode mode) {
    switch (mode) {
      case TaskSortMode.dueDateAsc:
        return loc.tasksSortDueDateAsc;
      case TaskSortMode.dueDateDesc:
        return loc.tasksSortDueDateDesc;
      case TaskSortMode.priority:
        return loc.tasksSortPriority;
      case TaskSortMode.status:
        return loc.tasksSortStatus;
    }
  }

  String _localizedStatus(AppLocalizations loc, TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return loc.tasksStatusTodo;
      case TaskStatus.inProgress:
        return loc.tasksStatusInProgress;
      case TaskStatus.done:
        return loc.tasksStatusDone;
    }
  }

  String _localizedPriority(AppLocalizations loc, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return loc.tasksPriorityLow;
      case TaskPriority.medium:
        return loc.tasksPriorityMedium;
      case TaskPriority.high:
        return loc.tasksPriorityHigh;
    }
  }

  Widget _buildFilters(AppLocalizations loc) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.tasksStatusLabel, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: TaskStatus.values
                .map(
                  (status) => FilterChip(
                    label: Text(_localizedStatus(loc, status)),
                    selected: _selectedStatuses.contains(status),
                    onSelected: (_) => _toggleStatus(status),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(loc.tasksPriorityLabel, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: TaskPriority.values
                .map(
                  (priority) => FilterChip(
                    label: Text(_localizedPriority(loc, priority)),
                    selected: _selectedPriorities.contains(priority),
                    onSelected: (_) => _togglePriority(priority),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(loc.tasksSortLabel, style: theme.textTheme.titleSmall),
              const SizedBox(width: 16),
              DropdownButton<TaskSortMode>(
                value: _sortMode,
                onChanged: (mode) {
                  if (mode != null) {
                    _changeSort(mode);
                  }
                },
                items: TaskSortMode.values
                    .map(
                      (mode) => DropdownMenuItem<TaskSortMode>(
                        value: mode,
                        child: Text(_sortLabel(loc, mode)),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedStatuses
                      ..clear()
                      ..addAll(TaskStatus.values);
                    _selectedPriorities
                      ..clear()
                      ..addAll(TaskPriority.values);
                    _sortMode = TaskSortMode.dueDateAsc;
                  });
                },
                child: Text(loc.tasksFiltersReset),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListView(
    AppLocalizations loc,
    List<TaskEntry> tasks,
    Map<int, TaskTimeInfo> timeInfoByTask, {
    bool showFilters = true,
    bool archivedList = false,
  }) {
    return Column(
      children: [
        if (showFilters)
          AnimatedCrossFade(
            alignment: Alignment.topCenter,
            sizeCurve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showFilters
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [_buildFilters(loc), const Divider(height: 1)],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    loc.tasksEmptyPlaceholder,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _TaskListTile(
                      task: task,
                      onTap: () => _openTaskForm(task: task),
                      onOpenNote: task.noteId == null
                          ? null
                          : () => _previewLinkedNote(task),
                      onStatusChanged: (status) =>
                          _updateTaskStatus(task, status),
                      sortLabelBuilder: (status) =>
                          _localizedStatus(loc, status),
                      priorityLabelBuilder: (priority) =>
                          _localizedPriority(loc, priority),
                      isArchived: archivedList,
                      onToggleArchive: () =>
                          _setTaskArchived(task, !archivedList),
                      timeInfo: timeInfoByTask[task.id],
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.navTasks),
        actions: [
          IconButton(
            tooltip: _showFilters
                ? loc.tasksHideFiltersTooltip
                : loc.tasksShowFiltersTooltip,
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(_showFilters ? Icons.filter_alt_off : Icons.filter_alt),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.tasksTabList),
            Tab(text: loc.tasksTabCalendar),
            Tab(text: loc.tasksTabArchive),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTaskForm(),
        icon: const Icon(Icons.add_task),
        label: Text(loc.tasksCreateButton),
      ),
      body: StreamBuilder<List<TaskEntry>>(
        stream: widget.database.watchTaskEntries(),
        builder: (context, snapshot) {
          _tasks = snapshot.data ?? const <TaskEntry>[];
          final filteredTasks = _applyFilters(_tasks);
          final sortedTasks = _applySort(List<TaskEntry>.from(filteredTasks));
          final DateTime selectedDay = _normalizeDate(
            _selectedDay ?? DateTime.now(),
          );
          final calendarTasks =
              filteredTasks
                  .where(
                    (task) =>
                        _normalizeDate(task.dueDate.toLocal()) == selectedDay,
                  )
                  .toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
          final highlightedDays = filteredTasks
              .map((task) => _normalizeDate(task.dueDate.toLocal()))
              .toSet();
          return StreamBuilder<List<TimeEntry>>(
            stream: widget.database.watchAllTimeEntries(),
            builder: (context, timeSnapshot) {
              final timeEntries = timeSnapshot.data ?? const <TimeEntry>[];
              final timeInfoByTask = groupTimeEntriesByTask(
                timeEntries,
                widget.timeTrackingRounding,
              );
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskListView(loc, sortedTasks, timeInfoByTask),
                  _buildCalendarView(
                    loc,
                    selectedDay,
                    calendarTasks,
                    highlightedDays,
                    timeInfoByTask,
                  ),
                  _buildArchivedTasksTab(loc, timeInfoByTask),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildArchivedTasksTab(
    AppLocalizations loc,
    Map<int, TaskTimeInfo> timeInfoByTask,
  ) {
    return StreamBuilder<List<TaskEntry>>(
      stream: widget.database.watchTaskEntries(archived: true),
      builder: (context, snapshot) {
        final archived = snapshot.data ?? const <TaskEntry>[];
        return _buildTaskListView(
          loc,
          archived,
          timeInfoByTask,
          showFilters: false,
          archivedList: true,
        );
      },
    );
  }

  Widget _buildCalendarView(
    AppLocalizations loc,
    DateTime selectedDay,
    List<TaskEntry> selectedDayTasks,
    Set<DateTime> highlightedDays,
    Map<int, TaskTimeInfo> timeInfoByTask,
  ) {
    final currentMonth = DateTime(_calendarMonth.year, _calendarMonth.month);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).previousPageTooltip,
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(
                    Localizations.localeOf(context).toString(),
                  ).format(currentMonth),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).nextPageTooltip,
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildWeekdayHeader(loc),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: _buildMonthGrid(
            month: currentMonth,
            selectedDay: selectedDay,
            highlightedDays: highlightedDays,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: selectedDayTasks.isEmpty
              ? Center(
                  child: Text(
                    loc.tasksCalendarEmpty,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: selectedDayTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = selectedDayTasks[index];
                    return _CalendarTaskCard(
                      task: task,
                      onTap: () => _openTaskForm(task: task),
                      onOpenNote: task.noteId == null
                          ? null
                          : () => _previewLinkedNote(task),
                      timeInfo: timeInfoByTask[task.id],
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _calendarMonth = DateTime(
        _calendarMonth.year,
        _calendarMonth.month + offset,
        1,
      );
      final normalizedSelected = _selectedDay == null
          ? null
          : _normalizeDate(_selectedDay!);
      if (normalizedSelected == null ||
          normalizedSelected.year != _calendarMonth.year ||
          normalizedSelected.month != _calendarMonth.month) {
        _selectedDay = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
      }
    });
  }

  Widget _buildWeekdayHeader(AppLocalizations loc) {
    final locale = Localizations.localeOf(context).toString();
    final labels = List.generate(7, (index) {
      final date = DateTime(2020, 1, 6 + index); // Monday-based week
      return DateFormat.E(locale).format(date);
    });
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMonthGrid({
    required DateTime month,
    required DateTime selectedDay,
    required Set<DateTime> highlightedDays,
  }) {
    final days = _generateMonthDays(month);
    final theme = Theme.of(context);
    final today = _normalizeDate(DateTime.now());
    final rowCount = days.isEmpty ? 0 : (days.length / 7).ceil();
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double maxGridHeight = (screenHeight * 0.45)
            .clamp(240.0, 360.0)
            .toDouble();
        final double cellWidth =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth / 7
            : 48;
        final double maxCellHeight = rowCount == 0
            ? maxGridHeight
            : maxGridHeight / rowCount;
        const double minCellHeight = 36;
        double cellHeight = cellWidth;
        if (maxCellHeight.isFinite && cellHeight > maxCellHeight) {
          cellHeight = maxCellHeight;
        }
        if (maxCellHeight >= minCellHeight) {
          if (cellHeight < minCellHeight) {
            cellHeight = minCellHeight;
          }
        } else if (maxCellHeight.isFinite) {
          cellHeight = maxCellHeight;
        }
        if (!cellHeight.isFinite || cellHeight <= 0) {
          cellHeight = minCellHeight;
        }
        final double childAspectRatio = cellHeight == 0
            ? 1
            : cellWidth / cellHeight;
        final double gridHeight = rowCount == 0
            ? cellHeight
            : cellHeight * rowCount;

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            itemCount: days.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final normalizedDate = _normalizeDate(day.date);
              final bool isSelected = DateUtils.isSameDay(
                selectedDay,
                normalizedDate,
              );
              final bool isToday = normalizedDate == today;
              final bool hasTask = highlightedDays.contains(normalizedDate);
              final bool isCurrentMonth = day.isCurrentMonth;
              final ColorScheme scheme = theme.colorScheme;
              Color? background;
              Color textColor;
              if (isSelected) {
                background = scheme.primary;
                textColor = scheme.onPrimary;
              } else if (hasTask) {
                background = scheme.primary.withValues(alpha: 0.18);
                textColor = isCurrentMonth
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.4);
              } else if (isToday) {
                background = scheme.secondaryContainer.withValues(alpha: 0.3);
                textColor = scheme.onSurface;
              } else {
                background = Colors.transparent;
                textColor = isCurrentMonth
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.4);
              }

              return Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectDay(day.date),
                    child: Center(
                      child: Text(
                        '${day.date.day}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _selectDay(DateTime date) {
    final normalized = _normalizeDate(date);
    setState(() {
      _selectedDay = normalized;
      _calendarMonth = DateTime(normalized.year, normalized.month);
    });
  }

  List<_MonthDay> _generateMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    // Calculate days before the 1st to reach previous Monday (Monday=1, Sunday=7)
    final firstWeekday = (firstDay.weekday - 1) % 7; // Days before first Monday
    final totalCells = ((firstWeekday + daysInMonth + 6) ~/ 7) * 7;
    final days = <_MonthDay>[];

    // Add days from previous month to fill first week
    for (int i = 0; i < firstWeekday; i++) {
      final date = firstDay.subtract(Duration(days: firstWeekday - i));
      days.add(_MonthDay(date, false));
    }
    // Add all days of current month
    for (int i = 0; i < daysInMonth; i++) {
      final date = DateTime(month.year, month.month, i + 1);
      days.add(_MonthDay(date, true));
    }
    // Add days from next month to complete grid
    final remaining = totalCells - days.length;
    for (int i = 0; i < remaining; i++) {
      final date = DateTime(
        month.year,
        month.month,
        daysInMonth,
      ).add(Duration(days: i + 1));
      days.add(_MonthDay(date, false));
    }
    return days;
  }

  Future<void> _openNoteEditor(NoteEntry note) async {
    if (!mounted) return;
    if (note.kind == NoteKind.drawing) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              DrawingNotePage(database: widget.database, note: note),
        ),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              NoteEditPage(database: widget.database, note: note),
        ),
      );
    }
  }

  List<DrawingElement> _decodeDrawing(String? json) {
    if (json == null || json.trim().isEmpty) {
      return const <DrawingElement>[];
    }
    try {
      final raw = jsonDecode(json) as List<dynamic>;
      return raw
          .whereType<Map<String, dynamic>>()
          .map(DrawingElement.fromJson)
          .toList();
    } catch (_) {
      return const <DrawingElement>[];
    }
  }

  Future<void> _showNotePreview(NoteEntry note) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        final loc = AppLocalizations.of(context);
        final tags = note.tags.trim();
        final children = <Widget>[];
        children.add(
          Text(
            note.title.trim().isEmpty ? loc.notesUntitled : note.title.trim(),
            style: theme.textTheme.titleMedium,
          ),
        );
        if (tags.isNotEmpty) {
          children.add(const SizedBox(height: 8));
          children.add(
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tags
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          );
        }
        children.add(const SizedBox(height: 16));
        if (note.kind == NoteKind.markdown) {
          final content = note.content ?? '';
          children.add(
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SingleChildScrollView(
                child: MarkdownBody(
                  data: content.isEmpty
                      ? loc.notesMarkdownPreviewEmpty
                      : content,
                ),
              ),
            ),
          );
        } else {
          final elements = _decodeDrawing(note.drawingJson);
          children.add(
            SizedBox(
              height: 320,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: CustomPaint(
                    painter: _DrawingPreviewPainter(elements),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          );
        }
        children.add(const SizedBox(height: 16));
        children.add(
          Row(
            children: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop('edit'),
                icon: const Icon(Icons.edit_outlined),
                label: Text(loc.tasksPreviewOpenEditor),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ],
          ),
        );

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        );
      },
    );
    if (!mounted) return;
    if (result == 'edit') {
      await _openNoteEditor(note);
    }
  }
}

class _TaskListTile extends StatelessWidget {
  const _TaskListTile({
    required this.task,
    required this.onTap,
    required this.onOpenNote,
    required this.onStatusChanged,
    required this.sortLabelBuilder,
    required this.priorityLabelBuilder,
    required this.onToggleArchive,
    required this.isArchived,
    this.timeInfo,
  });

  final TaskEntry task;
  final VoidCallback onTap;
  final VoidCallback? onOpenNote;
  final ValueChanged<TaskStatus> onStatusChanged;
  final String Function(TaskStatus) sortLabelBuilder;
  final String Function(TaskPriority) priorityLabelBuilder;
  final VoidCallback onToggleArchive;
  final bool isArchived;
  final TaskTimeInfo? timeInfo;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final dueDate = task.dueDate.toLocal();
    final isOverdue = dueDate.isBefore(DateTime.now());
    final theme = Theme.of(context);
    final reminderAt = task.reminderAt?.toLocal();
    return ListTile(
      leading: _StatusIcon(status: task.status),
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${sortLabelBuilder(task.status)} • ${priorityLabelBuilder(task.priority)}',
          ),
          Text(
            loc.tasksDueDateLabelValue(_formatDate(context, dueDate)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: isOverdue
                  ? theme.colorScheme.error
                  : theme.textTheme.bodySmall?.color,
            ),
          ),
          if (reminderAt != null) ...[
            const SizedBox(height: 4),
            Text(() {
              final parts = _formatDateTimeParts(context, reminderAt);
              return loc.tasksReminderLabelValue(parts.date, parts.time);
            }(), style: theme.textTheme.bodySmall),
          ],
          if (task.tags.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: task.tags
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
            ),
          if (timeInfo != null && timeInfo!.entries.isNotEmpty) ...[
            const SizedBox(height: 8),
            TaskTimeEntriesSection(timeInfo: timeInfo!),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onOpenNote != null)
            IconButton(
              tooltip: loc.tasksOpenLinkedNoteButton,
              onPressed: onOpenNote,
              icon: const Icon(Icons.remove_red_eye_outlined),
            ),
          IconButton(
            tooltip: isArchived
                ? loc.tasksUnarchiveTooltip
                : loc.tasksArchiveTooltip,
            onPressed: onToggleArchive,
            icon: Icon(isArchived ? Icons.unarchive : Icons.archive_outlined),
          ),
          PopupMenuButton<TaskStatus>(
            onSelected: onStatusChanged,
            itemBuilder: (context) => TaskStatus.values
                .map(
                  (status) => PopupMenuItem(
                    value: status,
                    child: Text(sortLabelBuilder(status)),
                  ),
                )
                .toList(),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final localeTag = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(localeTag).format(date);
  }

  ({String date, String time}) _formatDateTimeParts(
    BuildContext context,
    DateTime date,
  ) {
    final localeTag = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.yMMMMd(localeTag).format(date);
    final timeLabel = DateFormat.Hm(localeTag).format(date);
    return (date: dateLabel, time: timeLabel);
  }
}

class _CalendarTaskCard extends StatelessWidget {
  const _CalendarTaskCard({
    required this.task,
    required this.onTap,
    required this.onOpenNote,
    this.timeInfo,
  });

  final TaskEntry task;
  final VoidCallback onTap;
  final VoidCallback? onOpenNote;
  final TaskTimeInfo? timeInfo;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dueDateText = _formatDate(context, task.dueDate.toLocal());
    final reminderAt = task.reminderAt?.toLocal();
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_localizedStatus(loc, task.status)} • ${_localizedPriority(loc, task.priority)} • $dueDateText',
            ),
            if (reminderAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(() {
                  final parts = _formatDateTimeParts(context, reminderAt);
                  return loc.tasksReminderLabelValue(parts.date, parts.time);
                }(), style: theme.textTheme.bodySmall),
              ),
            if (task.tags.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: task.tags
                      .split(',')
                      .map((tag) => tag.trim())
                      .where((tag) => tag.isNotEmpty)
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ),
            if (task.noteId != null)
              TextButton.icon(
                onPressed: onOpenNote,
                icon: const Icon(Icons.description_outlined),
                label: Text(loc.tasksOpenLinkedNoteButton),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
            if (timeInfo != null && timeInfo!.entries.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TaskTimeEntriesSection(timeInfo: timeInfo!),
              ),
          ],
        ),
      ),
    );
  }

  String _localizedStatus(AppLocalizations loc, TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return loc.tasksStatusTodo;
      case TaskStatus.inProgress:
        return loc.tasksStatusInProgress;
      case TaskStatus.done:
        return loc.tasksStatusDone;
    }
  }

  String _localizedPriority(AppLocalizations loc, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return loc.tasksPriorityLow;
      case TaskPriority.medium:
        return loc.tasksPriorityMedium;
      case TaskPriority.high:
        return loc.tasksPriorityHigh;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final localeTag = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(localeTag).format(date);
  }

  ({String date, String time}) _formatDateTimeParts(
    BuildContext context,
    DateTime date,
  ) {
    final localeTag = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.yMMMMd(localeTag).format(date);
    final timeLabel = DateFormat.Hm(localeTag).format(date);
    return (date: dateLabel, time: timeLabel);
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TaskStatus.todo:
        return const Icon(Icons.radio_button_unchecked);
      case TaskStatus.inProgress:
        return const Icon(Icons.timelapse);
      case TaskStatus.done:
        return const Icon(Icons.check_circle, color: Colors.green);
    }
  }
}

class _MonthDay {
  const _MonthDay(this.date, this.isCurrentMonth);

  final DateTime date;
  final bool isCurrentMonth;
}

class _DrawingPreviewPainter extends CustomPainter {
  _DrawingPreviewPainter(this.elements);

  final List<DrawingElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    for (final element in elements) {
      _paintElement(canvas, element);
    }
  }

  void _paintElement(Canvas canvas, DrawingElement element) {
    final paint = Paint()
      ..color = element.color
      ..strokeWidth = element.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (element.tool) {
      case DrawingTool.pen:
        final points = element.points;
        if (points.isEmpty) return;
        if (points.length == 1) {
          final dotPaint = Paint()
            ..color = element.color
            ..style = PaintingStyle.fill;
          canvas.drawCircle(points.first, element.strokeWidth / 2, dotPaint);
          return;
        }
        final path = Path()..moveTo(points.first.dx, points.first.dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, paint);
        return;
      case DrawingTool.eraser:
        final points = element.points;
        if (points.isEmpty) return;
        final eraserPaint = Paint()
          ..blendMode = BlendMode.clear
          ..strokeWidth = element.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;
        if (points.length == 1) {
          final dotPaint = Paint()
            ..blendMode = BlendMode.clear
            ..style = PaintingStyle.fill;
          canvas.drawCircle(points.first, element.strokeWidth / 2, dotPaint);
          return;
        }
        final path = Path()..moveTo(points.first.dx, points.first.dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, eraserPaint);
        return;
      case DrawingTool.line:
        if (element.points.length < 2) return;
        canvas.drawLine(element.points.first, element.points.last, paint);
        return;
      case DrawingTool.rectangle:
        if (element.points.length < 2) return;
        final rect = Rect.fromPoints(element.points.first, element.points.last);
        canvas.drawRect(rect, paint);
        return;
      case DrawingTool.ellipse:
        if (element.points.length < 2) return;
        final rect = Rect.fromPoints(element.points.first, element.points.last);
        canvas.drawOval(rect, paint);
        return;
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPreviewPainter oldDelegate) {
    return !identical(oldDelegate.elements, elements);
  }
}
