import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../core/enums/sort_enum.dart';
import '../../../core/enums/status.dart';
import '../../../core/storage/hive_boxes.dart';
import '../../../core/storage/preference_service.dart';
import '../../../core/utils/repo_response_model.dart';
import '../domine/enums/claim_status_enum.dart';
import 'models/claim_model.dart';

class ClaimRepository {
  const ClaimRepository();
  static Box<ClaimModel> get _claimBox =>
      Hive.box<ClaimModel>(HiveBoxes.claims);

  static Stream<BoxEvent> watchClaims() => _claimBox.watch();

  static int _compareByDate(ClaimModel a, ClaimModel b, Sort sort) {
    final dateA = a.date ?? DateTime(0);
    final dateB = b.date ?? DateTime(0);

    return sort == Sort.newestFirst
        ? dateB.compareTo(dateA)
        : dateA.compareTo(dateB);
  }

  static List<ClaimModel> getClaims({
    String? search,
    ClaimStatus? status,
    Sort sort = Sort.newestFirst,
    int? limit,
    int? offset,
  }) {
    final query = search?.trim().toLowerCase() ?? '';
    final start = offset != null && offset > 0 ? offset : 0;

    final claims = _claimBox.values.where((claim) {
      final matchesSearch =
          query.isEmpty ||
          (claim.description?.toLowerCase().contains(query) ?? false) ||
          (claim.category?.label.toLowerCase().contains(query) ?? false);

      final matchesStatus = status == null || claim.status == status;

      return matchesSearch && matchesStatus;
    }).toList()..sort((a, b) => _compareByDate(a, b, sort));

    return claims.skip(start).take(limit ?? claims.length).toList();
  }

  static ClaimModel? getClaimById(String id) => _claimBox.get(id);

  static Future<RepoResult> createClaim(ClaimModel input) async {
    final id = input.id ?? const Uuid().v4();
    final claim = ClaimModel(
      id: id,
      employeeId: input.employeeId,
      category: input.category,
      amount: input.amount,
      date: input.date,
      description: input.description?.trim(),
      status: ClaimStatus.pending,
      receiptFileName: input.receiptFileName,
      createdAt: DateTime.now(),
    );
    await _claimBox.put(id, claim);
    return RepoResult(status: Status.success, message: 'Claim submitted');
  }

  static Future<RepoResult> updateClaim(ClaimModel input) async {
    if (input.id == null) {
      return RepoResult(status: Status.failure, message: 'Missing claim id');
    }
    final existingClaim = _claimBox.get(input.id);

    if (existingClaim == null) {
      return RepoResult(status: Status.failure, message: 'Claim not found');
    }
    final claim = ClaimModel(
      id: existingClaim.id,
      employeeId: input.employeeId,
      category: input.category,
      amount: input.amount,
      date: input.date,
      description: input.description?.trim(),
      status: existingClaim.status,
      receiptFileName: input.receiptFileName,
      createdAt: existingClaim.createdAt,
      reviewComments: input.reviewComments,
      reviewDate: input.reviewDate,
      reviewerId: input.reviewerId,
    );

    await _claimBox.put(claim.id, claim);
    return RepoResult(
      status: Status.success,
      message: 'Claim updated successfully',
    );
  }

  static Future<RepoResult> reviewClaim({
    required String claimId,
    required ClaimStatus status,
    String? comments,
  }) async {
    final existing = _claimBox.get(claimId);

    if (existing == null) {
      return RepoResult(status: Status.failure, message: 'Claim not found');
    }

    await _claimBox.put(
      claimId,
      existing.withReview(
        status: status,
        reviewerId: PreferenceService.employeeId,
        comments: comments,
      ),
    );
    return RepoResult(
      status: Status.success,
      message: 'Claim marked ${status.label.toLowerCase()}',
    );
  }

  static Future<RepoResult> deleteClaim(String id) async {
    final claim = _claimBox.get(id);
    if (claim?.status == ClaimStatus.approved) {
      return RepoResult(
        status: Status.failure,
        message: 'Claim already approved, cannot delete',
      );
    }
    await _claimBox.delete(id);
    return RepoResult(status: Status.success, message: 'Claim deleted');
  }

  static bool canEdit(ClaimModel claim) => claim.status?.isPending ?? false;
}
