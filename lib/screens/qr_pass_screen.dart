import "dart:async";

import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:wakelock_plus/wakelock_plus.dart";

import "../models/purchased_ticket.dart";
import "../services/pass_service.dart";

class QrPassScreen extends StatefulWidget {
  final PurchasedTicket ticket;

  const QrPassScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<QrPassScreen> createState() =>
      _QrPassScreenState();
}

class _QrPassScreenState
    extends State<QrPassScreen> {
  final PassService _passService =
      PassService();

  Timer? _countdownTimer;
  Timer? _refreshTimer;

  int secondsRemaining = 60;

  bool loading = true;

  String qrToken = "";

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    _loadSecurePass();

    _countdownTimer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (_) {
        if (!mounted) return;

        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        }
      },
    );

    _refreshTimer = Timer.periodic(
      const Duration(
        seconds: 60,
      ),
      (_) {
        _loadSecurePass();
      },
    );
  }

  Future<void> _loadSecurePass() async {
  if (loading) return;

  setState(() {
    loading = true;
  });

  try {
    final token =
        await _passService
            .generateSecurePass(
      widget.ticket.id,
    );

    if (!mounted) return;

    setState(() {
      qrToken = token;
      secondsRemaining = 60;
      loading = false;
    });
  } catch (_) {
    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }
}

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _refreshTimer?.cancel();

    WakelockPlus.disable();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          "Secure Event Pass",
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              const Text(
                "EVENT PASS",
                style: TextStyle(
                  color: Color(
                    0xFFD4AF37,
                  ),
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              Text(
                widget.ticket.attendeeName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (widget
                          .ticket
                          .profession !=
                      null ||
                  widget.ticket.company !=
                      null)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 6,
                  ),
                  child: Text(
                    [
                      widget.ticket
                          .profession,
                      widget.ticket
                          .company,
                    ]
                        .whereType<String>()
                        .join(" • "),
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ),

              const SizedBox(
                height: 24,
              ),

              Text(
                widget.ticket.eventTitle,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
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
                    30,
                  ),
                ),
                child: Text(
                  widget.ticket
                      .ticketName
                      .toUpperCase(),
                  style:
                      const TextStyle(
                    color:
                        Colors.black,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration:
                    BoxDecoration(
                  color: widget
                          .ticket
                          .checkedIn
                      ? Colors
                          .green
                          .shade700
                      : const Color(
                          0xFFD4AF37,
                        ),
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),
                child: Text(
                  widget.ticket.checkedIn
                      ? "CHECKED IN"
                      : "READY FOR ENTRY",
                  style:
                      TextStyle(
                    color: widget
                            .ticket
                            .checkedIn
                        ? Colors.white
                        : Colors.black,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              loading
                  ? const Padding(
                      padding:
                          EdgeInsets.all(
                        40,
                      ),
                      child:
                          CircularProgressIndicator(
                        color:
                            Color(
                          0xFFD4AF37,
                        ),
                      ),
                    )
                  : Container(
                      padding:
                          const EdgeInsets.all(
                        18,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                        border:
                            Border.all(
                          color:
                              const Color(
                            0xFFD4AF37,
                          ),
                          width: 3,
                        ),
                      ),
                      child:
                          QrImageView(
                        data:
                            qrToken,
                        version:
                            QrVersions
                                .auto,
                        size:
                            280,
                      ),
                    ),

              const SizedBox(
                height: 30,
              ),

              const Text(
                "Refreshing Secure Pass",
                style: TextStyle(
                  color:
                      Colors.white70,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                "${secondsRemaining}s",
                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFFD4AF37,
                  ),
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  const Icon(
                    Icons
                        .location_on_outlined,
                    color:
                        Colors.white70,
                    size: 18,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Text(
                    widget.ticket.venue,
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                "${widget.ticket.startDate.day}/${widget.ticket.startDate.month}/${widget.ticket.startDate.year}",
                style:
                    const TextStyle(
                  color:
                      Colors.white54,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width:
                    double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed: loading
                      ? null
                      : _loadSecurePass,
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(
                      0xFFD4AF37,
                    ),
                    side:
                        const BorderSide(
                      color:
                          Color(
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
                        16,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.refresh,
                  ),
                  label: const Text(
                    "Refresh Pass",
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              const Text(
                "Present this QR code only to an official WowYou event scanner.\nYour secure pass refreshes every 60 seconds.",
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      Colors.white54,
                  height: 1.5,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              const Text(
                "Powered by WowYou Event Technology",
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      Colors.white24,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}