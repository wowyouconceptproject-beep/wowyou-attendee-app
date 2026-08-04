import "package:flutter/material.dart";

import "package:attendee_app/theme/app_colors.dart";

class RegisterButton
    extends StatelessWidget {
  final bool loading;

  final VoidCallback onPressed;

  const RegisterButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(
        24,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed:
              loading
                  ? null
                  : onPressed,
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primary,
            foregroundColor:
                Colors.white,
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                        AppColors.primary,
                  ),
                )
              : const Text(
                  "Get Ticket",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}