import "package:flutter/material.dart";

class SecuritySection extends StatelessWidget {
  const SecuritySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading:
                const Icon(Icons.lock),
            title: const Text(
              "Change Password",
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                const Icon(Icons.logout),
            title:
                const Text("Logout"),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}