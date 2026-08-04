import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

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
          AppColors.background,

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
                    AppColors.primary,
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
                          AppColors.error,
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
            color: AppColors.primary,
            backgroundColor:
                AppColors.card,
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
                        AppColors.textSecondary,
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
                              AppColors.textSecondary,
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
                            color:
                                AppColors.textSecondary,
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