import "package:flutter/material.dart";

import "../../models/user_settings.dart";
import "package:attendee_app/theme/app_colors.dart";

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
          backgroundColor: AppColors.primary,
          backgroundImage:
              settings.avatar != null
                  ? NetworkImage(
                      settings.avatar!,
                    )
                  : null,
          child:
              settings.avatar == null
                  ? const Icon(
                      Icons.person,
                      size: 46,
                      color: Colors.white,
                    )
                  : null,
        ),

        const SizedBox(
          height: 16,
        ),

        Text(
          settings.fullName,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                color: AppColors.text,
                fontWeight:
                    FontWeight.bold,
              ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          settings.email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
                color: AppColors
                    .textSecondary,
              ),
        ),
      ],
    );
  }
}