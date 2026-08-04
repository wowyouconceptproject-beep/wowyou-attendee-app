import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class NotificationSection extends StatelessWidget {
  final bool push;

  final bool email;

  final bool sms;

  final ValueChanged<bool> onPushChanged;

  final ValueChanged<bool> onEmailChanged;

  final ValueChanged<bool> onSmsChanged;

  const NotificationSection({
    super.key,
    required this.push,
    required this.email,
    required this.sms,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onSmsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            switchTheme: SwitchThemeData(
              thumbColor:
                  WidgetStateProperty.resolveWith(
                (states) => states.contains(
                  WidgetState.selected,
                )
                    ? AppColors.primary
                    : Colors.grey,
              ),
              trackColor:
                  WidgetStateProperty.resolveWith(
                (states) => states.contains(
                  WidgetState.selected,
                )
                    ? AppColors.primary
                        .withValues(alpha: 0.35)
                    : Colors.white12,
              ),
            ),
          ),
          child: Column(
            children: [
              SwitchListTile(
                activeColor:
                    AppColors.primary,
                value: push,
                title: const Text(
                  "Push Notifications",
                ),
                onChanged:
                    onPushChanged,
              ),

              const Divider(
                height: 1,
                color: AppColors.border,
              ),

              SwitchListTile(
                activeColor:
                    AppColors.primary,
                value: email,
                title: const Text(
                  "Email Notifications",
                ),
                onChanged:
                    onEmailChanged,
              ),

              const Divider(
                height: 1,
                color: AppColors.border,
              ),

              SwitchListTile(
                activeColor:
                    AppColors.primary,
                value: sms,
                title: const Text(
                  "SMS Notifications",
                ),
                onChanged:
                    onSmsChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}