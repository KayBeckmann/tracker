import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'note_drawing_page.dart';
import 'note_edit_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _contentFilterController = TextEditingController();
  final TextEditingController _tagFilterController = TextEditingController();

  String _contentFilter = '';
  String _tagFilter = '';

  @override
  void initState() {
    super.initState();
    _contentFilterController.addListener(_handleContentFilterChanged);
    _tagFilterController.addListener(_handleTagFilterChanged);
  }

  @override
  void dispose() {
    _contentFilterController
      ..removeListener(_handleContentFilterChanged)
      ..dispose();
    _tagFilterController
      ..removeListener(_handleTagFilterChanged)
      ..dispose();
    super.dispose();
  }

  void _handleContentFilterChanged() {
    setState(() {
      _contentFilter = _contentFilterController.text;
    });
  }

  void _handleTagFilterChanged() {
    setState(() {
      _tagFilter = _tagFilterController.text;
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
            builder: (context) => NoteEditPage(
              database: widget.database,
              note: note,
            ),
          ),
        );
      case NoteKind.drawing:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => DrawingNotePage(
              database: widget.database,
              note: note,
            ),
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.navNotes),
        actions: [
          IconButton(
            tooltip: loc.notesClearFiltersTooltip,
            onPressed: () {
              _contentFilterController.clear();
              _tagFilterController.clear();
            },
            icon: const Icon(Icons.filter_alt_off),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateNoteSheet,
        icon: const Icon(Icons.add),
        label: Text(loc.notesCreateButtonLabel),
      ),
      body: Padding(
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
                  child: TextField(
                    controller: _tagFilterController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.tag),
                      labelText: loc.notesSearchTagHint,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<NoteEntry>>(
                stream: widget.database.watchNoteEntries(
                  contentFilter: _contentFilter,
                  tagFilter: _tagFilter,
                ),
                builder: (context, snapshot) {
                  final notes = snapshot.data ?? const <NoteEntry>[];
                  if (notes.isEmpty) {
                    return Center(
                      child: Text(
                        loc.notesEmptyPlaceholder,
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
                        subtitleBuffer.add('${loc.notesTagLabel}: $formattedTags');
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
                        onTap: () => _openEditor(note),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
