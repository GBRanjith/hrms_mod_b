import 'package:flutter/material.dart';

import '../../domain/enums/claim_status_enum.dart';

extension ClaimStatusUi on ClaimStatus {
  IconData get icon => switch (this) {
    ClaimStatus.pending => Icons.schedule_rounded,
    ClaimStatus.approved => Icons.check_circle_rounded,
    ClaimStatus.rejected => Icons.cancel_rounded,
  };

  Color color(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (this) {
      ClaimStatus.pending =>
        isDark ? const Color(0xFFFFB865) : const Color(0xFFB26A00),
      ClaimStatus.approved =>
        isDark ? const Color(0xFF6FD69B) : const Color(0xFF1B7F4A),
      ClaimStatus.rejected =>
        isDark ? const Color(0xFFFFB4AB) : const Color(0xFFB3261E),
    };
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final ClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
