import 'package:flutter/material.dart';
import '../data/local/app_database.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({super.key, required this.database, this.note});

  final AppDatabase database;
  final NoteEntry? note;

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note?.content);
    _tagsController = TextEditingController(text: widget.note?.tags);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    print('Saving note...');
    final content = _contentController.text;
    final tags = _tagsController.text;

    if (widget.note == null) {
      await widget.database.insertNoteEntry(
        content: content,
        tags: tags,
      );
      print('Note inserted.');
    } else {
      await widget.database.updateNoteEntry(
        widget.note!.copyWith(
          content: content,
          tags: tags,
        ),
      );
      print('Note updated.');
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Neue Notiz' : 'Notiz bearbeiten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Markdown Formatierung'),
                  content: const SingleChildScrollView(
                    child: Text(
                      '# Überschrift 1\n## Überschrift 2\n**fett**\n*kursiv*\n- Listenpunkt\n\n[Link](https://www.google.com)',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Schließen'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                hintText: 'Tags (kommagetrennt)',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Schreibe deine Notiz hier...', 
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
