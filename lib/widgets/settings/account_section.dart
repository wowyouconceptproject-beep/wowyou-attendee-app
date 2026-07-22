import "package:flutter/material.dart";

class AccountSection extends StatelessWidget {
  final TextEditingController bioController;

  const AccountSection({
    super.key,
    required this.bioController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Profile",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                labelText: "Bio",
                border:
                    OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}