import "package:flutter/material.dart";

import "../models/match_card.dart";

class AttendeeDetailsScreen extends StatelessWidget {
  final MatchCard attendee;

  const AttendeeDetailsScreen({
    super.key,
    required this.attendee,
  });

  @override
  Widget build(BuildContext context) {
    final initials = attendee.firstName.isNotEmpty
        ? attendee.firstName[0].toUpperCase()
        : "?";

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Attendee"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor:
                    const Color(0xFFD4AF37),
                backgroundImage:
                    attendee.avatar != null &&
                            attendee.avatar!.isNotEmpty
                        ? NetworkImage(
                            attendee.avatar!,
                          )
                        : null,
                child:
                    attendee.avatar == null ||
                            attendee.avatar!.isEmpty
                        ? Text(
                            initials,
                            style:
                                const TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          )
                        : null,
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                attendee.fullName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            if (attendee.profession != null &&
                attendee.profession!.isNotEmpty)
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Text(
                    attendee.profession!,
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

            if (attendee.company != null &&
                attendee.company!.isNotEmpty)
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
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF181818),
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Color(
                          0xFFD4AF37,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "AI Match Insight",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    attendee.explanation ??
                        "No AI explanation available.",
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            if (attendee.reasons.isNotEmpty) ...[
              const SizedBox(height: 28),

              const Text(
                "Why You're a Match",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: attendee.reasons
                    .map(
                      (reason) => Chip(
                        backgroundColor:
                            const Color(
                          0xFF222222,
                        ),
                        side: BorderSide.none,
                        label: Text(
                          reason.message,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Messaging will be available in a future update.",
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.chat_bubble_outline,
                ),
                label: const Text(
                  "Message Attendee",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFFD4AF37,
                  ),
                  foregroundColor:
                      Colors.black,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
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