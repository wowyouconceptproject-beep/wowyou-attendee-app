import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../models/purchased_ticket.dart";

class MyEventCard extends StatelessWidget {
  final PurchasedTicket ticket;

  final VoidCallback onOpen;

  const MyEventCard({
    super.key,
    required this.ticket,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0xFF181818,
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
              ticket.coverImage,
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
                  ticket.eventTitle,
                  style:
                      const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
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
                  child: Text(
                    ticket.ticketName,
                    style:
                        const TextStyle(
                      color:
                          Colors.black,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(
                        0xFFD4AF37,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        ticket.venue,
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
                  height: 10,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Color(
                        0xFFD4AF37,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      DateFormat(
                        "EEE, d MMM yyyy",
                      ).format(
                        ticket.startDate,
                      ),
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton(
                    onPressed:
                        onOpen,
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
                      "Open Event",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}