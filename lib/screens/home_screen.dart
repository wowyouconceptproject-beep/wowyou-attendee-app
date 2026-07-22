import "package:flutter/material.dart";

import "../models/event.dart";
import "../services/event_service.dart";

import "event_details_screen.dart";


import "../widgets/discovery/discovery_header.dart";
import "../widgets/discovery/featured_event_card.dart";
import "../widgets/discovery/trending_section.dart";
import "../widgets/discovery/category_strip.dart";
import "../widgets/discovery/event_vertical_card.dart";
import "../widgets/discovery/section_title.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final EventService
      _eventService =
          EventService();

  List<Event> events = [];

  bool loading = true;

  final categories = const [
    "Business",
    "Technology",
    "Music",
    "Sports",
    "Fashion",
    "Food",
  ];

  @override
  void initState() {
    super.initState();

    loadEvents();
  }

  Future<void> loadEvents() async {
    final result =
        await _eventService
            .getPublicEvents();

    if (!mounted) return;

    setState(() {
      events = result;
      loading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadEvents,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
  child: DiscoveryHeader(),
),

const SliverToBoxAdapter(
  child: SizedBox(
    height: 28,
  ),
),

            if (events.isNotEmpty)
              SliverToBoxAdapter(
                child:
                    FeaturedEventCard(
                  event: events.first,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EventDetailsScreen(
                          event:
                              events.first,
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 36,
              ),
            ),

            SliverToBoxAdapter(
              child: TrendingSection(
                events: events,
                onTap: (event) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EventDetailsScreen(
                        event: event,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 34,
              ),
            ),

            SliverToBoxAdapter(
              child: CategoryStrip(
                categories:
                    categories,
                onSelected:
                    (category) {
                  // TODO
                  // Backend category filtering
                },
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 34,
              ),
            ),

            const SliverToBoxAdapter(
              child: SectionTitle(
                title:
                    "Popular This Week",
                subtitle:
                    "Don't miss these experiences",
              ),
            ),

            SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (_, index) {
                  return EventVerticalCard(
                    event:
                        events[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EventDetailsScreen(
                            event:
                                events[index],
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount:
                    events.length,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}