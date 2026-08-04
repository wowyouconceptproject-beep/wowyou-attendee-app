import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";
import "../theme/app_colors.dart";

import "../models/event.dart";
import "../providers/auth_provider.dart";
import "../services/event_service.dart";
import "../services/purchase_service.dart";

import "login_screen.dart";

import "../widgets/event_details/event_hero.dart";
import "../widgets/event_details/event_info_card.dart";
import "../widgets/event_details/event_about.dart";
import "../widgets/event_details/ticket_card.dart";
import "../widgets/event_details/register_button.dart";

class EventDetailsScreen
    extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen>
      createState() =>
          _EventDetailsScreenState();
}

class _EventDetailsScreenState
    extends State<EventDetailsScreen> {
  final EventService _eventService =
      EventService();

  final PurchaseService
      _purchaseService =
      PurchaseService();

  late Event event;

  TicketType? selectedTicket;

  int quantity = 1;

  bool loadingEvent = true;

  bool purchasing = false;

  String? loadError;

  @override
  void initState() {
    super.initState();

    /*
    |--------------------------------------------------------------------------
    | Immediate Event
    |--------------------------------------------------------------------------
    |
    | Allows the screen to render immediately while the authoritative event
    | is fetched.
    |
    */

    event = widget.event;

    _selectFirstTicket();

    _loadEvent();
  }

  /*
  |--------------------------------------------------------------------------
  | Authoritative Event
  |--------------------------------------------------------------------------
  */

  Future<void> _loadEvent() async {
    if (mounted) {
      setState(() {
        loadingEvent = true;
        loadError = null;
      });
    }

    final result =
        await _eventService
            .getPublicEvent(
      widget.event.id,
    );

    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() {
        loadingEvent = false;

        loadError =
            "Unable to load the latest event information.";
      });

      return;
    }

    setState(() {
      event = result;

      loadingEvent = false;

      loadError = null;

      /*
      |--------------------------------------------------------------------------
      | Reset Selection
      |--------------------------------------------------------------------------
      */

      selectedTicket = null;

      quantity = 1;

      _selectFirstTicket();
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Ticket Selection
  |--------------------------------------------------------------------------
  */

  void _selectFirstTicket() {
    for (final ticket
        in event.tickets) {
      if (ticket.available) {
        selectedTicket =
            ticket;

        return;
      }
    }

    selectedTicket = null;
  }

  /*
  |--------------------------------------------------------------------------
  | Purchase
  |--------------------------------------------------------------------------
  */

  Future<void>
      _purchaseTicket() async {
    if (purchasing) {
      return;
    }

    /*
    |--------------------------------------------------------------------------
    | Authentication
    |--------------------------------------------------------------------------
    */

    final auth =
        context.read<
            AuthProvider>();

    if (!auth.isAuthenticated) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
      );

      if (!mounted) {
        return;
      }

      if (!context
          .read<AuthProvider>()
          .isAuthenticated) {
        return;
      }
    }

    /*
    |--------------------------------------------------------------------------
    | Selected Ticket
    |--------------------------------------------------------------------------
    */

    final ticket =
        selectedTicket;

    if (ticket == null) {
      _showMessage(
        "Select a ticket to continue.",
      );

      return;
    }

    if (!ticket.available) {
      _showMessage(
        "This ticket is no longer available.",
      );

      await _loadEvent();

      return;
    }

    if (quantity < 1) {
      _showMessage(
        "Select at least one ticket.",
      );

      return;
    }

    if (quantity >
        ticket.remaining) {
      _showMessage(
        "Only ${ticket.remaining} ticket${ticket.remaining == 1 ? "" : "s"} remaining.",
      );

      await _loadEvent();

      return;
    }

    setState(() {
      purchasing = true;
    });

    try {
      /*
      |--------------------------------------------------------------------------
      | Create Purchase
      |--------------------------------------------------------------------------
      */

      final result =
          await _purchaseService
              .createPurchase(
        ticketTypeId:
            ticket.id,
        quantity:
            quantity,
      );

      if (!mounted) {
        return;
      }

      if (!result.success) {
        _showMessage(
          result.message ??
              "Unable to create purchase.",
        );

        /*
        |--------------------------------------------------------------------------
        | Inventory Could Have Changed
        |--------------------------------------------------------------------------
        */

        await _loadEvent();

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Free Ticket
      |--------------------------------------------------------------------------
      */

      if (!result
          .paymentRequired) {
        await _showFreeTicketSuccess();

        /*
        |--------------------------------------------------------------------------
        | Refresh Sold Count
        |--------------------------------------------------------------------------
        */

        await _loadEvent();

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Revolut Checkout
      |--------------------------------------------------------------------------
      */

      final checkoutUrl =
          result.checkoutUrl;

      if (checkoutUrl == null ||
          checkoutUrl.isEmpty) {
        _showMessage(
          "Payment checkout is unavailable.",
        );

        return;
      }

      final uri =
          Uri.tryParse(
        checkoutUrl,
      );

      if (uri == null) {
        _showMessage(
          "Invalid payment checkout URL.",
        );

        return;
      }

      final opened =
          await launchUrl(
        uri,
        mode:
            LaunchMode
                .externalApplication,
      );

      if (!mounted) {
        return;
      }

      if (!opened) {
        _showMessage(
          "Unable to open payment checkout.",
        );

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Important
      |--------------------------------------------------------------------------
      |
      | We DO NOT mark the purchase paid here.
      |
      | Revolut webhook remains the authority for payment confirmation.
      |
      */
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        "Unable to continue with ticket purchase.",
      );
    } finally {
      if (mounted) {
        setState(() {
          purchasing = false;
        });
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Free Ticket
  |--------------------------------------------------------------------------
  */

  Future<void>
      _showFreeTicketSuccess() async {
    await showDialog<void>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title:
              const Text(
            "Ticket acquired",
          ),
          content:
              const Text(
            "Your ticket is ready. You can access it from My Tickets and My Events.",
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                "Done",
              ),
            ),
          ],
        );
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Message
  |--------------------------------------------------------------------------
  */

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(
          message,
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
Widget build(
  BuildContext context,
) {
  return Scaffold(
    backgroundColor:
        AppColors.background,
    body: RefreshIndicator(
      color: AppColors.primary,
      backgroundColor:
          AppColors.card,
      onRefresh:
          _loadEvent,
      child:
          CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        slivers: [
          /*
          |--------------------------------------------------------------------------
          | Event
          |--------------------------------------------------------------------------
          */

          SliverToBoxAdapter(
            child:
                EventHero(
              event:
                  event,
            ),
          ),

          if (loadingEvent)
            const SliverToBoxAdapter(
              child:
                  LinearProgressIndicator(),
            ),

          const SliverToBoxAdapter(
            child:
                SizedBox(
              height:
                  28,
            ),
          ),

          SliverToBoxAdapter(
            child:
                EventInfoCard(
              event:
                  event,
            ),
          ),

          const SliverToBoxAdapter(
            child:
                SizedBox(
              height:
                  32,
            ),
          ),

          SliverToBoxAdapter(
            child:
                EventAbout(
              description:
                  event
                      .description,
            ),
          ),

          const SliverToBoxAdapter(
            child:
                SizedBox(
              height:
                  32,
            ),
          ),

          /*
          |--------------------------------------------------------------------------
          | Loading Error
          |--------------------------------------------------------------------------
          */

          if (loadError !=
              null)
            SliverToBoxAdapter(
              child:
                  Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      24,
                ),
                child:
                    Container(
                  padding:
                      const EdgeInsets.all(
                    18,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.card,
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    border: Border.all(
                      color:
                          AppColors.border,
                    ),
                  ),
                  child:
                      Column(
                    children: [
                      Text(
                        loadError!,
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          color:
                              AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height:
                            12,
                      ),

                      TextButton(
                        onPressed:
                            _loadEvent,
                        child:
                            const Text(
                          "Retry",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          /*
          |--------------------------------------------------------------------------
          | Tickets
          |--------------------------------------------------------------------------
          */

                    if (!loadingEvent && loadError == null)
            SliverToBoxAdapter(
              child: TicketCard(
                tickets: event.tickets,
                currency: event.currency,
                selectedTicket: selectedTicket,
                quantity: quantity,
                onTicketSelected: (ticket) {
                  setState(() {
                    selectedTicket = ticket;
                    quantity = 1;
                  });
                },
                onQuantityChanged: (value) {
                  setState(() {
                    quantity = value;
                  });
                },
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
            ),
          ),

          /*
          |--------------------------------------------------------------------------
          | Checkout
          |--------------------------------------------------------------------------
          */

          if (!loadingEvent &&
              loadError == null &&
              selectedTicket != null)
            SliverToBoxAdapter(
              child: RegisterButton(
                loading: purchasing,
                onPressed: _purchaseTicket,
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
            ),
          ),
        ],
      ),
    ),
  );
}
}