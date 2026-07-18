import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../models/purchased_ticket.dart";

class PassInformation extends StatelessWidget {
  final PurchasedTicket ticket;

  const PassInformation({
    super.key,
    required this.ticket,
  });

  Widget infoTile(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0xFF222222,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(
                0xFFD4AF37,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.black,
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
                  label.toUpperCase(),
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                    fontSize: 11,
                    letterSpacing: 1.3,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String currencySymbol(
    String currency,
  ) {
    switch (currency) {
      case "USD":
        return "\$";

      case "EUR":
        return "€";

      case "GBP":
        return "£";

      case "NGN":
        return "₦";

      case "KES":
        return "KSh ";

      case "ZAR":
        return "R ";

      default:
        return currency;
    }
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
                Icons.badge,
                color: Color(
                  0xFFD4AF37,
                ),
              ),

              SizedBox(
                width: 12,
              ),

              Text(
                "Pass Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 28,
          ),

          infoTile(
            Icons.confirmation_number,
            "Ticket Type",
            ticket.ticketName,
          ),

          infoTile(
            Icons.event,
            "Event",
            ticket.eventTitle,
          ),

          infoTile(
            Icons.location_on,
            "Venue",
            ticket.venue,
          ),

          infoTile(
            Icons.calendar_today,
            "Date",
            DateFormat(
              "EEEE, d MMMM yyyy",
            ).format(
              ticket.startDate,
            ),
          ),

          infoTile(
            Icons.schedule,
            "Time",
            DateFormat(
              "h:mm a",
            ).format(
              ticket.startDate,
            ),
          ),

          infoTile(
            Icons.payments,
            "Amount Paid",
            "${currencySymbol(ticket.currency)}${ticket.amount.toStringAsFixed(2)}",
          ),

          infoTile(
            Icons.receipt_long,
            "Purchase ID",
            ticket.id,
          ),

          infoTile(
            Icons.verified_user,
            "Pass Status",
            ticket.checkedIn
                ? "Checked In"
                : "Valid",
          ),
        ],
      ),
    );
  }
}