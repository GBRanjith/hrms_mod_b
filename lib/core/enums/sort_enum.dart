enum Sort {
  newestFirst,
  oldestFirst;

  String get label => switch (this) {
    Sort.newestFirst => 'Newest first',
    Sort.oldestFirst => 'Oldest first',
  };

  Sort get toggled => switch (this) {
    Sort.newestFirst => Sort.oldestFirst,
    Sort.oldestFirst => Sort.newestFirst,
  };
}
