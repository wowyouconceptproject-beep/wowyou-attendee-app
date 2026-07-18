import "package:flutter/material.dart";

import "../../models/event.dart";

class EventHorizontalCard extends StatelessWidget {
  final Event event;

  final VoidCallback onTap;

  const EventHorizontalCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(
          left: 24,
        ),
        decoration: BoxDecoration(
          color: const Color(
            0xFF161616,
          ),
          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
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
                18,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .bold,
                      color:
                          Colors.white,
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
                        size: 16,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Expanded(
                        child: Text(
                          event.venue,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            color: Colors
                                .grey,
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
                    height: 16,
                  ),

                  Row(
                    children: [
                      const Text(
                        "Explore",
                        style: TextStyle(
                          color: Color(
                            0xFFD4AF37,
                          ),
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons
                            .arrow_forward,
                        color: Color(
                          0xFFD4AF37,
                        ),
                      ),
                    ],
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