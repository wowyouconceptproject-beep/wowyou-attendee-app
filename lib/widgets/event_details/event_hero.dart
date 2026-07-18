import "package:flutter/material.dart";

import "../../models/event.dart";

class EventHero extends StatelessWidget {
  final Event event;

  const EventHero({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 320,
          width: double.infinity,
          child: Image.network(
            event.coverImage ??
                event.featuredImage ??
                "https://images.unsplash.com/photo-1511578314322-379afb476865?w=1200",
            fit: BoxFit.cover,
          ),
        ),

        Container(
          height: 320,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
          ),
        ),

        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(
                      0xFFD4AF37,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      event.venue,
                      style: const TextStyle(
                        color:
                            Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}