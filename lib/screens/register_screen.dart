import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "attendee_profile_screen.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final firstNameController =
      TextEditingController();

  final lastNameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  String? error;

  Future<void> register() async {
    setState(() {
      error = null;
    });

    final auth =
        context.read<AuthProvider>();

    final success =
        await auth.register(
      firstName:
          firstNameController.text
              .trim(),
      lastName:
          lastNameController.text
              .trim(),
      email:
          emailController.text.trim(),
      password:
          passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const AttendeeProfileScreen(),
        ),
        (_) => false,
      );
    } else {
      setState(() {
        error =
            "Registration failed.";
      });
    }
  }

  InputDecoration inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon),

      filled: true,

      fillColor:
          const Color(0xFF1B1B1B),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        borderSide:
            BorderSide.none,
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        borderSide:
            const BorderSide(
          color: Color(
            0xFFD4AF37,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    "Create Account",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Create your account to purchase tickets and access your Event Hub.",
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
                        firstNameController,
                    decoration:
                        inputDecoration(
                      "First Name",
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextField(
                    controller:
                        lastNameController,
                    decoration:
                        inputDecoration(
                      "Last Name",
                      Icons.badge_outlined,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
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
                    height: 20,
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
  color: Colors.red.withValues(alpha: 0.08),
  borderRadius: BorderRadius.circular(
    14,
  ),
),
                      child: Text(
                        error!,
                        style:
                            const TextStyle(
                          color:
                              Colors.red,
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
                            const Color(
                          0xFFD4AF37,
                        ),
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
                              : register,
                      child:
                          auth.isLoading
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
                                  "Create Account",
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

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
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