import "package:flutter/material.dart";

class DiscoveryHeader extends StatelessWidget {
  const DiscoveryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          12,
          24,
          20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning",
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Colors.grey,
                            ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Discover",
                        style: theme
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              fontWeight:
                                  FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 52,
                  height: 52,
                  decoration:
                      BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFFD4AF37),
                        Color(0xFFB8860B),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 28,
            ),

            Text(
              "Find your next experience",
              style: theme
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                    height: 1.15,
                  ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              "Discover conferences, networking events, concerts and unforgettable experiences happening around you.",
              style: theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: Colors.grey,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}