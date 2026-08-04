import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      child: Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.info,
              color: AppColors.primary,
            ),
            title: Text("Version"),
            trailing: Text(
              "1.0.0",
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          ListTile(
            leading: const Icon(
              Icons.policy,
              color: AppColors.primary,
            ),
            title: const Text(
              "Privacy Policy",
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
            onTap: () {},
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          ListTile(
            leading: const Icon(
              Icons.gavel,
              color: AppColors.primary,
            ),
            title: const Text(
              "Terms of Use",
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}