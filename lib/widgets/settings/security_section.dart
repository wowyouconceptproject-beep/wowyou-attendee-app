import "package:flutter/material.dart";

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
    final theme =
        Theme.of(context);

    return Card(
      clipBehavior:
          Clip.antiAlias,
      child: Column(
        children: [
          /*
          |--------------------------------------------------------------------------
          | Change Password
          |--------------------------------------------------------------------------
          */

          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                color: theme
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 21,
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
            ),

            /*
            |--------------------------------------------------------------------------
            | Deliberately disabled until password flow exists
            |--------------------------------------------------------------------------
            */

            trailing: const Icon(
              Icons.chevron_right,
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
          ),

          /*
          |--------------------------------------------------------------------------
          | Logout
          |--------------------------------------------------------------------------
          */

          ListTile(
            enabled:
                !loggingOut,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                color: theme
                    .colorScheme
                    .errorContainer,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: loggingOut
                  ? Padding(
                      padding:
                          const EdgeInsets.all(
                        11,
                      ),
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme
                            .colorScheme
                            .onErrorContainer,
                      ),
                    )
                  : Icon(
                      Icons.logout,
                      size: 21,
                      color: theme
                          .colorScheme
                          .onErrorContainer,
                    ),
            ),
            title: Text(
              loggingOut
                  ? "Logging out..."
                  : "Logout",
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
                color: theme
                    .colorScheme
                    .error,
              ),
            ),
            subtitle: const Text(
              "Sign out of your WOWYOU account",
            ),
            trailing:
                loggingOut
                    ? null
                    : Icon(
                        Icons
                            .chevron_right,
                        color: theme
                            .colorScheme
                            .error,
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