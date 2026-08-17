import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/errors/import_failure.dart';
import 'package:knosis/shared/models/book_format.dart';
import 'package:knosis/shared/strings/app_strings.dart';
import 'package:knosis/shared/strings/failure_message.dart';

const List<ImportFailure> _allFailures = <ImportFailure>[
  UnreadableFileFailure(fileName: 'book.epub'),
  UnsupportedFormatFailure(fileName: 'book.pdf', extension: 'pdf'),
  DamagedBookFailure(fileName: 'book.epub'),
  EmptyBookFailure(fileName: 'book.txt'),
  FileTooLargeFailure(
    fileName: 'book.epub',
    sizeBytes: 900000000,
    limitBytes: 500000000,
  ),
  NotEnoughSpaceFailure(fileName: 'book.epub', requiredBytes: 1000),
  UnexpectedImportFailure(
    fileName: 'book.epub',
    technicalDetail: 'FormatException at offset 0x4A in container.xml',
  ),
];

void main() {
  group('BookFormat', () {
    test('recognises the formats supported today', () {
      expect(BookFormat.fromFileName('novel.epub'), BookFormat.epub);
      expect(BookFormat.fromFileName('notes.txt'), BookFormat.txt);
      expect(BookFormat.fromFileName('notes.text'), BookFormat.txt);
      expect(BookFormat.fromFileName('notes.md'), BookFormat.markdown);
      expect(BookFormat.fromFileName('a.markdown'), BookFormat.markdown);
    });

    test('ignores case and earlier dots in the name', () {
      expect(BookFormat.fromFileName('NOVEL.EPUB'), BookFormat.epub);
      expect(BookFormat.fromFileName('my.book.v2.TxT'), BookFormat.txt);
    });

    test('returns null for formats Knosis does not read yet', () {
      expect(BookFormat.fromFileName('paper.pdf'), isNull);
      expect(BookFormat.fromFileName('archive.zip'), isNull);
      expect(BookFormat.fromFileName('noextension'), isNull);
      expect(BookFormat.fromFileName('trailingdot.'), isNull);
      expect(BookFormat.fromFileName(''), isNull);
    });
  });

  group('AppStrings.importFailure', () {
    test('has copy for every failure in the sealed hierarchy', () {
      for (final ImportFailure failure in _allFailures) {
        final FailureMessage copy = AppStrings.importFailure(failure);

        expect(copy.message, isNotEmpty);
        expect(copy.action, isNotEmpty);
      }
    });

    test('always offers a next step and never shouts', () {
      for (final ImportFailure failure in _allFailures) {
        final FailureMessage copy = AppStrings.importFailure(failure);

        expect(copy.message.trim(), endsWith('.'));
        expect(copy.action.trim(), endsWith('.'));
        expect(copy.message, isNot(contains('!')));
      }
    });

    test('never leaks technical detail to the reader', () {
      const UnexpectedImportFailure failure = UnexpectedImportFailure(
        fileName: 'book.epub',
        technicalDetail: 'FormatException at offset 0x4A in container.xml',
      );

      final FailureMessage copy = AppStrings.importFailure(failure);

      expect(copy.message, isNot(contains('FormatException')));
      expect(copy.message, isNot(contains('0x4A')));
      expect(copy.message, isNot(contains('container.xml')));
    });

    test('reassures that existing data is untouched', () {
      const UnexpectedImportFailure failure = UnexpectedImportFailure(
        fileName: 'book.epub',
        technicalDetail: 'unknown',
      );

      final FailureMessage copy = AppStrings.importFailure(failure);

      expect(copy.message, contains('unchanged'));
    });

    test('explains which formats work when the format is unsupported', () {
      const UnsupportedFormatFailure failure = UnsupportedFormatFailure(
        fileName: 'paper.pdf',
        extension: 'pdf',
      );

      final FailureMessage copy = AppStrings.importFailure(failure);

      expect(copy.message, contains('EPUB'));
      expect(copy.action, contains('Markdown'));
    });
  });

  group('AppStrings', () {
    test('carries the brand copy used by the shell', () {
      expect(AppStrings.appName, 'Knosis');
      expect(AppStrings.tagline, 'From words to worlds.');
    });

    test('empty states invite an action instead of scolding', () {
      expect(AppStrings.emptyLibraryBody, contains('journey'));
      expect(AppStrings.emptyReviewBody, isNot(contains('failed')));
      expect(AppStrings.emptyNotesBody, isNotEmpty);
    });
  });
}
