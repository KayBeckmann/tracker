import 'dart:async';

import 'package:flutter/material.dart';
import '../data/local/app_database.dart';
import 'note_edit_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _contentFilterController = TextEditingController();
  final _tagFilterController = TextEditingController();
  Timer? _debounce;

  String _contentFilter = '';
  String _tagFilter = '';

  @override
  void initState() {
    super.initState();
    _contentFilterController.addListener(_onContentFilterChanged);
    _tagFilterController.addListener(_onTagFilterChanged);
  }

  @override
  void dispose() {
    _contentFilterController.dispose();
    _tagFilterController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onContentFilterChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _contentFilter = _contentFilterController.text;
      });
    });
  }

  void _onTagFilterChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _tagFilter = _tagFilterController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentFilterController,
                    decoration: const InputDecoration(
                      hintText: 'Notizen durchsuchen...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _tagFilterController,
                    decoration: const InputDecoration(
                      hintText: 'Tags durchsuchen...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<NoteEntry>>(
              stream: widget.database.watchNoteEntries(
                contentFilter: _contentFilter,
                tagFilter: _tagFilter,
              ),
              builder: (context, snapshot) {
                final notes = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final title = note.content.split('\n').first;
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(note.tags),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NoteEditPage(
                              database: widget.database,
                              note: note,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NoteEditPage(
                database: widget.database,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
