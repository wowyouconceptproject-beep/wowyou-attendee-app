import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginOtpScreen extends StatefulWidget {
  final String email;

  const LoginOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<LoginOtpScreen> createState() =>
      _LoginOtpScreenState();
}

class _LoginOtpScreenState
    extends State<LoginOtpScreen> {
  final _otpController =
      TextEditingController();

  bool _loading = false;
  bool _resending = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp =
        _otpController.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      _showMessage(
        'Enter the 6-digit verification code.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
    });

    try {
      final auth =
          context.read<AuthProvider>();

      final success =
          await auth.verifyLoginOtp(
        otp: otp,
      );

      if (!mounted) return;

      if (!success) {
        _showMessage(
          'The verification code is invalid or has expired.',
        );
        return;
      }

      /*
       * AuthProvider has now:
       * - verified the OTP
       * - received the JWT
       * - stored the JWT
       * - loaded /auth/me
       * - established the authenticated session
       */

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_resending || _loading) {
      return;
    }

    setState(() {
      _resending = true;
    });

    try {
      final auth =
          context.read<AuthProvider>();

      final success =
          await auth.resendLoginOtp();

      if (!mounted) return;

      if (success) {
        _showMessage(
          'A new verification code has been sent to your email.',
        );
      } else {
        _showMessage(
          'Unable to resend the verification code.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _resending = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor:
            Colors.transparent,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: _loading
              ? null
              : () {
                  Navigator.of(context)
                      .pop(false);
                },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            40,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const SizedBox(
                height: 20,
              ),

              const Text(
                'Verify your login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w700,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                'Enter the 6-digit verification code we sent to your email address.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              TextField(
                controller:
                    _otpController,

                keyboardType:
                    TextInputType.number,

                textInputAction:
                    TextInputAction.done,

                maxLength: 6,

                autofocus: true,

                textAlign:
                    TextAlign.center,

                style: const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w600,
                  letterSpacing: 8,
                ),

                onSubmitted: (_) {
                  if (!_loading) {
                    _verifyOtp();
                  }
                },

                decoration:
                    InputDecoration(
                  counterText: '',

                  hintText: '000000',

                  hintStyle:
                      const TextStyle(
                    color: Colors.black26,
                    letterSpacing: 8,
                  ),

                  filled: true,

                  fillColor:
                      const Color(
                    0xFFF7F7F7,
                  ),

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                        const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width: double.infinity,
                height: 54,

                child:
                    ElevatedButton(
                  onPressed:
                      _loading
                          ? null
                          : _verifyOtp,

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors.black,

                    foregroundColor:
                        Colors.white,

                    disabledBackgroundColor:
                        Colors.black12,

                    disabledForegroundColor:
                        Colors.white70,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),

                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,

                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.2,

                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Verify and continue',
                          style:
                              TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Center(
                child:
                    TextButton(
                  onPressed:
                      (_resending ||
                              _loading)
                          ? null
                          : _resendOtp,

                  child:
                      _resending
                          ? const SizedBox(
                              width: 18,
                              height: 18,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Resend code',
                              style:
                                  TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              const Center(
                child: Text(
                  'The verification code expires after a short period. Check your spam or junk folder if you do not see the email.',
                  textAlign:
                      TextAlign.center,
                  style:
                      TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color:
                        Colors.black38,
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