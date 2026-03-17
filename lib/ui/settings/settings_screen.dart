import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/ai_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/ai/ai_service_factory.dart';
import '../../services/drive_sync_service.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  AiProvider _activeProvider = AiProvider.gemini;
  final Map<AiProvider, TextEditingController> _keyControllers = {};
  final Map<AiProvider, bool> _keyVisible = {};
  final Map<AiProvider, bool?> _testResults = {};
  String _syncFrequency = 'manual';
  DateTime? _lastSync;
  bool _isLoading = true;
  bool _isBacking = false;
  bool _isRestoring = false;
  bool _isGoogleSignedIn = false;

  @override
  void initState() {
    super.initState();
    for (final p in AiProvider.values) {
      _keyControllers[p] = TextEditingController();
      _keyVisible[p] = false;
    }
    _loadSettings();
  }

  @override
  void dispose() {
    for (final c in _keyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _activeProvider = await repo.getActiveAiProvider();
    _syncFrequency = await repo.getDriveSyncFrequency();
    _lastSync = await repo.getLastSyncTime();

    for (final p in AiProvider.values) {
      final key = await repo.getApiKey(p);
      _keyControllers[p]!.text = key ?? '';
    }

    final driveService = ref.read(driveSyncServiceProvider);
    _isGoogleSignedIn = await driveService.isSignedIn;

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveApiKey(AiProvider provider) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setApiKey(provider, _keyControllers[provider]!.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${provider.displayName} API key saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _testConnection(AiProvider provider) async {
    setState(() => _testResults[provider] = null);

    final key = _keyControllers[provider]!.text.trim();
    if (key.isEmpty) {
      setState(() => _testResults[provider] = false);
      return;
    }

    final repo = ref.read(settingsRepositoryProvider);
    await repo.setApiKey(provider, key);

    try {
      final service = AiServiceFactory.create(provider, key);
      final result = await service.testConnection();
      if (mounted) setState(() => _testResults[provider] = result);
    } catch (_) {
      if (mounted) setState(() => _testResults[provider] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // AI Provider Section
            _SectionHeader(title: 'AI PROVIDER'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Provider',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: AiProvider.values.map((p) {
                        final isActive = _activeProvider == p;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: p != AiProvider.values.last ? 8 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() => _activeProvider = p);
                                final repo = ref.read(settingsRepositoryProvider);
                                await repo.setActiveAiProvider(p);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primary
                                      : isDark
                                          ? AppColors.backgroundDark
                                          : AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.primary
                                        : isDark
                                            ? AppColors.borderDark
                                            : AppColors.borderLight,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      p.displayName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isActive
                                            ? Colors.white
                                            : isDark
                                                ? AppColors.textPrimaryDark
                                                : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      p.modelDescription,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isActive
                                            ? Colors.white70
                                            : isDark
                                                ? AppColors.textTertiaryDark
                                                : AppColors.textTertiaryLight,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // API Keys
            ...AiProvider.values.map((provider) => _ApiKeyCard(
                  provider: provider,
                  controller: _keyControllers[provider]!,
                  isVisible: _keyVisible[provider]!,
                  testResult: _testResults[provider],
                  onToggleVisibility: () {
                    setState(
                        () => _keyVisible[provider] = !_keyVisible[provider]!);
                  },
                  onSave: () => _saveApiKey(provider),
                  onTest: () => _testConnection(provider),
                )),

            const SizedBox(height: 24),

            // Google Drive Sync
            _SectionHeader(title: 'GOOGLE DRIVE SYNC'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.cloud_upload,
                              color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Google Drive Backup',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_lastSync != null)
                                Text(
                                  'Last sync: ${DateFormat('MMM d, h:mm a').format(_lastSync!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight,
                                  ),
                                )
                              else
                                Text(
                                  'Not synced yet',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Sync frequency
                    Row(
                      children: [
                        Text(
                          'Frequency: ',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ...['manual', 'daily', 'weekly'].map((freq) {
                          final isActive = _syncFrequency == freq;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                freq[0].toUpperCase() + freq.substring(1),
                              ),
                              selected: isActive,
                              onSelected: (s) async {
                                setState(() => _syncFrequency = freq);
                                final repo =
                                    ref.read(settingsRepositoryProvider);
                                await repo.setDriveSyncFrequency(freq);
                              },
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : null,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (!_isGoogleSignedIn)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final driveService =
                                ref.read(driveSyncServiceProvider);
                            final account = await driveService.signIn();
                            if (account != null && mounted) {
                              setState(() => _isGoogleSignedIn = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Connected as ${account.email}'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.login, size: 18),
                          label: const Text('Connect Google Account'),
                        ),
                      )
                    else
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _isBacking
                                      ? null
                                      : () async {
                                          setState(() => _isBacking = true);
                                          try {
                                            final driveService = ref.read(
                                                driveSyncServiceProvider);
                                            await driveService.backup();
                                            _lastSync = DateTime.now();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Backup completed!'),
                                                  behavior: SnackBarBehavior
                                                      .floating,
                                                  backgroundColor:
                                                      AppColors.primary,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Backup failed: $e'),
                                                  behavior: SnackBarBehavior
                                                      .floating,
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                            }
                                          } finally {
                                            if (mounted) {
                                              setState(
                                                  () => _isBacking = false);
                                            }
                                          }
                                        },
                                  icon: _isBacking
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : const Icon(Icons.backup, size: 18),
                                  label: Text(
                                      _isBacking ? 'Backing up...' : 'Backup Now'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _isRestoring
                                      ? null
                                      : () async {
                                          setState(() => _isRestoring = true);
                                          try {
                                            final driveService = ref.read(
                                                driveSyncServiceProvider);
                                            await driveService.restore();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Restore completed!'),
                                                  behavior: SnackBarBehavior
                                                      .floating,
                                                  backgroundColor:
                                                      AppColors.primary,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Restore failed: $e'),
                                                  behavior: SnackBarBehavior
                                                      .floating,
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                            }
                                          } finally {
                                            if (mounted) {
                                              setState(
                                                  () => _isRestoring = false);
                                            }
                                          }
                                        },
                                  icon: _isRestoring
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : const Icon(Icons.cloud_download,
                                          size: 18),
                                  label: Text(
                                      _isRestoring ? 'Restoring...' : 'Restore'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () async {
                              final driveService =
                                  ref.read(driveSyncServiceProvider);
                              await driveService.signOut();
                              if (mounted) {
                                setState(() => _isGoogleSignedIn = false);
                              }
                            },
                            child: const Text(
                              'Disconnect Google Account',
                              style: TextStyle(
                                  color: AppColors.error, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // About
            _SectionHeader(title: 'ABOUT'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      label: 'Version',
                      value: '1.0.0',
                    ),
                    const Divider(height: 24),
                    _SettingsRow(
                      label: 'Build',
                      value: '1',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.textTertiaryDark
              : AppColors.textTertiaryLight,
        ),
      ),
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  final AiProvider provider;
  final TextEditingController controller;
  final bool isVisible;
  final bool? testResult;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSave;
  final VoidCallback onTest;

  const _ApiKeyCard({
    required this.provider,
    required this.controller,
    required this.isVisible,
    required this.testResult,
    required this.onToggleVisibility,
    required this.onSave,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${provider.displayName} API Key',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (testResult == true)
                  const Icon(Icons.check_circle,
                      color: AppColors.success, size: 18)
                else if (testResult == false)
                  const Icon(Icons.error, color: AppColors.error, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              obscureText: !isVisible,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              decoration: InputDecoration(
                hintText: 'Enter your ${provider.displayName} API key',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onTest,
                    child: const Text('Test', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSave,
                    child: const Text('Save', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettingsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
