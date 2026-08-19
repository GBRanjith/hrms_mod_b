enum ClaimStatus {
  pending,
  approved,
  rejected;

  String get storageValue => switch (this) {
    ClaimStatus.pending => 'pending',
    ClaimStatus.approved => 'approved',
    ClaimStatus.rejected => 'rejected',
  };

  String get label => switch (this) {
    ClaimStatus.pending => 'Pending',
    ClaimStatus.approved => 'Approved',
    ClaimStatus.rejected => 'Rejected',
  };

  bool get isPending => this == ClaimStatus.pending;
  bool get isApproved => this == ClaimStatus.approved;
  bool get isRejected => this == ClaimStatus.rejected;

  static ClaimStatus fromStorage(String? value) {
    for (final status in ClaimStatus.values) {
      if (status.storageValue == value) return status;
    }
    return ClaimStatus.pending;
  }
}
