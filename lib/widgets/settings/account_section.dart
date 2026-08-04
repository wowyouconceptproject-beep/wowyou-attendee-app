import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class AccountSection extends StatelessWidget {
  final TextEditingController bioController;

  const AccountSection({
    super.key,
    required this.bioController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Profile",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    color:
                        AppColors.text,
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller: bioController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                labelText: "Bio",
                labelStyle: TextStyle(
                  color: AppColors
                      .textSecondary,
                ),
                filled: true,
                fillColor:
                    AppColors.card,
                border:
                    OutlineInputBorder(),
                enabledBorder:
                    OutlineInputBorder(
                  borderSide:
                      BorderSide(
                    color: AppColors
                        .border,
                  ),
                ),
                focusedBorder:
                    OutlineInputBorder(
                  borderSide:
                      BorderSide(
                    color: AppColors
                        .primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}