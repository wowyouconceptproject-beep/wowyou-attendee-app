import "package:flutter/material.dart";

import "../../models/user_settings.dart";
import "../../services/settings_service.dart";

import "../../widgets/settings/about_section.dart";
import "../../widgets/settings/account_section.dart";
import "../../widgets/settings/notification_section.dart";
import "../../widgets/settings/profile_header.dart";
import "../../widgets/settings/security_section.dart";

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

  bool _loading = true;
  bool _saving = false;

  UserSettings? _settings;

  final TextEditingController _bioController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _loading = true;
    });

    final settings =
        await _service.getSettings();

    if (!mounted) return;

    if (settings != null) {
      _bioController.text =
          settings.bio ?? "";
    }

    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_settings == null) return;

    setState(() {
      _saving = true;
    });

    final updated =
        _settings!.copyWith(
      bio: _bioController.text.trim(),
    );

    final success =
        await _service.updateSettings(
      settings: updated,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;

      if (success) {
        _settings = updated;
      }
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _settings == null
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        "Unable to load settings.",
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      FilledButton(
                        onPressed:
                            _loadSettings,
                        child: const Text(
                          "Retry",
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh:
                      _loadSettings,
                  child: ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    children: [
                      ProfileHeader(
                        settings:
                            _settings!,
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      AccountSection(
                        bioController:
                            _bioController,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      NotificationSection(
                        push: _settings!
                            .pushNotifications,
                        email: _settings!
                            .emailNotifications,
                        sms: _settings!
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

                      const SecuritySection(),

                      const SizedBox(
                        height: 20,
                      ),

                      const AboutSection(),

                      const SizedBox(
                        height: 32,
                      ),

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
                                  Icons.save,
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
                ),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }
}