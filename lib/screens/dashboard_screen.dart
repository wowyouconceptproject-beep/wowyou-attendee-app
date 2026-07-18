import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "login_screen.dart";

class DashboardScreen
extends StatelessWidget {
const DashboardScreen({
super.key,
});

@override
Widget build(
BuildContext context,
) {
final auth =
context.watch<AuthProvider>();


return Scaffold(
  appBar: AppBar(
    title: const Text(
      "Attendee Dashboard",
    ),
    actions: [
      IconButton(
        icon:
            const Icon(Icons.logout),
        onPressed: () async {
          await auth.logout();

          if (!context.mounted) {
            return;
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LoginScreen(),
            ),
            (_) => false,
          );
        },
      )
    ],
  ),
  body: Padding(
    padding:
        const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome ${auth.user?.firstName ?? ''}",
          style:
              const TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          auth.user?.email ??
              "",
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          "Role: ${auth.user?.role ?? ''}",
        ),
      ],
    ),
  ),
);


}
}
