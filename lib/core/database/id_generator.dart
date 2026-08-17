import 'dart:math';

/// Identifiers for stored rows.
///
/// Rows are keyed by a random UUID rather than an auto-incrementing integer.
/// The user owns their data and must be able to export it and restore it
/// later (AGENTS.md section 12); merging a backup into an existing database
/// is safe with random ids and painful with sequential ones. Changing this
/// after annotations exist would break identity, so it is fixed now, while
/// the database is still empty.
abstract final class IdGenerator {
  static final Random _random = Random.secure();

  /// A random RFC 4122 version 4 UUID, lower case, hyphenated.
  static String uuidV4() {
    final List<int> bytes = List<int>.generate(
      16,
      (_) => _random.nextInt(256),
    );

    // Version 4 in the high nibble of byte 6, RFC variant in byte 8.
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    final String hex = bytes.map(_hex).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  static String _hex(int byte) => byte.toRadixString(16).padLeft(2, '0');
}
