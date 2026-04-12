extension StringHardcoded on String {
  /// Marks a string as hardcoded (not yet localized).
  /// Returns the string as-is; useful for grepping unlocalized strings later.
  String get hardcoded => this;
}
