/// Why an import could not be completed.
///
/// Failures are values, not exceptions with stack traces: the import pipeline
/// returns one of these so the UI can always say what happened and what to do
/// next (AGENTS.md section 19). The type is `sealed`, so adding a new failure
/// is a compile error until user-facing copy exists for it.
sealed class ImportFailure {
  const ImportFailure({required this.fileName});

  /// Name of the file the user picked, for display only. Never treated as a
  /// path: imported file names are untrusted (AGENTS.md section 26).
  final String fileName;
}

/// The file could not be opened or read at all.
final class UnreadableFileFailure extends ImportFailure {
  const UnreadableFileFailure({required super.fileName});
}

/// The extension is not one Knosis supports yet.
final class UnsupportedFormatFailure extends ImportFailure {
  const UnsupportedFormatFailure({
    required super.fileName,
    required this.extension,
  });

  final String extension;
}

/// The file matched a supported format but its content is malformed.
final class DamagedBookFailure extends ImportFailure {
  const DamagedBookFailure({required super.fileName});
}

/// The file was readable but contains no text to read.
final class EmptyBookFailure extends ImportFailure {
  const EmptyBookFailure({required super.fileName});
}

/// The file exceeds the size Knosis is willing to import.
final class FileTooLargeFailure extends ImportFailure {
  const FileTooLargeFailure({
    required super.fileName,
    required this.sizeBytes,
    required this.limitBytes,
  });

  final int sizeBytes;
  final int limitBytes;
}

/// There is not enough room on the device to store the book.
final class NotEnoughSpaceFailure extends ImportFailure {
  const NotEnoughSpaceFailure({
    required super.fileName,
    required this.requiredBytes,
  });

  final int requiredBytes;
}

/// Anything unforeseen.
///
/// [technicalDetail] is for logs and bug reports only. It must never reach
/// the user: AGENTS.md section 19 forbids showing stack traces, and section
/// 19 also forbids logging book content, so callers must keep this to
/// technical context.
final class UnexpectedImportFailure extends ImportFailure {
  const UnexpectedImportFailure({
    required super.fileName,
    required this.technicalDetail,
  });

  final String technicalDetail;
}
