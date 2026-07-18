import "package:flutter/material.dart";

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
          const EdgeInsets.all(24),
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
                const Color(
              0xFFD4AF37,
            ),
            foregroundColor:
                Colors.black,
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
          ),
          child: loading
              ? const CircularProgressIndicator()
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