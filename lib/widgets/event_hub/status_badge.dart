import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

class StatusBadge extends StatelessWidget {
  final PurchasedTicket ticket;

  const StatusBadge({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final bool checkedIn =
        ticket.checkedIn;

    final Color background =
        checkedIn
            ? const Color(
                0xFF0F3D2E,
              )
            : const Color(
                0xFF3B2F0B,
              );

    final Color border =
        checkedIn
            ? const Color(
                0xFF34D399,
              )
            : const Color(
                0xFFD4AF37,
              );

    final Color iconColor =
        checkedIn
            ? const Color(
                0xFF34D399,
              )
            : const Color(
                0xFFD4AF37,
              );

    final String title =
        checkedIn
            ? "Checked In"
            : "Ready for Entry";

    final String description =
        checkedIn
            ? "Your attendance has been recorded."
            : "Present your QR Pass at the entrance.";

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(
              color:
                  iconColor
                      .withOpacity(
                0.15,
              ),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Icon(
              checkedIn
                  ? Icons.verified
                  : Icons.qr_code_scanner,
              color: iconColor,
              size: 30,
            ),
          ),

          const SizedBox(
            width: 18,
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
                      TextStyle(
                    color:
                        iconColor,
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  description,
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    height: 1.4,
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