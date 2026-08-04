import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../models/purchased_ticket.dart";
import "package:attendee_app/theme/app_colors.dart";

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
              color: AppColors.primary
                  .withValues(alpha: .15),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.primary,
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
                    color:
                        AppColors.text,
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
                      color: AppColors
                          .textSecondary,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Text(
                      location,
                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,
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
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color:
              AppColors.border,
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
                    AppColors.primary,
              ),

              SizedBox(
                width: 12,
              ),

              Text(
                "Agenda",
                style: TextStyle(
                  color:
                      AppColors.text,
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
            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
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
                    AppColors.primary,
                side:
                    const BorderSide(
                  color: AppColors
                      .primary,
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