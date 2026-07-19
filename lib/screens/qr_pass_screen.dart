import "package:flutter/material.dart";

import "../mixins/refresh_timer_mixin.dart";
import "../mixins/wakelock_mixin.dart";

import "../models/purchased_ticket.dart";
import "../services/pass_service.dart";

import "../widgets/pass/attendee_card.dart";
import "../widgets/pass/countdown_card.dart";
import "../widgets/pass/event_card.dart";
import "../widgets/pass/qr_code_card.dart";
import "../widgets/pass/refresh_button.dart";
import "../widgets/pass/status_badge.dart";

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
    extends State<QrPassScreen>
    with
        RefreshTimerMixin<QrPassScreen>,
        WakelockMixin {
  final PassService _passService =
      PassService();

  bool _loading = true;

  String _qrToken = "";

  PurchasedTicket get ticket =>
      widget.ticket;

  @override
  Duration get refreshDuration =>
      const Duration(seconds: 60);

  @override
  Future<void> onRefresh() async {
    await _loadSecurePass();
  }

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
  await enableWakeLock();

  await _loadSecurePass();

  startRefreshTimer();
}

Future<void> _loadSecurePass() async {
  if (mounted) {
    setState(() {
      _loading = true;
    });
  }

  try {
    final token = await _passService.securePass(
      ticket.id,
    );

    if (!mounted) return;

    setState(() {
      _qrToken = token;
      secondsRemaining =
          refreshDuration.inSeconds;
      _loading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          "Present this QR code only to an official WowYou event scanner.\nYour secure QR refreshes automatically every 60 seconds.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),
        SizedBox(height: 40),
        Text(
          "Powered by WowYou Event Technology",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white24,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Secure Event Pass",
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: [
              const Text(
                "EVENT PASS",
                style: TextStyle(
                  color: Color(
                    0xFFD4AF37,
                  ),
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              AttendeeCard(
                ticket: ticket,
              ),

              const SizedBox(
                height: 32,
              ),

              EventCard(
                ticket: ticket,
              ),

              const SizedBox(
                height: 30,
              ),

              StatusBadge(
                checkedIn:
                    ticket.checkedIn,
              ),

              const SizedBox(
                height: 30,
              ),

              QrCodeCard(
                loading: _loading,
                qrToken: _qrToken,
              ),

              const SizedBox(
                height: 30,
              ),

              CountdownCard(
  secondsRemaining: secondsRemaining,
),

              const SizedBox(
                height: 30,
              ),

              RefreshButton(
                loading: _loading,
                onPressed:
                    _loadSecurePass,
              ),

              const SizedBox(
                height: 32,
              ),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}