import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({
    super.key,
    required this.database,
    this.note,
  });

  final AppDatabase database;
  final NoteEntry? note;

  bool get isEditing => note != null;

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _titleController;
  late final TextEditingController _tagsController;
  late final TextEditingController _contentController;
  late final TabController _tabController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _tagsController = TextEditingController(text: widget.note?.tags);
    _contentController = TextEditingController(text: widget.note?.content);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _contentController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String _deriveTitle(String content, AppLocalizations loc) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return loc.notesUntitled;
    }
    return trimmed.split('\n').first.trim();
  }

  String _normalizeTags(String source) {
    final tags = source
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    return tags.join(', ');
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final content = _contentController.text;
    final tags = _normalizeTags(_tagsController.text);
    if (content.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.notesMarkdownEmptyWarning)),
      );
      return;
    }

    final explicitTitle = _titleController.text.trim();
    final title = explicitTitle.isEmpty
        ? _deriveTitle(content, loc)
        : explicitTitle;

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.note == null) {
        await widget.database.insertNoteEntry(
          kind: NoteKind.markdown,
          title: title,
          content: content,
          tags: tags,
        );
      } else {
        final updated = widget.note!.copyWith(
          title: title,
          content: Value(content),
          drawingJson: const Value.absent(),
          tags: tags,
        );
        await widget.database.updateNoteEntry(updated);
      }
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

  Future<void> _delete() async {
    if (widget.note == null) {
      return;
    }
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.notesDeleteDialogTitle),
        content: Text(loc.notesDeleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.genericCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.notesDeleteDialogConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await widget.database.deleteNoteEntry(widget.note!.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? loc.notesEditorTitleEdit : loc.notesEditorTitleNew,
        ),
        actions: [
          if (widget.isEditing)
            IconButton(
              tooltip: loc.notesDeleteTooltip,
              onPressed: _isSaving ? null : _delete,
              icon: const Icon(Icons.delete),
            ),
          IconButton(
            tooltip: loc.notesEditorSave,
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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.notesMarkdownTabEdit),
            Tab(text: loc.notesMarkdownTabPreview),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEditorTab(loc),
          _buildPreviewTab(loc),
        ],
      ),
    );
  }

  Widget _buildEditorTab(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: loc.notesTitleLabel,
              hintText: loc.notesTitleHint,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: loc.notesTagLabel,
              hintText: loc.notesTagHint,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: loc.notesMarkdownLabel,
                hintText: loc.notesMarkdownHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab(AppLocalizations loc) {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      return Center(
        child: Text(
          loc.notesMarkdownPreviewEmpty,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Markdown(
      data: content,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
    );
  }
}
