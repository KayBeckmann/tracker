class Note {
  const Note({
    required this.id,
    required this.content,
    required this.tags,
    required this.createdAt,
  });

  final int id;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
}
