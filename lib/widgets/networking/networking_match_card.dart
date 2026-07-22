import "package:flutter/material.dart";

import "../../models/match_card.dart";
import "../../screens/attendee_details_screen.dart";

class NetworkingMatchCard extends StatelessWidget {
  final MatchCard match;

  const NetworkingMatchCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final initials = match.firstName.isNotEmpty
        ? match.firstName[0].toUpperCase()
        : "?";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFD4AF37),
                  backgroundImage: match.avatar != null &&
                          match.avatar!.isNotEmpty
                      ? NetworkImage(match.avatar!)
                      : null,
                  child: match.avatar == null ||
                          match.avatar!.isEmpty
                      ? Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (match.profession != null &&
                          match.profession!.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 4),
                          child: Text(
                            match.profession!,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      if (match.company != null &&
                          match.company!.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 2),
                          child: Text(
                            match.company!,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "MATCH",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "${match.score}%",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (match.explanation != null &&
                match.explanation!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFD4AF37),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "AI Insight",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      match.explanation!,
                      style: const TextStyle(
                        height: 1.6,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (match.reasons.isNotEmpty) ...[
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: match.reasons
                    .map(
                      (reason) => Chip(
                        backgroundColor:
                            const Color(
                                0xFF2A2A2A),
                        side: BorderSide.none,
                        label: Text(
                          reason.message,
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AttendeeDetailsScreen(
        attendee: match,
      ),
    ),
  );
},
                icon: const Icon(
                  Icons.person_outline,
                ),
                label: const Text(
                  "View Profile",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFD4AF37),
                  foregroundColor:
                      Colors.black,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
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