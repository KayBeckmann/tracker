/// Preprocesses markdown content to convert `[[Note Title]]` wiki-style links
/// into standard markdown links with a custom `note://` scheme.
///
/// For example, `[[My Note]]` becomes `[My Note](note://My%20Note)`.
String preprocessNoteLinks(String content) {
  return content.replaceAllMapped(
    RegExp(r'\[\[(.+?)\]\]'),
    (match) {
      final title = match.group(1)!;
      final encoded = Uri.encodeComponent(title);
      return '[$title](note://$encoded)';
    },
  );
}
