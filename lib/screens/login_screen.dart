import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "register_screen.dart";
import "package:attendee_app/theme/app_colors.dart";

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
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  String? error;

  Future<void> login() async {
  setState(() {
    error = null;
  });

  final auth = context.read<AuthProvider>();

  final success = await auth.login(
    email: emailController.text.trim(),
    password: passwordController.text,
  );

  if (!mounted) return;

  if (success) {
    Navigator.pop(context, true);
  } else {
    setState(() {
      error = "Invalid email or password";
    });
  }
}

 InputDecoration inputDecoration(
  String hint,
  IconData icon,
) {
  return InputDecoration(
    hintText: hint,

    prefixIcon: Icon(
      icon,
      color: AppColors.primary,
    ),

    filled: true,

    fillColor: AppColors.card,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        16,
      ),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        16,
      ),
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        16,
      ),
      borderSide: const BorderSide(
        color: AppColors.primary,
      ),
    ),
  );
}

  @override
  Widget build(
    BuildContext context,
  ) {
    final auth =
        context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Sign in to continue to your Event Hub.",
                    style: TextStyle(
                      color:
                          Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                    height: 36,
                  ),

                  TextField(
                    controller:
                        emailController,
                    keyboardType:
                        TextInputType
                            .emailAddress,
                    decoration:
                        inputDecoration(
                      "Email",
                      Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextField(
                    controller:
                        passwordController,
                    obscureText: true,
                    decoration:
                        inputDecoration(
                      "Password",
                      Icons.lock_outline,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Align(
                    alignment:
                        Alignment
                            .centerRight,
                    child:
                        TextButton(
                      onPressed: () {
                        // TODO:
                        // Forgot password
                      },
                      child: const Text(
                        "Forgot Password?",
                      ),
                    ),
                  ),

                  if (error != null)
                    Container(
                      width:
                          double.infinity,
                      margin:
                          const EdgeInsets.only(
                        bottom: 20,
                      ),
                      padding:
                          const EdgeInsets.all(
                        14,
                      ),
                     decoration: BoxDecoration(
  color: AppColors.error.withValues(
  alpha: 0.08,
),
  borderRadius: BorderRadius.circular(
    14,
  ),
),
                      child: Text(
                        error!,
                        style:
                            const TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                    ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 56,
                    child:
                        ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
    AppColors.primary,
                        foregroundColor:
                            Colors.black,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                      onPressed:
                          auth.isLoading
                              ? null
                              : login,
                      child:
                          auth.isLoading
                              ? const SizedBox(
                                  width:
                                      22,
                                  height:
                                      22,
                                  child:
                                     CircularProgressIndicator(
  strokeWidth: 2,
  color: AppColors.primary,
),
                                )
                              : const Text(
                                  "Sign In",
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        "Don't have an account?",
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Create Account",
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}