import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maatru_path_client/maatru_path_client.dart';
import '../client.dart';
import '../theme/app_theme.dart';
import '../widgets/priority_badge.dart';
import '../widgets/privacy_banner.dart';
import '../widgets/status_badge.dart';
import '../widgets/timeline_item.dart';

class CaseDetailScreen extends StatefulWidget {
  final int caseId;

  const CaseDetailScreen({super.key, required this.caseId});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  CaseRecord? _caseRecord;
  List<CaseActionLog> _history = [];
  List<RecommendedAction> _recommendations = [];

  bool _isLoading = true;
  String? _errorMessage;

  // Follow-up note state
  final TextEditingController _noteController = TextEditingController();
  bool _isSavingNote = false;
  String? _noteError;

  // Status transition state
  bool _isUpdatingStatus = false;
  bool _dataModified = false;

  @override
  void initState() {
    super.initState();
    _loadCaseDetails();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadCaseDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedCase = await client.cases.getCase(widget.caseId);
      if (fetchedCase == null) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Case #${widget.caseId} could not be found.';
          _isLoading = false;
        });
        return;
      }

      final fetchedHistory = await client.cases.getCaseHistory(widget.caseId);
      final fetchedRecs = await client.cases.getRecommendedActions(
        fetchedCase.blockerCategory,
      );

      if (!mounted) return;
      setState(() {
        _caseRecord = fetchedCase;
        _history = fetchedHistory;
        _recommendations = fetchedRecs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleStatusTransition(String newStatus) async {
    if (_caseRecord == null || _isUpdatingStatus) return;

    String? reason;
    final currentStatus = _caseRecord!.status;
    final isReopening = currentStatus == 'Resolved';

    // If reopening, prompt for deliberate reason
    if (isReopening) {
      final controller = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Reopen Resolved Case'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please specify the reason for deliberately reopening this case:',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Supervisor requested secondary audit...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Reopen Case'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
      reason = controller.text.trim();
      if (reason.isEmpty) {
        reason = 'Case reopened for secondary follow-up.';
      }
    }

    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final updated = await client.cases.updateBlockerStatus(
        widget.caseId,
        newStatus,
        reason,
      );

      final newHistory = await client.cases.getCaseHistory(widget.caseId);

      if (!mounted) return;
      setState(() {
        _caseRecord = updated;
        _history = newHistory;
        _isUpdatingStatus = false;
        _dataModified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.statusResolvedText,
          content: Text(
            isReopening
                ? 'Case #${widget.caseId} successfully reopened to "$newStatus".'
                : 'Status transitioned to "$newStatus". Action recorded in timeline.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUpdatingStatus = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDC2626),
          content: Text('Failed to update status: $e'),
        ),
      );
    }
  }

  Future<void> _submitFollowUpNote() async {
    final note = _noteController.text.trim();
    if (note.length < 3) {
      setState(() {
        _noteError = 'Note must be at least 3 characters long.';
      });
      return;
    }
    if (note.length > 1000) {
      setState(() {
        _noteError = 'Note cannot exceed 1000 characters.';
      });
      return;
    }

    setState(() {
      _isSavingNote = true;
      _noteError = null;
    });

    try {
      await client.cases.addFollowUpNote(widget.caseId, note);
      final refreshedCase = await client.cases.getCase(widget.caseId);
      final refreshedHistory = await client.cases.getCaseHistory(widget.caseId);

      if (!mounted) return;
      setState(() {
        _noteController.clear();
        _caseRecord = refreshedCase;
        _history = refreshedHistory;
        _isSavingNote = false;
        _dataModified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppTheme.statusResolvedText,
          content: Text('Follow-up note recorded to timeline in Serverpod.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSavingNote = false;
        _noteError = e.toString();
      });
    }
  }

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_dataModified);
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_dataModified),
          ),
          title: Text(
            _caseRecord != null
                ? 'Case ${_caseRecord!.applicantReference}'
                : 'Case Details',
          ),
          actions: [
            IconButton(
              tooltip: 'Refresh Case Details',
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadCaseDetails,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading case and timeline from Serverpod...',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              )
            : _errorMessage != null
            ? _buildErrorView()
            : _buildCaseContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFDC2626)),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Color(0xFF991B1B)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCaseDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseContent() {
    final c = _caseRecord!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PrivacyBanner(),
              const SizedBox(height: 20),

              // Overview Banner
              _buildOverviewHeader(c),
              const SizedBox(height: 24),

              // Desktop: 2 Columns; Mobile: Stacked
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Guidance & Actions
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusTransitionsSection(c),
                          const SizedBox(height: 20),
                          _buildRecommendationsSection(),
                          const SizedBox(height: 20),
                          _buildAddNoteSection(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right Column: Timeline Differentiator
                    Expanded(
                      flex: 5,
                      child: _buildTimelineSection(),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusTransitionsSection(c),
                    const SizedBox(height: 20),
                    _buildRecommendationsSection(),
                    const SizedBox(height: 20),
                    _buildAddNoteSection(),
                    const SizedBox(height: 24),
                    _buildTimelineSection(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewHeader(CaseRecord c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          c.applicantReference,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          tooltip: 'Copy Synthetic Reference',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: c.applicantReference),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reference copied to clipboard.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentTeal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            c.schemeName,
                            style: const TextStyle(
                              color: AppTheme.accentTeal,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Case #${c.id} • Registered ${_formatDateTime(c.createdAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  PriorityBadge(priority: c.priority),
                  const SizedBox(width: 8),
                  StatusBadge(status: c.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Blocker Category & Description
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.brandIndigo.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.report_problem_outlined,
                  size: 18,
                  color: AppTheme.brandIndigo,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Blocker Category: ${c.blockerCategory}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Text(
              c.blockerDescription,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTransitionsSection(CaseRecord c) {
    final currentStatus = c.status;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.alt_route, size: 18, color: AppTheme.brandIndigo),
              SizedBox(width: 8),
              Text(
                'Workflow Transitions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Permitted transitions are strictly verified and recorded to the audit log in Serverpod.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          if (_isUpdatingStatus)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (currentStatus == 'Open') ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandBlue,
                    ),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('Mark In Progress'),
                    onPressed: () => _handleStatusTransition('In Progress'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusResolvedText,
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Resolve Blocker'),
                    onPressed: () => _handleStatusTransition('Resolved'),
                  ),
                ] else if (currentStatus == 'In Progress') ...[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Revert to Open'),
                    onPressed: () => _handleStatusTransition('Open'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusResolvedText,
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Resolve Blocker'),
                    onPressed: () => _handleStatusTransition('Resolved'),
                  ),
                ] else if (currentStatus == 'Resolved') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.statusResolvedBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: AppTheme.statusResolvedText,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Blocker is resolved.',
                          style: TextStyle(
                            color: AppTheme.statusResolvedText,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.restart_alt, size: 16),
                    label: const Text('Deliberate Reopen'),
                    onPressed: () => _handleStatusTransition('In Progress'),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: AppTheme.accentTeal,
              ),
              SizedBox(width: 8),
              Text(
                'Recommended Next Actions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Rule-based guidance matching the blocker category. Distinguishes official verification requirements.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          if (_recommendations.isEmpty)
            const Text(
              'No automated guidance available for this category.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recommendations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rec = _recommendations[index];
                return _buildRecommendationCard(rec);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(RecommendedAction rec) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  rec.explanation,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: rec.requiresOfficialVerification
                      ? const Color(0xFFFEF3C7) // Amber 100
                      : const Color(0xFFF1F5F9), // Slate 100
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  rec.requiresOfficialVerification
                      ? 'Requires Official Verification'
                      : 'Community Follow-Up',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: rec.requiresOfficialVerification
                        ? const Color(0xFFB45309)
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Next Step: ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppTheme.brandIndigo,
                ),
              ),
              Expanded(
                child: Text(
                  rec.prioritizedNextAction,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Follow-Up: ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppTheme.accentTeal,
                ),
              ),
              Expanded(
                child: Text(
                  rec.practicalFollowUp,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (rec.officialReferenceUrl != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.link,
                  size: 14,
                  color: AppTheme.brandBlue,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    rec.officialReferenceUrl!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.brandBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(50, 24),
                  ),
                  child: const Text('Copy URL', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: rec.officialReferenceUrl!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Official URL copied to clipboard.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddNoteSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.edit_note, size: 20, color: AppTheme.brandIndigo),
              SizedBox(width: 8),
              Text(
                'Record Follow-Up Note',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Document in-person discussions, desk visits, or document receipt. Appended persistently to timeline.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 14),

          if (_noteError != null) ...[
            Text(
              _noteError!,
              style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
            ),
            const SizedBox(height: 8),
          ],

          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText:
                  'Enter specific follow-up outcome or next appointment...',
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: _isSavingNote
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_comment_outlined, size: 16),
                label: const Text('Record Follow-Up'),
                onPressed: _isSavingNote ? null : _submitFollowUpNote,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.brandIndigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: AppTheme.brandIndigo,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Blocker-to-Resolution Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Chronological backend audit history persisted in Serverpod. Reflects actual database actions.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          if (_history.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No history entries found.',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final log = _history[index];
                return TimelineItem(
                  log: log,
                  isFirst: index == 0,
                  isLast: index == _history.length - 1,
                );
              },
            ),
        ],
      ),
    );
  }
}
