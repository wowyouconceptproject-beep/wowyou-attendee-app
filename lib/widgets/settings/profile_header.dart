import "package:flutter/material.dart";

import "../../models/user_settings.dart";

class ProfileHeader extends StatelessWidget {
  final UserSettings settings;

  const ProfileHeader({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundImage: settings.avatar != null
              ? NetworkImage(settings.avatar!)
              : null,
          child: settings.avatar == null
              ? const Icon(
                  Icons.person,
                  size: 46,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          settings.fullName,
          style: Theme.of(context)
              .textTheme
              .titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          settings.email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }
}