import "package:flutter/material.dart";

import "../../models/event.dart";
import "event_horizontal_card.dart";
import "section_title.dart";

class TrendingSection
    extends StatelessWidget {
  final List<Event> events;

  final Function(Event) onTap;

  const TrendingSection({
    super.key,
    required this.events,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Trending",
          subtitle:
              "Popular events this week",
        ),

        const SizedBox(
          height: 18,
        ),

        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection:
                Axis.horizontal,
            itemCount:
                events.length,
            itemBuilder:
                (_, index) =>
                    EventHorizontalCard(
              event:
                  events[index],
              onTap: () =>
                  onTap(
                events[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}