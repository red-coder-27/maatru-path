import 'package:flutter/material.dart';
import 'package:maatru_path_client/maatru_path_client.dart';
import '../client.dart';
import '../theme/app_theme.dart';
import '../widgets/privacy_banner.dart';

class CreateCaseScreen extends StatefulWidget {
  const CreateCaseScreen({super.key});

  @override
  State<CreateCaseScreen> createState() => _CreateCaseScreenState();
}

class _CreateCaseScreenState extends State<CreateCaseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _refController = TextEditingController();
  final TextEditingController _schemeController = TextEditingController(
    text: 'PMMVY',
  );
  final TextEditingController _descController = TextEditingController();

  String _selectedCategory = 'Aadhaar Linkage';
  String _selectedPriority = 'High';

  bool _isSubmitting = false;
  String? _serverError;

  static const List<String> categories = [
    'Aadhaar Linkage',
    'Bank Account / NPCI',
    'Documentation',
    'Operator Verification',
    'Biometric Authentication',
    'Mobile Seeding',
    'Unclear Requirement',
  ];

  static const List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  void dispose() {
    _refController.dispose();
    _schemeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _applyTemplate({
    required String ref,
    required String scheme,
    required String category,
    required String priority,
    required String description,
  }) {
    setState(() {
      _refController.text = ref;
      _schemeController.text = scheme;
      _selectedCategory = category;
      _selectedPriority = priority;
      _descController.text = description;
      _serverError = null;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _serverError = null;
    });

    try {
      final newCase = CaseRecord(
        applicantReference: _refController.text.trim(),
        schemeName: _schemeController.text.trim(),
        blockerCategory: _selectedCategory,
        blockerDescription: _descController.text.trim(),
        priority: _selectedPriority,
        status: 'Open',
      );

      final created = await client.cases.createCase(newCase);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.statusResolvedText,
          content: Text(
            'Case #${created.id} (${created.applicantReference}) successfully created in Serverpod database.',
          ),
        ),
      );

      Navigator.of(context).pop(true);
    } on CaseOperationException catch (e) {
      if (!mounted) return;
      setState(() {
        _serverError = e.message;
        _isSubmitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _serverError = 'Server error: ${e.toString()}';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Register Blocker Case'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrivacyBanner(),
                const SizedBox(height: 20),

                // Demo Templates card for fast evaluation
                _buildDemoTemplatesSection(),
                const SizedBox(height: 24),

                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Case Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Record details of the unresolved application obstacle for follow-up.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_serverError != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFECACA),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Color(0xFFDC2626),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _serverError!,
                                    style: const TextStyle(
                                      color: Color(0xFF991B1B),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Applicant Reference Field
                        TextFormField(
                          controller: _refController,
                          decoration: const InputDecoration(
                            labelText: 'Synthetic Applicant Reference *',
                            hintText: 'e.g. DEMO-001, DEMO-PMMVY-2024-001',
                            helperText:
                                'Must start with "DEMO-". Never collect real Aadhaar or PII.',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Applicant reference cannot be blank';
                            }
                            if (!value.trim().startsWith('DEMO-')) {
                              return 'Must start with DEMO- (e.g., DEMO-001)';
                            }
                            if (value.trim().length < 5) {
                              return 'Reference is too short (min 5 characters)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Scheme Name
                        TextFormField(
                          controller: _schemeController,
                          decoration: const InputDecoration(
                            labelText: 'Welfare Scheme Name *',
                            hintText: 'e.g. PMMVY, JSY, PM-KISAN',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Scheme name cannot be blank';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Category & Priority Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                // ignore: deprecated_member_use
                                value: _selectedCategory,
                                decoration: const InputDecoration(
                                  labelText: 'Blocker Category *',
                                ),
                                items: categories
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCategory = val;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<String>(
                                // ignore: deprecated_member_use
                                value: _selectedPriority,
                                decoration: const InputDecoration(
                                  labelText: 'Priority *',
                                ),
                                items: priorities
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(p),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedPriority = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Blocker Description Field
                        TextFormField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Blocker Description *',
                            hintText:
                                'Explain the specific obstacle preventing benefit disbursement...',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Blocker description cannot be blank';
                            }
                            if (value.trim().length < 5) {
                              return 'Please provide a clear description (at least 5 characters)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.check, size: 18),
                              label: Text(
                                _isSubmitting
                                    ? 'Saving to Backend...'
                                    : 'Save Case to Serverpod',
                              ),
                              onPressed: _isSubmitting ? null : _submitForm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoTemplatesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Emerald 50
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBF7D0)), // Emerald 200
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt_rounded, color: AppTheme.accentTeal, size: 20),
              SizedBox(width: 6),
              Text(
                'Demo Templates (Instant Judging Demonstration)',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppTheme.accentTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Select a template to prefill synthetic demo details, then save to call Serverpod backend:',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.badge_outlined, size: 14),
                label: const Text('DEMO: Aadhaar Mismatch'),
                onPressed: () {
                  _applyTemplate(
                    ref: 'DEMO-PMMVY-001',
                    scheme: 'PMMVY',
                    category: 'Aadhaar Linkage',
                    priority: 'High',
                    description:
                        'Demographic name spelling mismatch between beneficiary voter certificate and Aadhaar portal record.',
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.account_balance_outlined, size: 14),
                label: const Text('DEMO: NPCI DBT Inactive'),
                onPressed: () {
                  _applyTemplate(
                    ref: 'DEMO-JSY-102',
                    scheme: 'JSY',
                    category: 'Bank Account / NPCI',
                    priority: 'High',
                    description:
                        'Direct benefit transfer failed because bank branch merger invalidated NPCI Aadhaar mandate mapping.',
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.description_outlined, size: 14),
                label: const Text('DEMO: Missing MCP Stamp'),
                onPressed: () {
                  _applyTemplate(
                    ref: 'DEMO-PMMVY-044',
                    scheme: 'PMMVY',
                    category: 'Documentation',
                    priority: 'Medium',
                    description:
                        'Mother and Child Protection (MCP) card missing local health officer signoff on 3rd antenatal checkup.',
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.fingerprint_outlined, size: 14),
                label: const Text('DEMO: CSC Biometric Failure'),
                onPressed: () {
                  _applyTemplate(
                    ref: 'DEMO-CSC-088',
                    scheme: 'PMMVY',
                    category: 'Biometric Authentication',
                    priority: 'Medium',
                    description:
                        'Repeated fingerprint sensor failure at CSC operator terminal; manual exception memo requested.',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
