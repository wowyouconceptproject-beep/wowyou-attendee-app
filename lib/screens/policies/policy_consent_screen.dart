import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../providers/auth_provider.dart";
import "../../services/legal_service.dart";
import "../../theme/app_colors.dart";
import "../../utils/storage.dart";

class PolicyConsentScreen extends StatefulWidget {
  final VoidCallback onAccepted;

  const PolicyConsentScreen({
    super.key,
    required this.onAccepted,
  });

  @override
  State<PolicyConsentScreen> createState() =>
      _PolicyConsentScreenState();
}

class _PolicyConsentScreenState
    extends State<PolicyConsentScreen> {
  static const String policyVersion = "v1.0";

  final LegalService _legalService =
      LegalService();

  bool _accepted = false;
  bool _loading = false;

  Future<void> _agree() async {
    if (!_accepted || _loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final auth =
          context.read<AuthProvider>();

      if (!auth.isAuthenticated) {
        throw Exception(
          "Authentication required.",
        );
      }

      debugPrint(
        "CONSENT: sending request",
      );

      /*
      |--------------------------------------------------------------------------
      | Record Consent On Backend
      |--------------------------------------------------------------------------
      */

      await _legalService.acceptPolicies(
        fullName:
            _getFullName(auth),
        email:
            _getEmail(auth),
        role:
            _getRole(auth),
      );

      debugPrint(
        "CONSENT: backend accepted",
      );

      /*
      |--------------------------------------------------------------------------
      | Cache Current Policy Version
      |--------------------------------------------------------------------------
      */

      await Storage.setPolicyConsent(
        version: policyVersion,
      );

      debugPrint(
        "CONSENT: local storage saved",
      );

      if (!mounted) {
        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Stop Loading
      |--------------------------------------------------------------------------
      */

      setState(() {
        _loading = false;
      });

      debugPrint(
        "CONSENT: loading stopped",
      );

      /*
      |--------------------------------------------------------------------------
      | Continue Application
      |--------------------------------------------------------------------------
      */

      widget.onAccepted();

      debugPrint(
        "CONSENT: onAccepted called",
      );
    } catch (e, stackTrace) {
      debugPrint(
        "CONSENT ERROR: $e",
      );

      debugPrint(
        "$stackTrace",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  String _getFullName(
    AuthProvider auth,
  ) {
    final user = auth.user;

    if (user == null) {
      throw Exception(
        "Unable to determine account information.",
      );
    }

    final firstName =
        user.firstName.trim();

    final lastName =
        user.lastName.trim();

    final fullName =
        "$firstName $lastName".trim();

    if (fullName.isEmpty) {
      throw Exception(
        "Your account name is unavailable.",
      );
    }

    return fullName;
  }

  String _getEmail(
    AuthProvider auth,
  ) {
    final user = auth.user;

    if (user == null ||
        user.email.trim().isEmpty) {
      throw Exception(
        "Your account email is unavailable.",
      );
    }

    return user.email.trim();
  }

  String _getRole(
    AuthProvider auth,
  ) {
    final user = auth.user;

    if (user == null) {
      throw Exception(
        "Unable to determine account role.",
      );
    }

    return "ATTENDEE";
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const Text(
                "Before you continue",
                style: TextStyle(
                  color:
                      AppColors.text,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              const Text(
                "By continuing, I confirm that I have read, understood and agree to the EventOS platform policies, including the Terms of Service, Privacy Policy, Acceptable Use Policy, Refund & Cancellation Policy, AI Usage Policy, Data Processing Agreement where applicable, Marketplace Vendor Terms where applicable, and Sub-processor List.",
                style: TextStyle(
                  color:
                      AppColors
                          .textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              InkWell(
                onTap: _loading
                    ? null
                    : () {
                        setState(() {
                          _accepted =
                              !_accepted;
                        });
                      },
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Checkbox(
                        value:
                            _accepted,
                        onChanged:
                            _loading
                                ? null
                                : (value) {
                                    setState(
                                      () {
                                        _accepted =
                                            value ??
                                                false;
                                      },
                                    );
                                  },
                      ),
                      const Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(
                            top: 12,
                          ),
                          child: Text(
                            "I agree to the EventOS platform policies.",
                            style:
                                TextStyle(
                              color:
                                  AppColors
                                      .text,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width:
                    double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed:
                      _accepted &&
                              !_loading
                          ? _agree
                          : null,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                          ),
                        )
                      : const Text(
                          "I Agree",
                        ),
                ),
              ),

              const Spacer(),

              const Center(
                child: Text(
                  "EventOS by WoWYou Concepts Ltd",
                  style: TextStyle(
                    color:
                        AppColors.border,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}