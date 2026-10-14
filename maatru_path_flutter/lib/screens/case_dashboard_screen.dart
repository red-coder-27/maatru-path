import 'package:flutter/material.dart';
import 'package:maatru_path_client/maatru_path_client.dart';
import '../client.dart';
import '../theme/app_theme.dart';
import '../widgets/priority_badge.dart';
import '../widgets/privacy_banner.dart';
import '../widgets/status_badge.dart';
import 'case_detail_screen.dart';
import 'create_case_screen.dart';

class CaseDashboardScreen extends StatefulWidget {
  const CaseDashboardScreen({super.key});

  @override
  State<CaseDashboardScreen> createState() => _CaseDashboardScreenState();
}

class _CaseDashboardScreenState extends State<CaseDashboardScreen> {
  List<CaseRecord> _cases = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedStatusFilter = 'All';
  String _selectedCategoryFilter = 'All';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final records = await client.cases.listCases();
      if (!mounted) return;
      setState(() {
        _cases = records;
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

  List<CaseRecord> get _filteredCases {
    return _cases.where((c) {
      if (_selectedStatusFilter != 'All' && c.status != _selectedStatusFilter) {
        return false;
      }
      if (_selectedCategoryFilter != 'All' &&
          c.blockerCategory != _selectedCategoryFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchRef = c.applicantReference.toLowerCase().contains(query);
        final matchScheme = c.schemeName.toLowerCase().contains(query);
        final matchDesc = c.blockerDescription.toLowerCase().contains(query);
        final matchCategory = c.blockerCategory.toLowerCase().contains(query);
        return matchRef || matchScheme || matchDesc || matchCategory;
      }
      return true;
    }).toList();
  }

  int get _countTotal => _cases.length;
  int get _countOpen => _cases.where((c) => c.status == 'Open').length;
  int get _countInProgress =>
      _cases.where((c) => c.status == 'In Progress').length;
  int get _countResolved => _cases.where((c) => c.status == 'Resolved').length;

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final year = local.year;
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 700;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppTheme.brandIndigo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.alt_route_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MaatruPath',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (!isCompact)
                    Text(
                      'Application Blocker Companion',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: AppTheme.textSecondary.withValues(alpha: 0.9),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Cases from Serverpod',
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadCases,
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: Text(isCompact ? 'New' : 'New Case'),
              onPressed: () async {
                final created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const CreateCaseScreen(),
                  ),
                );
                if (created == true) {
                  _loadCases();
                }
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCases,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 32,
            vertical: 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PrivacyBanner(),
                  const SizedBox(height: 20),

                  // Summary metrics derived from real backend data
                  _buildSummaryMetrics(isCompact),
                  const SizedBox(height: 24),

                  // Search & Filter Bar
                  _buildFilterBar(isCompact),
                  const SizedBox(height: 16),

                  // Content Area
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Retrieving persisted cases from Serverpod...',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    _buildErrorCard()
                  else if (_filteredCases.isEmpty)
                    _buildEmptyState()
                  else
                    _buildCaseList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryMetrics(bool isCompact) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 600
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildMetricCard(
              title: 'Total Cases',
              count: _countTotal,
              color: AppTheme.brandIndigo,
              icon: Icons.folder_outlined,
              filterStatus: 'All',
              width: cardWidth,
            ),
            _buildMetricCard(
              title: 'Open Blockers',
              count: _countOpen,
              color: AppTheme.statusOpenText,
              icon: Icons.error_outline,
              filterStatus: 'Open',
              width: cardWidth,
            ),
            _buildMetricCard(
              title: 'In Progress',
              count: _countInProgress,
              color: AppTheme.statusProgressText,
              icon: Icons.hourglass_empty_rounded,
              filterStatus: 'In Progress',
              width: cardWidth,
            ),
            _buildMetricCard(
              title: 'Resolved',
              count: _countResolved,
              color: AppTheme.statusResolvedText,
              icon: Icons.check_circle_outline,
              filterStatus: 'Resolved',
              width: cardWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required String filterStatus,
    required double width,
  }) {
    final isSelected = _selectedStatusFilter == filterStatus;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatusFilter = filterStatus;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? color : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(bool isCompact) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText:
                        'Search by reference (e.g. DEMO-001), scheme, or blocker...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: 160,
                  child: _buildStatusDropdown(),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 200,
                  child: _buildCategoryDropdown(),
                ),
              ],
            ],
          ),
          if (isCompact) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildStatusDropdown()),
                const SizedBox(width: 8),
                Expanded(child: _buildCategoryDropdown()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: _selectedStatusFilter,
      decoration: const InputDecoration(
        labelText: 'Status',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Statuses')),
        DropdownMenuItem(value: 'Open', child: Text('Open')),
        DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
        DropdownMenuItem(value: 'Resolved', child: Text('Resolved')),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedStatusFilter = val;
          });
        }
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: _selectedCategoryFilter,
      decoration: const InputDecoration(
        labelText: 'Category',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Categories')),
        DropdownMenuItem(
          value: 'Aadhaar Linkage',
          child: Text('Aadhaar Linkage'),
        ),
        DropdownMenuItem(
          value: 'Bank Account / NPCI',
          child: Text('Bank / NPCI'),
        ),
        DropdownMenuItem(value: 'Documentation', child: Text('Documentation')),
        DropdownMenuItem(
          value: 'Operator Verification',
          child: Text('Operator Verify'),
        ),
        DropdownMenuItem(
          value: 'Biometric Authentication',
          child: Text('Biometric'),
        ),
        DropdownMenuItem(
          value: 'Mobile Seeding',
          child: Text('Mobile Seeding'),
        ),
        DropdownMenuItem(value: 'Unclear Requirement', child: Text('Unclear')),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedCategoryFilter = val;
          });
        }
      },
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: Color(0xFFDC2626),
          ),
          const SizedBox(height: 12),
          const Text(
            'Unable to connect to Serverpod backend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF991B1B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown communication error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF7F1D1D)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry Request'),
            onPressed: _loadCases,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 56,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            _cases.isEmpty
                ? 'No Welfare Blocker Cases Logged Yet'
                : 'No Cases Match Your Current Filters',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _cases.isEmpty
                ? 'Register a synthetic case to track unresolved obstacles and follow-up guidance.'
                : 'Try clearing your search query or adjusting the status/category filters.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create New Case with Demo Template'),
            onPressed: () async {
              final created = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => const CreateCaseScreen(),
                ),
              );
              if (created == true) {
                _loadCases();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCaseList() {
    final list = _filteredCases;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final caseItem = list[index];
        return _buildCaseCard(caseItem);
      },
    );
  }

  Widget _buildCaseCard(CaseRecord caseItem) {
    final lastUpdated = caseItem.updatedAt ?? caseItem.createdAt;

    return InkWell(
      onTap: () async {
        if (caseItem.id == null) return;
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => CaseDetailScreen(caseId: caseItem.id!),
          ),
        );
        if (changed == true) {
          _loadCases();
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Ref, Scheme, Priority, Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    caseItem.applicantReference,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    caseItem.schemeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppTheme.accentTeal,
                    ),
                  ),
                ),
                const Spacer(),
                PriorityBadge(priority: caseItem.priority, compact: true),
                const SizedBox(width: 8),
                StatusBadge(status: caseItem.status, compact: true),
              ],
            ),
            const SizedBox(height: 12),

            // Blocker Category Header
            Row(
              children: [
                const Icon(
                  Icons.report_problem_outlined,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    caseItem.blockerCategory,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Blocker Description
            Text(
              caseItem.blockerDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // Footer: Timestamp & Action Hint
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 13,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last activity: ${_formatDate(lastUpdated)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Inspect Blocker & Timeline',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brandBlue,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppTheme.brandBlue,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
