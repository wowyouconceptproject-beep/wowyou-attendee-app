import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../models/purchased_ticket.dart";
import "package:attendee_app/theme/app_colors.dart";

class EventBanner extends StatelessWidget {
  final PurchasedTicket ticket;

  const EventBanner({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 320,
          width: double.infinity,
          child: Image.network(
            ticket.coverImage ?? "",
            fit: BoxFit.cover,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                color: AppColors.card,
                child: const Center(
                  child: Icon(
                    Icons.image,
                    color: AppColors.textSecondary,
                    size: 80,
                  ),
                ),
              );
            },
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

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              24,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(
                      alpha: 0.8,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.text,
                    ),
                  ),
                ),
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
                ticket.eventTitle,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color:
                        AppColors.primary,
                    size: 20,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      ticket.venue,
                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color:
                        AppColors.primary,
                    size: 20,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      DateFormat(
                        "EEE, d MMM yyyy • h:mm a",
                      ).format(
                        ticket.startDate,
                      ),
                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}