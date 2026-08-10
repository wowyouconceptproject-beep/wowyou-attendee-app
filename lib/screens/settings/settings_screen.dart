import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../models/user_settings.dart";
import "../../providers/auth_provider.dart";
import "../../services/settings_service.dart";

import "../../widgets/auth/protected_feature_view.dart";
import "../../widgets/settings/about_section.dart";
import "../../widgets/settings/account_section.dart";
import "../../widgets/settings/notification_section.dart";
import "../../widgets/settings/profile_header.dart";
import "../../widgets/settings/security_section.dart";
import "../legal/legal_policies_screen.dart";
import "../../theme/app_colors.dart";

import "../login_screen.dart";
import "../register_screen.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final SettingsService _service =
      SettingsService();

  final TextEditingController
      _bioController =
      TextEditingController();

  UserSettings? _settings;

  bool _loading = true;
  bool _saving = false;
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();

    /*
    |--------------------------------------------------------------------------
    | Load settings after first frame
    |--------------------------------------------------------------------------
    */

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        _loadSettings();
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Load Settings
  |--------------------------------------------------------------------------
  */

  Future<void> _loadSettings() async {
    if (!mounted) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    /*
    |--------------------------------------------------------------------------
    | Do not request protected settings for guests
    |--------------------------------------------------------------------------
    */

    if (!auth.isAuthenticated) {
      setState(() {
        _settings = null;
        _loading = false;
      });

      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final settings =
          await _service.getSettings();

      if (!mounted) {
        return;
      }

      if (settings != null) {
        _bioController.text =
            settings.bio ?? "";
      }

      setState(() {
        _settings = settings;
        _loading = false;
      });
    } catch (error, stackTrace) {
      debugPrint(
        "SETTINGS LOAD ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _settings = null;
        _loading = false;
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Save Settings
  |--------------------------------------------------------------------------
  */

  Future<void> _save() async {
    if (_settings == null ||
        _saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final updated =
          _settings!.copyWith(
        bio:
            _bioController.text.trim(),
      );

      final success =
          await _service.updateSettings(
        settings: updated,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        setState(() {
          _settings = updated;
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "Settings updated successfully."
                : "Unable to update settings.",
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        "SETTINGS SAVE ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to update settings.",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Logout
  |--------------------------------------------------------------------------
  */

  Future<void> _logout() async {
    if (_loggingOut) {
      return;
    }

    /*
    |--------------------------------------------------------------------------
    | Confirmation
    |--------------------------------------------------------------------------
    */

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title: const Text(
            "Log out?",
          ),
          content: const Text(
            "You will need to sign in again to access your account, tickets and personalized features.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                "Cancel",
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                "Log Out",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !mounted) {
      return;
    }

    setState(() {
      _loggingOut = true;
    });

    try {
      final auth =
          context.read<AuthProvider>();

      /*
      |--------------------------------------------------------------------------
      | Clear authenticated session
      |--------------------------------------------------------------------------
      */

      await auth.logout();

      if (!mounted) {
        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Remove authenticated navigation history
      |--------------------------------------------------------------------------
      |
      | This prevents the user from pressing back
      | and returning to authenticated screens.
      |
      */

      Navigator.of(context)
          .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (error, stackTrace) {
      debugPrint(
        "LOGOUT ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to log out. Please try again.",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loggingOut = false;
        });
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Authentication Navigation
  |--------------------------------------------------------------------------
  */

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const RegisterScreen(),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Build
  |--------------------------------------------------------------------------
  */

  @override
  Widget build(
    BuildContext context,
  ) {
    final auth =
        context.watch<AuthProvider>();

    /*
    |--------------------------------------------------------------------------
    | Guest View
    |--------------------------------------------------------------------------
    */

    if (!auth.isAuthenticated) {
      return ProtectedFeatureView(
        icon:
            Icons.person_outline,
        title:
            "Welcome to WOWYOU",
        description:
            "Create an account to personalize your event experience.",
        benefits: const [
          "Manage your profile",
          "Notification preferences",
          "Saved events",
          "Secure account",
        ],
        onSignIn:
            _openLogin,
        onCreateAccount:
            _openRegister,
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Authenticated View
    |--------------------------------------------------------------------------
    */

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: _buildBody(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Settings Body
  |--------------------------------------------------------------------------
  */

  Widget _buildBody() {
    /*
    |--------------------------------------------------------------------------
    | Loading
    |--------------------------------------------------------------------------
    */

    if (_loading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Failed State
    |--------------------------------------------------------------------------
    */

    if (_settings == null) {
      return RefreshIndicator(
        onRefresh:
            _loadSettings,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.all(
            24,
          ),
          children: [
            const SizedBox(
              height: 120,
            ),

            const Icon(
              Icons
                  .error_outline_rounded,
              size: 46,
            ),

            const SizedBox(
              height: 18,
            ),

            const Center(
              child: Text(
                "Unable to load settings.",
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Center(
              child: Text(
                "Check your connection and try again.",
                textAlign:
                    TextAlign.center,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Center(
              child:
                  FilledButton.icon(
                onPressed:
                    _loadSettings,
                icon: const Icon(
                  Icons.refresh,
                ),
                label:
                    const Text(
                  "Retry",
                ),
              ),
            ),
          ],
        ),
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Settings
    |--------------------------------------------------------------------------
    */

    return RefreshIndicator(
      onRefresh:
          _loadSettings,
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        children: [
          /*
          |--------------------------------------------------------------------------
          | Profile
          |--------------------------------------------------------------------------
          */

          ProfileHeader(
            settings:
                _settings!,
          ),

          const SizedBox(
            height: 30,
          ),

          /*
          |--------------------------------------------------------------------------
          | Account
          |--------------------------------------------------------------------------
          */

          AccountSection(
            bioController:
                _bioController,
          ),

          const SizedBox(
            height: 20,
          ),

          /*
          |--------------------------------------------------------------------------
          | Notifications
          |--------------------------------------------------------------------------
          */

          NotificationSection(
            push:
                _settings!
                    .pushNotifications,
            email:
                _settings!
                    .emailNotifications,
            sms:
                _settings!
                    .smsNotifications,

            onPushChanged:
                (value) {
              setState(() {
                _settings =
                    _settings!
                        .copyWith(
                  pushNotifications:
                      value,
                );
              });
            },

            onEmailChanged:
                (value) {
              setState(() {
                _settings =
                    _settings!
                        .copyWith(
                  emailNotifications:
                      value,
                );
              });
            },

            onSmsChanged:
                (value) {
              setState(() {
                _settings =
                    _settings!
                        .copyWith(
                  smsNotifications:
                      value,
                );
              });
            },
          ),

          const SizedBox(
            height: 20,
          ),

          /*
          |--------------------------------------------------------------------------
          | Security
          |--------------------------------------------------------------------------
          */

          SecuritySection(
            onLogout:
                _logout,
            loggingOut:
                _loggingOut,
          ),

          const SizedBox(
            height: 20,
          ),

          /*
          |--------------------------------------------------------------------------
          | About
          |--------------------------------------------------------------------------
          */

          const AboutSection(),

const SizedBox(
  height: 20,
),

Card(
  child: ListTile(
    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 8,
    ),
    leading: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary
            .withValues(alpha: 0.10),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.gavel_outlined,
        color: AppColors.primary,
      ),
    ),
    title: const Text(
      "Legal & Policies",
      style: TextStyle(
        fontWeight: FontWeight.w700,
      ),
    ),
    subtitle: const Padding(
      padding: EdgeInsets.only(
        top: 4,
      ),
      child: Text(
        "Terms, privacy, refunds, AI and other policies.",
      ),
    ),
    trailing: const Icon(
      Icons.chevron_right,
    ),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              const LegalPoliciesScreen(),
        ),
      );
    },
  ),
),

          /*
          |--------------------------------------------------------------------------
          | Save
          |--------------------------------------------------------------------------
          */

          SizedBox(
            height: 52,
            child:
                FilledButton.icon(
              onPressed:
                  _saving
                      ? null
                      : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth:
                            2,
                      ),
                    )
                  : const Icon(
                      Icons
                          .save_outlined,
                    ),
              label: Text(
                _saving
                    ? "Saving..."
                    : "Save Changes",
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Dispose
  |--------------------------------------------------------------------------
  */

  @override
  void dispose() {
    _bioController.dispose();

    super.dispose();
  }
}