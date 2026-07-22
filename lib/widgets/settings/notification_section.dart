import "package:flutter/material.dart";

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
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Column(
          children: [
            SwitchListTile(
              value: push,
              title: const Text(
                "Push Notifications",
              ),
              onChanged: onPushChanged,
            ),
            SwitchListTile(
              value: email,
              title: const Text(
                "Email Notifications",
              ),
              onChanged: onEmailChanged,
            ),
            SwitchListTile(
              value: sms,
              title: const Text(
                "SMS Notifications",
              ),
              onChanged: onSmsChanged,
            ),
          ],
        ),
      ),
    );
  }
}