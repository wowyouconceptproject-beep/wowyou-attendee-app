import "package:flutter/material.dart";

import "../../models/event.dart";

class EventVerticalCard
    extends StatelessWidget {
  final Event event;

  final VoidCallback onTap;

  const EventVerticalCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(
            0xFF161616,
          ),
          borderRadius:
              BorderRadius.circular(
            28,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                event.coverImage ??
                    event.featuredImage ??
                    "https://images.unsplash.com/photo-1511578314322-379afb476865?w=1200",
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(
                22,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    event.title,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(
                          0xFFD4AF37,
                        ),
                        size: 18,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Expanded(
                        child: Text(
                          event.venue,
                          style:
                              const TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
                    style:
                        const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        ElevatedButton(
                      onPressed:
                          onTap,
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
                          vertical:
                              16,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        "Explore Event",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}