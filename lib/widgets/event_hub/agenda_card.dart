import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../models/purchased_ticket.dart";

class AgendaCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const AgendaCard({
    super.key,
    required this.ticket,
  });

  Widget agendaItem({
    required String time,
    required String title,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            padding:
                const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0xFFD4AF37,
              ).withValues(alpha: .15),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(
                  0xFFD4AF37,
                ),
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color:
                          Colors.grey,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Text(
                      location,
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration: BoxDecoration(
        color:
            const Color(
          0xFF181818,
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.schedule,
                color:
                    Color(
                  0xFFD4AF37,
                ),
              ),

              SizedBox(
                width: 12,
              ),

              Text(
                "Agenda",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            DateFormat(
              "EEEE, d MMMM yyyy",
            ).format(
              ticket.startDate,
            ),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          // Temporary preview until sessions API is connected.

          agendaItem(
            time: "09:00",
            title:
                "Registration & Check-in",
            location:
                ticket.venue,
          ),

          agendaItem(
            time: "10:00",
            title:
                "Opening Session",
            location:
                "Main Stage",
          ),

          agendaItem(
            time: "11:30",
            title:
                "Networking Break",
            location:
                "Networking Lounge",
          ),

          const SizedBox(
            height: 12,
          ),

          SizedBox(
            width:
                double.infinity,
            child:
                OutlinedButton.icon(
              onPressed: () {
                // TODO:
                // Navigate to full agenda
              },
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(
                  0xFFD4AF37,
                ),
                side:
                    const BorderSide(
                  color: Color(
                    0xFFD4AF37,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.calendar_month,
              ),
              label: const Text(
                "View Full Schedule",
              ),
            ),
          ),
        ],
      ),
    );
  }
}