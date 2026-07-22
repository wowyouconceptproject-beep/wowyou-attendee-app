import "package:flutter/material.dart";

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("Version"),
            trailing: Text("1.0.0"),
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                const Icon(Icons.policy),
            title: const Text(
              "Privacy Policy",
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                const Icon(Icons.gavel),
            title:
                const Text("Terms of Use"),
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