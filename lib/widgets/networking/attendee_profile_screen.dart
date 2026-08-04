import "package:flutter/material.dart";

import "../../models/match_card.dart";
import "package:attendee_app/theme/app_colors.dart";

class AttendeeProfileScreen extends StatelessWidget {
  final MatchCard attendee;

  const AttendeeProfileScreen({
    super.key,
    required this.attendee,
  });

  @override
  Widget build(BuildContext context) {
    final initials =
        attendee.firstName.isNotEmpty
            ? attendee.firstName[0].toUpperCase()
            : "?";

    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title: const Text(
          "Attendee Profile",
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(
          24,
        ),
        children: [
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundColor:
                  AppColors.primary,
              backgroundImage:
                  attendee.avatar != null &&
                          attendee.avatar!
                              .isNotEmpty
                      ? NetworkImage(
                          attendee
                              .avatar!,
                        )
                      : null,
              child:
                  attendee.avatar ==
                              null ||
                          attendee
                              .avatar!
                              .isEmpty
                      ? Text(
                          initials,
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize:
                                34,
                          ),
                        )
                      : null,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          Center(
            child: Text(
              attendee.fullName,
              style:
                  const TextStyle(
                color:
                    AppColors.text,
                fontSize: 28,
                fontWeight:
                    FontWeight
                        .bold,
              ),
            ),
          ),

          if (attendee.profession !=
              null)
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(
                  top: 8,
                ),
                child: Text(
                  attendee
                      .profession!,
                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

          if (attendee.company !=
              null)
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(
                  top: 4,
                ),
                child: Text(
                  attendee.company!,
                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ),
            ),

          const SizedBox(
            height: 32,
          ),

          Container(
            padding:
                const EdgeInsets.all(
              20,
            ),
            decoration:
                BoxDecoration(
              color:
                  AppColors.card,
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color:
                    AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons
                          .auto_awesome,
                      color:
                          AppColors
                              .primary,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "AI Insight",
                      style:
                          TextStyle(
                        color:
                            AppColors
                                .text,
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize:
                            18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  attendee.explanation ??
                      "No AI insight available.",
                  style:
                      const TextStyle(
                    height: 1.7,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (attendee
              .reasons
              .isNotEmpty) ...[
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Why You're a Match",
              style: TextStyle(
                color:
                    AppColors.text,
                fontSize: 20,
                fontWeight:
                    FontWeight
                        .bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  attendee.reasons
                      .map(
                        (reason) =>
                            Chip(
                          backgroundColor:
                              AppColors
                                  .surface,
                          side:
                              const BorderSide(
                            color:
                                AppColors.border,
                          ),
                          label: Text(
                            reason
                                .message,
                            style:
                                const TextStyle(
                              color:
                                  AppColors.text,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],

          const SizedBox(
            height: 40,
          ),

          SizedBox(
            width:
                double.infinity,
            child:
                ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Direct messaging will be available in V2.",
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons
                    .chat_bubble,
              ),
              label: const Text(
                "Message Attendee",
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 18,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}