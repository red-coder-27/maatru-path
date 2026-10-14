import 'package:flutter/material.dart';
import 'package:maatru_path_client/maatru_path_client.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class TimelineItem extends StatelessWidget {
  final CaseActionLog log;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.log,
    required this.isFirst,
    required this.isLast,
  });

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final year = local.year;
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day at $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color nodeColor;
    String title;

    switch (log.actionType) {
      case 'created':
        icon = Icons.add_circle_outline;
        nodeColor = AppTheme.brandIndigo;
        title = 'Case Initiated';
        break;
      case 'reopened':
        icon = Icons.restart_alt_rounded;
        nodeColor = AppTheme.statusOpenText;
        title = 'Case Reopened';
        break;
      case 'status_change':
        if (log.newStatus == 'Resolved') {
          icon = Icons.check_circle;
          nodeColor = AppTheme.statusResolvedText;
          title = 'Blocker Resolved';
        } else {
          icon = Icons.sync_alt;
          nodeColor = AppTheme.brandBlue;
          title = 'Status Transition';
        }
        break;
      case 'note_added':
        icon = Icons.chat_bubble_outline;
        nodeColor = AppTheme.accentTeal;
        title = 'Follow-up Note Recorded';
        break;
      default:
        icon = Icons.circle;
        nodeColor = AppTheme.textSecondary;
        title = 'Action Logged';
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline rail & icon
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Top line
                Container(
                  width: 2,
                  height: 12,
                  color: isFirst ? Colors.transparent : AppTheme.borderLight,
                ),
                // Node circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: nodeColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: nodeColor, width: 2),
                  ),
                  child: Icon(icon, size: 14, color: nodeColor),
                ),
                // Bottom line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppTheme.borderLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Content card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        _formatDateTime(log.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (log.previousStatus != null && log.newStatus != null) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        StatusBadge(status: log.previousStatus!, compact: true),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: AppTheme.textMuted,
                        ),
                        StatusBadge(status: log.newStatus!, compact: true),
                      ],
                    ),
                  ],
                  if (log.note != null && log.note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.borderLight.withValues(alpha: 0.7),
                        ),
                      ),
                      child: Text(
                        log.note!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
