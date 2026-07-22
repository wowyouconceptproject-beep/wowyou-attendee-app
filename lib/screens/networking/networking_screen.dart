import "package:flutter/material.dart";

import "../../models/match_card.dart";
import "../../services/networking_service.dart";
import "../../widgets/networking/networking_match_card.dart";
import "../../widgets/networking/networking_summary_card.dart";

class NetworkingScreen extends StatefulWidget {
  final String eventId;

  const NetworkingScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<NetworkingScreen> createState() =>
      _NetworkingScreenState();
}

class _NetworkingScreenState
    extends State<NetworkingScreen> {
  late Future<List<MatchCard>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = NetworkingService().getMatches(
      eventId: widget.eventId,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _load();
    });

    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title: const Text(
          "AI Networking",
        ),
      ),
      body: FutureBuilder<List<MatchCard>>(
        future: _future,
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(0xFFD4AF37),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  30,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color:
                          Colors.redAccent,
                      size: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Unable to load networking recommendations.",
                      textAlign:
                          TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _load();
                        });
                      },
                      child:
                          const Text(
                        "Retry",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final matches =
              snapshot.data ?? [];

          final highest =
              matches.isEmpty
                  ? 0
                  : matches
                      .first
                      .score;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              children: [
                const Text(
                  "Meet the Right People",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "AI recommends attendees you should meet based on profession, industry, skills and networking goals.",
                  style: TextStyle(
                    color:
                        Colors.grey,
                    height: 1.6,
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                NetworkingSummaryCard(
                  totalMatches:
                      matches.length,
                  highestScore:
                      highest,
                ),

                const SizedBox(
                  height: 30,
                ),

                if (matches.isEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.only(
                      top: 100,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.groups,
                          size: 90,
                          color:
                              Colors.grey,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No networking recommendations available yet.",
                          textAlign:
                              TextAlign
                                  .center,
                          style:
                              TextStyle(
                            color: Colors
                                .grey,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...matches.map(
                    (match) =>
                        NetworkingMatchCard(
                      match: match,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}