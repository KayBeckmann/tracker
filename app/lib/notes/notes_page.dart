import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'note_drawing_page.dart';
import 'note_edit_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
    required this.database,
    this.initialTag,
    this.onTagFilterChanged,
  });

  final AppDatabase database;
  final String? initialTag;
  final ValueChanged<String?>? onTagFilterChanged;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _contentFilterController =
      TextEditingController();
  String _contentFilter = '';
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _contentFilterController.addListener(_handleContentFilterChanged);
    _selectedTag = widget.initialTag;
  }

  @override
  void didUpdateWidget(covariant NotesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTag != oldWidget.initialTag) {
      _updateSelectedTag(widget.initialTag, notifyParent: false);
    }
  }

  @override
  void dispose() {
    _contentFilterController
      ..removeListener(_handleContentFilterChanged)
      ..dispose();
    super.dispose();
  }

  void _updateSelectedTag(String? value, {bool notifyParent = true}) {
    if (_selectedTag == value) {
      if (notifyParent) {
        widget.onTagFilterChanged?.call(value);
      }
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedTag = value;
    });
    if (notifyParent) {
      widget.onTagFilterChanged?.call(value);
    }
  }

  void _handleContentFilterChanged() {
    setState(() {
      _contentFilter = _contentFilterController.text;
    });
  }

  Future<void> _openEditorForNew(NoteKind kind) async {
    switch (kind) {
      case NoteKind.markdown:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => NoteEditPage(database: widget.database),
          ),
        );
      case NoteKind.drawing:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => DrawingNotePage(database: widget.database),
          ),
        );
    }
  }

  Future<void> _openEditor(NoteEntry note) async {
    switch (note.kind) {
      case NoteKind.markdown:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                NoteEditPage(database: widget.database, note: note),
          ),
        );
      case NoteKind.drawing:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                DrawingNotePage(database: widget.database, note: note),
          ),
        );
    }
  }

  Future<void> _showCreateNoteSheet() async {
    final loc = AppLocalizations.of(context);
    final NoteKind? selectedKind = await showModalBottomSheet<NoteKind>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.notes),
                title: Text(loc.notesCreateMarkdown),
                onTap: () => Navigator.of(context).pop(NoteKind.markdown),
              ),
              ListTile(
                leading: const Icon(Icons.gesture),
                title: Text(loc.notesCreateDrawing),
                onTap: () => Navigator.of(context).pop(NoteKind.drawing),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || selectedKind == null) {
      return;
    }
    await _openEditorForNew(selectedKind);
  }

  String _formatTags(String tags) {
    final normalized = tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    return normalized.join(', ');
  }

  Future<void> _setNoteArchived(NoteEntry note, bool archived) async {
    await widget.database.setNoteArchived(id: note.id, archived: archived);
  }

  Widget _buildNotesTab(AppLocalizations loc, {required bool archived}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _contentFilterController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: loc.notesSearchHint,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StreamBuilder<List<String>>(
                  stream: widget.database.watchAllNoteTags(),
                  builder: (context, snapshot) {
                    final tags = snapshot.data ?? const <String>[];
                    final bool tagAvailable =
                        _selectedTag != null && tags.contains(_selectedTag);
                    final currentValue = tagAvailable ? _selectedTag : null;
                    if (snapshot.hasData &&
                        _selectedTag != null &&
                        !tagAvailable &&
                        tags.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _updateSelectedTag(null);
                        }
                      });
                    }
                    final items = <DropdownMenuItem<String?>>[
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(loc.notesTagFilterAll),
                      ),
                      ...tags.map(
                        (tag) => DropdownMenuItem<String?>(
                          value: tag,
                          child: Text(tag),
                        ),
                      ),
                    ];
                    return DropdownButtonFormField<String?>(
                      value: currentValue,
                      items: items,
                      onChanged: (value) {
                        _updateSelectedTag(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.tag),
                        labelText: loc.notesTagFilterLabel,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<NoteEntry>>(
              stream: archived
                  ? widget.database.watchArchivedNoteEntries(
                      contentFilter: _contentFilter,
                      tagFilter: _selectedTag ?? '',
                    )
                  : widget.database.watchNoteEntries(
                      contentFilter: _contentFilter,
                      tagFilter: _selectedTag ?? '',
                    ),
              builder: (context, snapshot) {
                final notes = snapshot.data ?? const <NoteEntry>[];
                if (notes.isEmpty) {
                  final emptyText = archived
                      ? loc.notesArchiveEmpty
                      : loc.notesEmptyPlaceholder;
                  return Center(
                    child: Text(
                      emptyText,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final title = note.title.trim().isEmpty
                        ? loc.notesUntitled
                        : note.title.trim();
                    final subtitleBuffer = <String>[];
                    if (note.kind == NoteKind.markdown &&
                        (note.content ?? '').isNotEmpty) {
                      subtitleBuffer.add(
                        note.content!.split('\n').first.trim(),
                      );
                    }
                    final formattedTags = _formatTags(note.tags);
                    if (formattedTags.isNotEmpty) {
                      subtitleBuffer.add(
                        '${loc.notesTagLabel}: $formattedTags',
                      );
                    }
                    final icon = note.kind == NoteKind.markdown
                        ? Icons.notes
                        : Icons.brush;
                    return ListTile(
                      leading: Icon(icon),
                      title: Text(title),
                      subtitle: subtitleBuffer.isEmpty
                          ? null
                          : Text(subtitleBuffer.join('\n')),
                      trailing: IconButton(
                        tooltip: archived
                            ? loc.notesUnarchiveTooltip
                            : loc.notesArchiveTooltip,
                        onPressed: () => _setNoteArchived(note, !archived),
                        icon: Icon(
                          archived ? Icons.unarchive : Icons.archive_outlined,
                        ),
                      ),
                      onTap: () => _openEditor(note),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.navNotes),
          actions: [
            IconButton(
              tooltip: loc.notesClearFiltersTooltip,
              onPressed: () {
                _contentFilterController.clear();
                _updateSelectedTag(null);
              },
              icon: const Icon(Icons.filter_alt_off),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: loc.notesTabActive),
              Tab(text: loc.notesTabArchive),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateNoteSheet,
          icon: const Icon(Icons.add),
          label: Text(loc.notesCreateButtonLabel),
        ),
        body: TabBarView(
          children: [
            _buildNotesTab(loc, archived: false),
            _buildNotesTab(loc, archived: true),
          ],
        ),
      ),
    );
  }
}
