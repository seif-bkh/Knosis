import '../../core/errors/import_failure.dart';
import 'failure_message.dart';

/// Every user-facing string in the app.
///
/// The MVP ships an English-only interface (product owner decision), but the
/// copy lives here instead of inside widgets so that adding localization
/// later is additive rather than a refactor.
///
/// Tone follows PRODUCT_REPORT.md section 9: calm, warm, never scolding and
/// never gamified. Nothing here blames the reader.
abstract final class AppStrings {
  static const String appName = 'Knosis';
  static const String tagline = 'From words to worlds.';

  // Empty states (PRODUCT_REPORT.md section 20).
  static const String emptyLibraryTitle = 'Your library is empty';
  static const String emptyLibraryBody =
      'Import an EPUB, TXT or Markdown file and start your first '
      'reading journey.';
  static const String emptyLibraryAction = 'Import a book';

  static const String emptyNotesTitle = 'No notes yet';
  static const String emptyNotesBody =
      'Notes you write while reading will collect here, with the '
      'passage that prompted them.';

  static const String emptyReviewTitle = 'Nothing to review today';
  static const String emptyReviewBody =
      'Words and notes come back when revisiting them is useful. '
      'Read on, and Knosis will bring them to you.';

  /// Copy for an import failure.
  ///
  /// The switch is exhaustive over the sealed [ImportFailure] hierarchy, so
  /// a new failure type cannot ship without copy for it.
  static FailureMessage importFailure(ImportFailure failure) {
    switch (failure) {
      case UnreadableFileFailure():
        return _unreadable;
      case UnsupportedFormatFailure():
        return _unsupportedFormat;
      case DamagedBookFailure():
        return _damagedBook;
      case EmptyBookFailure():
        return _emptyBook;
      case FileTooLargeFailure():
        return _fileTooLarge;
      case NotEnoughSpaceFailure():
        return _notEnoughSpace;
      case UnexpectedImportFailure():
        return _unexpected;
    }
  }

  static const FailureMessage _unreadable = FailureMessage(
    message:
        "Knosis couldn't open this file. It may have been moved, "
        'renamed or deleted since you chose it.',
    action: 'Choose the file again.',
  );

  static const FailureMessage _unsupportedFormat = FailureMessage(
    message:
        "Knosis can't read this kind of file yet. EPUB, TXT and "
        'Markdown files work today.',
    action: 'Try an EPUB, TXT or Markdown file.',
  );

  static const FailureMessage _damagedBook = FailureMessage(
    message:
        "Knosis couldn't read this book. The file may be damaged, or "
        'use a structure Knosis does not support yet.',
    action: 'Try another copy of the book.',
  );

  static const FailureMessage _emptyBook = FailureMessage(
    message: 'There is no readable text in this file.',
    action: 'Check the file, then try importing it again.',
  );

  static const FailureMessage _fileTooLarge = FailureMessage(
    message: 'This file is too large for Knosis to import safely.',
    action: 'Try a smaller file, or split the book into parts.',
  );

  static const FailureMessage _notEnoughSpace = FailureMessage(
    message:
        "There isn't enough free space on this device to store the "
        'book.',
    action: 'Free up some space, then import the book again.',
  );

  static const FailureMessage _unexpected = FailureMessage(
    message:
        'Something in this file stopped Knosis from importing it. '
        'Your library and your notes are unchanged.',
    action: 'Try importing it again.',
  );
}
