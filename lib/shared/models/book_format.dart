/// Book formats Knosis can import.
///
/// EPUB is the primary rich format; TXT and Markdown are the simple, robust
/// ones. PDF is deliberately absent: it is a later-phase concern and must not
/// distort the current architecture (AGENTS.md section 16). A PDF therefore
/// resolves to `null` here and is reported as an unsupported format.
enum BookFormat {
  epub,
  txt,
  markdown;

  /// Best-effort format detection from a file name.
  ///
  /// The name comes from a user-chosen file and is untrusted, so this only
  /// reads the extension and never treats the value as a path.
  static BookFormat? fromFileName(String fileName) {
    final int dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) {
      return null;
    }
    final String extension = fileName.substring(dot + 1).toLowerCase();
    return switch (extension) {
      'epub' => BookFormat.epub,
      'txt' => BookFormat.txt,
      'text' => BookFormat.txt,
      'md' => BookFormat.markdown,
      'markdown' => BookFormat.markdown,
      _ => null,
    };
  }
}
