import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";
import "package:attendee_app/theme/app_colors.dart";

class VenueCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const VenueCard({
    super.key,
    required this.ticket,
  });

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
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.map,
                color:
                    AppColors.primary,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "Venue",
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
            height: 18,
          ),

          Text(
            ticket.venue,
            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}