import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class RefreshButton extends StatelessWidget {
  final bool loading;

  final VoidCallback onPressed;

  const RefreshButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed:
            loading ? null : onPressed,
        icon: const Icon(
          Icons.refresh,
        ),
        label: const Text(
          "Refresh Pass",
        ),
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              AppColors.primary,
          side: const BorderSide(
            color:
                AppColors.primary,
          ),
          padding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),
    );
  }
}