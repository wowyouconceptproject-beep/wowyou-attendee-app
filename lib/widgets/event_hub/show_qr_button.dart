import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";
import "../../screens/qr_pass_screen.dart";

class ShowQrButton extends StatelessWidget {
  final PurchasedTicket ticket;

  const ShowQrButton({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(
        24,
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                QrPassScreen(
              ticket: ticket,
            ),
          ),
        );
      },

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(
          24,
        ),

        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              Color(
                0xFF111111,
              ),
              Color(
                0xFF1D1D1D,
              ),
            ],
          ),

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          border: Border.all(
            color:
                const Color(
              0xFFD4AF37,
            ).withOpacity(
              .25,
            ),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFD4AF37,
                ),

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: const Icon(
                Icons.qr_code_2_rounded,
                color:
                    Colors.black,
                size: 42,
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    "EVENT PASS",
                    style:
                        TextStyle(
                      color:
                          Color(
                        0xFFD4AF37,
                      ),
                      letterSpacing:
                          2,
                      fontWeight:
                          FontWeight
                              .bold,
                      fontSize:
                          12,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    "Open Secure QR Pass",
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    ticket.checkedIn
                        ? "This ticket has already been scanned."
                        : "Present this QR code at the entrance for fast check-in.",
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

            const Icon(
              Icons.arrow_forward_ios,
              color:
                  Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}