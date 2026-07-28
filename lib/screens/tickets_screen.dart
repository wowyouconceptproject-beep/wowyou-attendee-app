import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/purchased_ticket.dart";
import "../providers/auth_provider.dart";
import "../services/purchase_service.dart";

import "../widgets/auth/protected_feature_view.dart";

import "eventhubscreen.dart";
import "login_screen.dart";
import "register_screen.dart";

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({
    super.key,
  });

  @override
  State<TicketsScreen> createState() =>
      _TicketsScreenState();
}

class _TicketsScreenState
    extends State<TicketsScreen> {
  final PurchaseService _purchaseService =
      PurchaseService();

  List<PurchasedTicket> tickets = [];

  bool loading = true;

  String? error;

  bool _wasAuthenticated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      final auth =
          context.read<AuthProvider>();

      _wasAuthenticated =
          auth.isAuthenticated;

      if (auth.isAuthenticated) {
        loadTickets();
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Load Tickets
  |--------------------------------------------------------------------------
  */

  Future<void> loadTickets() async {
    if (!mounted) return;

    final auth =
        context.read<AuthProvider>();

    if (!auth.isAuthenticated) {
      setState(() {
        tickets = [];
        loading = false;
        error = null;
      });

      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final result =
          await _purchaseService
              .getMyTickets();

      if (!mounted) return;

      setState(() {
        tickets = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;

        error =
            "Unable to load your tickets.";
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Authentication Change
  |--------------------------------------------------------------------------
  |
  | IndexedStack keeps this screen alive.
  |
  | Therefore initState() does not run again after login/logout.
  | We detect the authentication transition here.
  |
  */

  void _handleAuthChange(
    bool isAuthenticated,
  ) {
    if (_wasAuthenticated ==
        isAuthenticated) {
      return;
    }

    _wasAuthenticated =
        isAuthenticated;

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      if (isAuthenticated) {
        loadTickets();
      } else {
        setState(() {
          tickets = [];
          loading = false;
          error = null;
        });
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Open Ticket / Event Hub
  |--------------------------------------------------------------------------
  */

  void _openTicket(
    PurchasedTicket ticket,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EventHubScreen(
          ticket: ticket,
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Build
  |--------------------------------------------------------------------------
  */

@override
Widget build(BuildContext context) {
  final auth = context.watch<AuthProvider>();

  _handleAuthChange(
    auth.isAuthenticated,
  );

  if (!auth.isAuthenticated) {
    return ProtectedFeatureView(
      icon: Icons.confirmation_number,
      title: "Your Tickets",
      description:
          "Sign in to access your tickets and event passes.",
      benefits: const [
        "View QR event passes",
        "Access your Event Hub",
        "View purchase history",
        "Receive event updates",
      ],
      onSignIn: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );

        if (!mounted) return;

        await loadTickets();
      },
      onCreateAccount: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RegisterScreen(),
          ),
        );

        if (!mounted) return;

        await loadTickets();
      },
    );
  }

  return Scaffold(
    backgroundColor: const Color(0xFF0B0B0B),
    appBar: AppBar(
      title: const Text("My Tickets"),
    ),
    body: _buildBody(),
  );
}

  /*
  |--------------------------------------------------------------------------
  | Body
  |--------------------------------------------------------------------------
  */

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return RefreshIndicator(
        onRefresh:
            loadTickets,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height:
                  MediaQuery.sizeOf(
                        context,
                      ).height *
                      .25,
            ),

            const Icon(
              Icons
                  .error_outline_rounded,
              size: 52,
              color:
                  Colors.grey,
            ),

            const SizedBox(
              height: 18,
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Text(
                error!,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color:
                      Colors.grey,
                  fontSize:
                      16,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Center(
              child:
                  FilledButton(
                onPressed:
                    loadTickets,
                child:
                    const Text(
                  "Try Again",
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (tickets.isEmpty) {
      return RefreshIndicator(
        onRefresh:
            loadTickets,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height:
                  MediaQuery.sizeOf(
                        context,
                      ).height *
                      .22,
            ),

            const Icon(
              Icons
                  .confirmation_number_outlined,
              size: 64,
              color:
                  Color(
                0xFFD4AF37,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            const Text(
              "No tickets yet",
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Text(
                "Tickets you've successfully acquired will appear here.",
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  color:
                      Colors.grey,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
          loadTickets,
      child: ListView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        itemCount:
            tickets.length,
        itemBuilder:
            (
          context,
          index,
        ) {
          final ticket =
              tickets[index];

          return _TicketCard(
            ticket: ticket,
            onTap: () =>
                _openTicket(
              ticket,
            ),
          );
        },
      ),
    );
  }
}

/*
|--------------------------------------------------------------------------
| Ticket Card
|--------------------------------------------------------------------------
*/

class _TicketCard
    extends StatelessWidget {
  final PurchasedTicket ticket;

  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final image =
        ticket.coverImage ??
        ticket.featuredImage;

    final eventDate =
        _formatDate(
      ticket.startDate,
    );

    final total =
        _formatAmount(
      ticket.amount,
      ticket.currency,
    );

    return Card(
      color:
          const Color(
        0xFF181818,
      ),
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),
      clipBehavior:
          Clip.antiAlias,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child: InkWell(
        onTap:
            onTap,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            /*
            |--------------------------------------------------------------------------
            | Event Image
            |--------------------------------------------------------------------------
            */

            if (image != null &&
                image.isNotEmpty)
              SizedBox(
                width:
                    double.infinity,
                height: 170,
                child:
                    Image.network(
                  image,
                  fit:
                      BoxFit.cover,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return _imagePlaceholder();
                  },
                ),
              )
            else
              _imagePlaceholder(),

            /*
            |--------------------------------------------------------------------------
            | Ticket Information
            |--------------------------------------------------------------------------
            */

            Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                            Text(
                          ticket
                              .eventTitle,
                          style:
                              const TextStyle(
                            fontSize:
                                20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              10,
                          vertical:
                              6,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFD4AF37,
                          ).withValues(
                            alpha:
                                .12,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child:
                            const Text(
                          "PAID",
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFFD4AF37,
                            ),
                            fontSize:
                                11,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    ticket.ticketName,
                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xFFD4AF37,
                      ),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _TicketInfoRow(
                    icon:
                        Icons
                            .calendar_today_outlined,
                    text:
                        eventDate,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  _TicketInfoRow(
                    icon:
                        Icons
                            .location_on_outlined,
                    text:
                        ticket.venue,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  _TicketInfoRow(
                    icon:
                        Icons
                            .confirmation_number_outlined,
                    text:
                        "${ticket.quantity} ticket${ticket.quantity == 1 ? "" : "s"}",
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  const Divider(
                    color:
                        Color(
                      0xFF2A2A2A,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total",
                            style:
                                TextStyle(
                              color:
                                  Colors.grey,
                              fontSize:
                                  12,
                            ),
                          ),

                          const SizedBox(
                            height: 3,
                          ),

                          Text(
                            total,
                            style:
                                const TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Text(
                            ticket.checkedIn
                                ? "Checked In"
                                : "Open Ticket",
                            style:
                                TextStyle(
                              color:
                                  ticket.checkedIn
                                      ? Colors.greenAccent
                                      : const Color(
                                          0xFFD4AF37,
                                        ),
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(
                            width: 6,
                          ),

                          const Icon(
                            Icons
                                .chevron_right,
                            color:
                                Color(
                              0xFFD4AF37,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Placeholder
  |--------------------------------------------------------------------------
  */

  static Widget
      _imagePlaceholder() {
    return Container(
      width:
          double.infinity,
      height: 170,
      color:
          const Color(
        0xFF202020,
      ),
      child:
          const Center(
        child:
            Icon(
          Icons.event,
          size: 52,
          color:
              Colors.grey,
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Date
  |--------------------------------------------------------------------------
  */

  static String _formatDate(
    DateTime date,
  ) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final local =
        date.toLocal();

    return "${months[local.month - 1]} ${local.day}, ${local.year}";
  }

  /*
  |--------------------------------------------------------------------------
  | Amount
  |--------------------------------------------------------------------------
  */

  static String _formatAmount(
    double amount,
    String currency,
  ) {
    if (amount <= 0) {
      return "Free";
    }

    final value =
        amount ==
                amount
                    .truncateToDouble()
            ? amount
                .toStringAsFixed(
                  0,
                )
            : amount
                .toStringAsFixed(
                  2,
                );

    return "$currency $value";
  }
}

/*
|--------------------------------------------------------------------------
| Ticket Information Row
|--------------------------------------------------------------------------
*/

class _TicketInfoRow
    extends StatelessWidget {
  final IconData icon;

  final String text;

  const _TicketInfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color:
              Colors.grey,
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child:
              Text(
            text,
            style:
                const TextStyle(
              color:
                  Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}