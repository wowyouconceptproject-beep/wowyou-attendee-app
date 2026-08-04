import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class SecuritySection extends StatelessWidget {
  final Future<void> Function() onLogout;
  final bool loggingOut;

  const SecuritySection({
    super.key,
    required this.onLogout,
    this.loggingOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: 0.15),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 21,
                color: AppColors.primary,
              ),
            ),
            title: const Text(
              "Change Password",
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              "Update your account password",
              style: TextStyle(
                color:
                    AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color:
                  AppColors.textSecondary,
            ),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Password management is coming soon.",
                  ),
                ),
              );
            },
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          ListTile(
            enabled: !loggingOut,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.error
                    .withValues(alpha: 0.15),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: loggingOut
                  ? const Padding(
                      padding:
                          EdgeInsets.all(
                        11,
                      ),
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                            AppColors.error,
                      ),
                    )
                  : const Icon(
                      Icons.logout,
                      size: 21,
                      color:
                          AppColors.error,
                    ),
            ),
            title: Text(
              loggingOut
                  ? "Logging out..."
                  : "Logout",
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                color:
                    AppColors.error,
              ),
            ),
            subtitle: const Text(
              "Sign out of your WOWYOU account",
              style: TextStyle(
                color:
                    AppColors.textSecondary,
              ),
            ),
            trailing: loggingOut
                ? null
                : const Icon(
                    Icons.chevron_right,
                    color:
                        AppColors.error,
                  ),
            onTap: loggingOut
                ? null
                : () async {
                    await onLogout();
                  },
          ),
        ],
      ),
    );
  }
}