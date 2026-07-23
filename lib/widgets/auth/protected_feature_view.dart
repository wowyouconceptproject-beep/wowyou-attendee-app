import "package:flutter/material.dart";

class ProtectedFeatureView extends StatelessWidget {
  const ProtectedFeatureView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onSignIn,
    required this.onCreateAccount,
    this.benefits = const [],
    this.footer,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> benefits;

  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;

  /// Optional widget shown below the buttons.
  /// Useful for "Continue as Guest", "Learn More", etc.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(
                      0xFFD4AF37,
                    ).withValues(
                      alpha: 0.15,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 46,
                    color: const Color(
                      0xFFD4AF37,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                if (benefits.isNotEmpty) ...[
                  const SizedBox(
                    height: 36,
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.05,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(
                        color: Colors.white
                            .withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                    child: Column(
                      children: benefits
                          .map(
                            (benefit) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(
                                      0xFFD4AF37,
                                    ),
                                    size: 20,
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style:
                                          const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(
                  height: 40,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
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
                    onPressed: onSignIn,
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextButton(
                  onPressed:
                      onCreateAccount,
                  child: const Text(
                    "Create an Account",
                    style: TextStyle(
                      color: Color(
                        0xFFD4AF37,
                      ),
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                if (footer != null) ...[
                  const SizedBox(
                    height: 24,
                  ),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}