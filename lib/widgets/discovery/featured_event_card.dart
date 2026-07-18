import "package:flutter/material.dart";

import "../../models/event.dart";

class FeaturedEventCard extends StatelessWidget {
  final Event event;

  final VoidCallback onTap;

  const FeaturedEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        height: 260,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(
            30,
          ),
          image: DecorationImage(
            image: NetworkImage(
              event.coverImage ??
                  event.featuredImage ??
                  "https://images.unsplash.com/photo-1511578314322-379afb476865?w=1200",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              30,
            ),
            gradient:
                const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
          ),
          padding:
              const EdgeInsets.all(
            24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFD4AF37,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    50,
                  ),
                ),
                child: const Text(
                  "FEATURED",
                  style: TextStyle(
                    color:
                        Colors.black,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing:
                        1.4,
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Text(
                event.title,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color:
                        Color(
                      0xFFD4AF37,
                    ),
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
                        color:
                            Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: onTap,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFFD4AF37,
                      ),
                      foregroundColor:
                          Colors.black,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          50,
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            28,
                        vertical:
                            14,
                      ),
                    ),
                    child: const Text(
                      "Explore Event",
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.arrow_forward,
                    color:
                        Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}