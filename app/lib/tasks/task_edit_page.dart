import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import '../notes/note_drawing_page.dart';
import '../notes/note_edit_page.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key, required this.database, this.task});

  final AppDatabase database;
  final TaskEntry? task;

  bool get isEditing => task != null;

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _tagsController;
  late TaskStatus _status;
  late TaskPriority _priority;
  late DateTime _dueDate;
  NoteEntry? _linkedNote;
  bool _isSaving = false;

  Future<void> _syncLinkedNoteTags(String tags) async {
    if (_linkedNote == null) {
      return;
    }
    final note = await widget.database.getNoteEntryById(_linkedNote!.id);
    if (note == null) {
      return;
    }
    if (note.tags == tags) {
      return;
    }
    final updated = note.copyWith(tags: tags);
    await widget.database.updateNoteEntry(updated);
    if (!mounted) {
      return;
    }
    setState(() {
      _linkedNote = updated;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _tagsController = TextEditingController(text: widget.task?.tags);
    _status = widget.task?.status ?? TaskStatus.todo;
    _priority = widget.task?.priority ?? TaskPriority.medium;
    final initialDueDate = widget.task?.dueDate.toLocal() ?? DateTime.now();
    _dueDate = DateTime(
      initialDueDate.year,
      initialDueDate.month,
      initialDueDate.day,
    );
    final noteId = widget.task?.noteId;
    if (noteId != null) {
      widget.database.getNoteEntryById(noteId).then((note) {
        if (!mounted) return;
        setState(() {
          _linkedNote = note;
        });
        _syncLinkedNoteTags(_normalizeTags(_tagsController.text));
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  String _normalizeTags(String source) {
    final tags = source
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    return tags.join(', ');
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _selectNote(AppLocalizations loc) async {
    final selectedNote = await showModalBottomSheet<NoteEntry>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, controller) {
            return StreamBuilder<List<NoteEntry>>(
              stream: widget.database.watchNoteEntries(),
              builder: (context, snapshot) {
                final notes = snapshot.data ?? const <NoteEntry>[];
                if (notes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        loc.tasksNoNotesFound,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  controller: controller,
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      leading: Icon(
                        note.kind == NoteKind.drawing
                            ? Icons.brush
                            : Icons.notes,
                      ),
                      title: Text(
                        note.title.trim().isEmpty
                            ? loc.notesUntitled
                            : note.title.trim(),
                      ),
                      subtitle: note.tags.trim().isEmpty
                          ? null
                          : Text('${loc.notesTagLabel}: ${note.tags}'),
                      onTap: () => Navigator.of(context).pop(note),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
    if (selectedNote != null) {
      if (!mounted) return;
      setState(() {
        _linkedNote = selectedNote;
      });
      await _syncLinkedNoteTags(_normalizeTags(_tagsController.text));
    }
  }

  Future<void> _createNote(AppLocalizations loc) async {
    final noteKind = await showModalBottomSheet<NoteKind>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notes),
              title: Text(loc.tasksCreateMarkdownNote),
              onTap: () => Navigator.of(context).pop(NoteKind.markdown),
            ),
            ListTile(
              leading: const Icon(Icons.brush),
              title: Text(loc.tasksCreateDrawingNote),
              onTap: () => Navigator.of(context).pop(NoteKind.drawing),
            ),
          ],
        ),
      ),
    );
    if (noteKind == null) return;
    if (!mounted) return;

    int? noteId;
    final navigator = Navigator.of(context);
    if (noteKind == NoteKind.markdown) {
      noteId = await navigator.push<int>(
        MaterialPageRoute(
          builder: (context) => NoteEditPage(database: widget.database),
        ),
      );
    } else {
      noteId = await navigator.push<int>(
        MaterialPageRoute(
          builder: (context) => DrawingNotePage(database: widget.database),
        ),
      );
    }
    if (!mounted) return;
    if (noteId != null) {
      final note = await widget.database.getNoteEntryById(noteId);
      if (mounted) {
        setState(() {
          _linkedNote = note;
        });
      }
      await _syncLinkedNoteTags(_normalizeTags(_tagsController.text));
    }
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.tasksTitleValidationError)));
      return;
    }
    final tags = _normalizeTags(_tagsController.text);
    final dueDateUtc = DateTime.utc(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.task == null) {
        await widget.database.insertTaskEntry(
          title: title,
          status: _status,
          priority: _priority,
          dueDate: dueDateUtc,
          noteId: _linkedNote?.id,
          tags: tags,
        );
      } else {
        final updated = widget.task!.copyWith(
          title: title,
          status: _status,
          priority: _priority,
          dueDate: dueDateUtc,
          noteId: Value(_linkedNote?.id),
          tags: tags,
        );
        await widget.database.updateTaskEntry(updated);
      }
      await _syncLinkedNoteTags(tags);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bool isCompact =
        mediaQuery.size.height < 600 || mediaQuery.size.width < 600;
    final double toolbarHeight = isCompact ? 48 : kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        title: Text(
          widget.isEditing ? loc.tasksEditTitle : loc.tasksCreateTitle,
        ),
        actions: [
          IconButton(
            tooltip: loc.tasksSaveButton,
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: loc.tasksTitleLabel,
                hintText: loc.tasksTitleHint,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TaskStatus>(
                    value: _status,
                    decoration: InputDecoration(
                      labelText: loc.tasksStatusLabel,
                    ),
                    items: TaskStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(_localizedStatus(loc, status)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _status = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<TaskPriority>(
                    value: _priority,
                    decoration: InputDecoration(
                      labelText: loc.tasksPriorityLabel,
                    ),
                    items: TaskPriority.values
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(_localizedPriority(loc, priority)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                labelText: loc.tasksDueDateLabel,
                helperText: loc.tasksDueDateHelper,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(context, _dueDate),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _selectDueDate,
                    icon: const Icon(Icons.event),
                    label: Text(loc.tasksPickDateButton),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: loc.tasksTagsLabel,
                hintText: loc.tasksTagsHint,
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<String>>(
              stream: widget.database.watchAllTaskTags(),
              builder: (context, snapshot) {
                final tags = snapshot.data ?? const <String>[];
                if (tags.isEmpty) {
                  return const SizedBox.shrink();
                }
                final selected = _tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toSet();
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '${loc.tasksTagSuggestionsLabel}:',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    ...tags.map(
                      (tag) => FilterChip(
                        label: Text(tag),
                        selected: selected.contains(tag),
                        onSelected: (_) {
                          final current = _tagsController.text.trim();
                          final set = current.isEmpty
                              ? <String>{}
                              : current
                                    .split(',')
                                    .map((value) => value.trim())
                                    .where((value) => value.isNotEmpty)
                                    .toSet();
                          if (!set.add(tag)) {
                            set.remove(tag);
                          }
                          final normalized = set.toList()
                            ..sort(
                              (a, b) =>
                                  a.toLowerCase().compareTo(b.toLowerCase()),
                            );
                          setState(() {
                            _tagsController.text = normalized.join(', ');
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.description_outlined),
              title: Text(loc.tasksLinkedNoteLabel),
              subtitle: Text(
                _linkedNote == null
                    ? loc.tasksNoNoteLinked
                    : _linkedNote!.title.trim().isEmpty
                    ? loc.notesUntitled
                    : _linkedNote!.title.trim(),
              ),
              trailing: _linkedNote == null
                  ? null
                  : IconButton(
                      tooltip: loc.tasksRemoveNoteTooltip,
                      onPressed: () {
                        setState(() {
                          _linkedNote = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _selectNote(loc),
                  icon: const Icon(Icons.link),
                  label: Text(loc.tasksSelectNoteButton),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _createNote(loc),
                  icon: const Icon(Icons.add),
                  label: Text(loc.tasksCreateNoteButton),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              loc.tasksTrackedTimePlaceholder,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMMd(localeTag).format(date);
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
}
