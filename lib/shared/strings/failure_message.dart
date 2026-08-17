/// User-facing copy for something that went wrong.
///
/// Every failure the user can see has both halves: what happened, and what
/// they can do about it. A dead end is not an acceptable error message
/// (AGENTS.md section 19).
class FailureMessage {
  const FailureMessage({required this.message, required this.action});

  /// Plain language description of what failed. No error codes, no stack
  /// traces, no internal type names.
  final String message;

  /// The next step offered to the user.
  final String action;
}
