import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
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
          await auth.login(
        email:
            _emailController.text
                .trim()
                .toLowerCase(),
        password:
            _passwordController.text,
      );

      if (!mounted) return;

      /*
       * Login can now have two outcomes:
       *
       * 1. OTP required
       * 2. Already authenticated through a
       *    defensive backend response
       */

      if (success &&
          auth.requiresLoginOtp) {
        final email =
            auth.pendingLoginEmail ??
                _emailController.text
                    .trim()
                    .toLowerCase();

        final verified =
            await Navigator.of(context)
                .push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                LoginOtpScreen(
              email: email,
            ),
          ),
        );

        if (!mounted) return;

        if (verified == true) {
          Navigator.of(context).pop(true);
        }

        return;
      }

      if (success &&
          auth.isAuthenticated) {
        Navigator.of(context).pop(true);
        return;
      }

      /*
       * The provider intentionally doesn't expose
       * an errorMessage property, so keep the
       * login screen independent of one.
       */
      _showError(
        'Unable to log in. Please check your email and password.',
      );
    } catch (e) {
      if (!mounted) return;

      _showError(
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

  void _showError(String message) {
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
                      .pop();
                },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              40,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.w700,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'Log in to access your tickets, events and attendee experience.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                TextFormField(
                  controller:
                      _emailController,
                  keyboardType:
                      TextInputType
                          .emailAddress,
                  textInputAction:
                      TextInputAction.next,
                  autocorrect: false,
                  decoration:
                      InputDecoration(
                    labelText:
                        'Email address',
                    hintText:
                        'you@example.com',
                    filled: true,
                    fillColor:
                        const Color(
                      0xFFF7F7F7,
                    ),
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 16,
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
                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            Colors.redAccent,
                      ),
                    ),
                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            Colors.redAccent,
                        width: 1.2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final email =
                        value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Enter your email address';
                    }

                    final emailRegex =
                        RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    );

                    if (!emailRegex
                        .hasMatch(email)) {
                      return 'Enter a valid email address';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 18,
                ),

                TextFormField(
                  controller:
                      _passwordController,
                  obscureText:
                      _obscurePassword,
                  textInputAction:
                      TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  onFieldSubmitted: (_) {
                    if (!_loading) {
                      _login();
                    }
                  },
                  decoration:
                      InputDecoration(
                    labelText: 'Password',
                    hintText:
                        'Enter your password',
                    filled: true,
                    fillColor:
                        const Color(
                      0xFFF7F7F7,
                    ),
                    suffixIcon:
                        IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                        color:
                            Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 16,
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
                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            Colors.redAccent,
                      ),
                    ),
                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            Colors.redAccent,
                        width: 1.2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Enter your password';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 54,
                  child:
                      ElevatedButton(
                    onPressed:
                        _loading
                            ? null
                            : _login,
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
                              strokeWidth:
                                  2.2,
                              valueColor:
                                  AlwaysStoppedAnimation<
                                      Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Log in',
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
                        _loading
                            ? null
                            : () {
                                Navigator.of(
                                  context,
                                ).pop();
                              },
                    child:
                        const Text(
                      'Don\'t have an account? Create one',
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
                    'A verification code will be sent to your email after your password is verified.',
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
      ),
    );
  }
}