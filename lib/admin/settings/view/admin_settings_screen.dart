import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/shared_widgets/custom_card.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/admin_service.dart';

/// Admin Settings - Stripe account configuration
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _adminService = AdminService();
  final _stripeKeyController = TextEditingController();
  final _stripeSecretController = TextEditingController();
  final _webhookSecretController = TextEditingController();

  Map<String, dynamic>? _stripe;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _stripeKeyController.dispose();
    _stripeSecretController.dispose();
    _webhookSecretController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final stripe = await _adminService.getAdminSettings();
      setState(() {
        _stripe = stripe;
        _stripeKeyController.text = stripe['stripe_key']?.toString() ?? '';
        _stripeSecretController.clear();
        _webhookSecretController.clear();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      final stripe = await _adminService.updateStripeSettings(
        stripeKey: _stripeKeyController.text.trim().isEmpty ? null : _stripeKeyController.text.trim(),
        stripeSecret: _stripeSecretController.text.trim().isEmpty ? null : _stripeSecretController.text.trim(),
        stripeWebhookSecret: _webhookSecretController.text.trim().isEmpty ? null : _webhookSecretController.text.trim(),
      );
      setState(() {
        _stripe = stripe;
        _stripeSecretController.clear();
        _webhookSecretController.clear();
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception:', '').trim();
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppConstants.routeAdminDashboard),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: AppTheme.info),
                            const SizedBox(width: 12),
                            Text(
                              'Stripe Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Configure your Stripe account. Payments from users will go to this account.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        if (_stripe?['is_configured'] == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Stripe is configured',
                                  style: TextStyle(color: AppTheme.success, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Publishable Key (pk_live_... or pk_test_...)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _stripeKeyController,
                          decoration: const InputDecoration(
                            hintText: 'pk_live_... or pk_test_...',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: false,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Secret Key (sk_live_... or sk_test_...)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _stripeSecretController,
                          decoration: InputDecoration(
                            hintText: _stripe?['stripe_secret_set'] == true
                                ? 'Leave blank to keep current'
                                : 'sk_live_... or sk_test_...',
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        if (_stripe?['stripe_secret_masked'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Current: ${_stripe!['stripe_secret_masked']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Webhook Secret (whsec_...) - Optional',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _webhookSecretController,
                          decoration: InputDecoration(
                            hintText: _stripe?['stripe_webhook_secret_set'] == true
                                ? 'Leave blank to keep current'
                                : 'whsec_...',
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Save Settings',
                    onPressed: _isSaving ? null : _save,
                    isLoading: _isSaving,
                    icon: Icons.save,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 5), // Settings = index 5
    );
  }
}
