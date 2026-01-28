import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'note_drawing_page.dart';
import 'note_link_helper.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({
    super.key,
    required this.database,
    this.note,
    this.initialTabIndex = 0,
  });

  final AppDatabase database;
  final NoteEntry? note;
  final int initialTabIndex;

  bool get isEditing => note != null;

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _tagsController;
  late final TextEditingController _contentController;
  late final TabController _tabController;

  bool _isSaving = false;

  void _handleTagsChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tagsController = TextEditingController(text: widget.note?.tags);
    _contentController = TextEditingController(text: widget.note?.content);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tagsController.addListener(_handleTagsChanged);
  }

  @override
  void dispose() {
    _tagsController
      ..removeListener(_handleTagsChanged)
      ..dispose();
    _contentController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String _computeTitle(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return '';
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

  Set<String> _currentTagsSet() {
    return _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toSet();
  }

  void _toggleTag(String tag) {
    final tags = _currentTagsSet();
    if (!tags.add(tag)) {
      tags.remove(tag);
    }
    final ordered = tags.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final value = ordered.join(', ');
    setState(() {
      _tagsController.text = value;
    });
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final content = _contentController.text;
    final tags = _normalizeTags(_tagsController.text);
    if (content.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.notesMarkdownEmptyWarning)));
      return;
    }

    final title = _computeTitle(content);

    setState(() {
      _isSaving = true;
    });

    try {
      int? noteId;
      if (widget.note == null) {
        noteId = await widget.database.insertNoteEntry(
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
        noteId = widget.note!.id;
      }
      if (mounted) {
        Navigator.of(context).pop(noteId);
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
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final bool isCompactLayout =
        mediaQuery.size.height < 600 || mediaQuery.size.width < 600;
    final double toolbarHeight = isCompactLayout ? 48.0 : kToolbarHeight;
    final double tabBarHeight = isCompactLayout ? 40.0 : kTextTabBarHeight;

    final tabBar = TabBar(
      controller: _tabController,
      labelStyle: isCompactLayout ? theme.textTheme.bodyMedium : null,
      labelPadding: EdgeInsets.symmetric(horizontal: isCompactLayout ? 12 : 16),
      tabs: [
        Tab(text: loc.notesMarkdownTabEdit),
        Tab(text: loc.notesMarkdownTabPreview),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        titleTextStyle: isCompactLayout ? theme.textTheme.titleMedium : null,
        titleSpacing: isCompactLayout ? 8 : null,
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(tabBarHeight),
          child: SizedBox(height: tabBarHeight, child: tabBar),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildEditorTab(loc), _buildPreviewTab(loc)],
      ),
    );
  }

  Widget _buildEditorTab(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: loc.notesTagLabel,
              hintText: loc.notesTagHint,
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<String>>(
            stream: widget.database.watchAllNoteTags(),
            builder: (context, snapshot) {
              final tags = snapshot.data ?? const <String>[];
              if (tags.isEmpty) {
                return const SizedBox.shrink();
              }
              final selected = _currentTagsSet();
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '${loc.notesTagSuggestionsLabel}:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    ...tags.map(
                      (tag) => FilterChip(
                        label: Text(tag),
                        selected: selected.contains(tag),
                        onSelected: (_) => _toggleTag(tag),
                      ),
                    ),
                  ],
                ),
              );
            },
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

  Future<void> _handleNoteLinkTap(String href) async {
    if (!href.startsWith('note://')) {
      return;
    }
    final encodedTitle = href.substring('note://'.length);
    final title = Uri.decodeComponent(encodedTitle);
    final note = await widget.database.getNoteEntryByTitle(title);
    if (!mounted) return;
    if (note == null) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.notesLinkNotFound(title))),
      );
      return;
    }
    switch (note.kind) {
      case NoteKind.markdown:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => NoteEditPage(
              database: widget.database,
              note: note,
              initialTabIndex: widget.initialTabIndex,
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
    final processedContent = preprocessNoteLinks(content);
    return Markdown(
      data: processedContent,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      onTapLink: (text, href, title) {
        if (href != null) {
          _handleNoteLinkTap(href);
        }
      },
    );
  }
}
