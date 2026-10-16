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
import "../widgets/event_details/event_location_map.dart";

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() =>
      _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventService _eventService = EventService();

  final PurchaseService _purchaseService = PurchaseService();

  late Event event;

  TicketType? selectedTicket;

  PurchaseQuote? purchaseQuote;

  int quantity = 1;

  int _quoteRequestId = 0;

  bool loadingEvent = true;
  bool loadingQuote = false;
  bool purchasing = false;

  String? loadError;
  String? quoteError;

  @override
  void initState() {
    super.initState();

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

    try {
      final result = await _eventService.getPublicEvent(
        widget.event.id,
      );

      if (!mounted) return;

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

        selectedTicket = null;
        quantity = 1;

        _selectFirstTicket();
      });

      await _refreshPurchaseQuote();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingEvent = false;
        loadError =
            "Unable to load the latest event information.";
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Ticket Selection
  |--------------------------------------------------------------------------
  */

  void _selectFirstTicket() {
    for (final ticket in event.tickets) {
      if (ticket.available) {
        selectedTicket = ticket;
        return;
      }
    }

    selectedTicket = null;
  }

  void _onTicketSelected(TicketType ticket) {
    setState(() {
      selectedTicket = ticket;
      quantity = 1;

      purchaseQuote = null;
      quoteError = null;
    });

    _refreshPurchaseQuote();
  }

  void _onQuantityChanged(int value) {
    if (value < 1) return;

    setState(() {
      quantity = value;

      purchaseQuote = null;
      quoteError = null;
    });

    _refreshPurchaseQuote();
  }

  /*
  |--------------------------------------------------------------------------
  | Purchase Quote
  |--------------------------------------------------------------------------
  |
  | Retrieves the checkout subtotal, transaction fee and final amount
  | from the backend.
  |
  | The backend remains authoritative for all monetary calculations.
  |
  */

  Future<void> _refreshPurchaseQuote() async {
    final ticket = selectedTicket;

    final requestId = ++_quoteRequestId;

    if (ticket == null) {
      setState(() {
        purchaseQuote = null;
        loadingQuote = false;
        quoteError = null;
      });

      return;
    }

    // Free tickets do not attract transaction fees.
    if (ticket.isFree) {
      setState(() {
        purchaseQuote = null;
        loadingQuote = false;
        quoteError = null;
      });

      return;
    }

    // Quotes require an authenticated attendee.
    final auth = context.read<AuthProvider>();

    if (!auth.isAuthenticated) {
      setState(() {
        purchaseQuote = null;
        loadingQuote = false;
        quoteError =
            "Sign in to calculate your checkout total.";
      });

      return;
    }

    setState(() {
      loadingQuote = true;
      purchaseQuote = null;
      quoteError = null;
    });

    try {
      final quote = await _purchaseService.getPurchaseQuote(
        ticketTypeId: ticket.id,
        quantity: quantity,
      );

      if (!mounted || requestId != _quoteRequestId) {
        return;
      }

      setState(() {
        purchaseQuote = quote;
        loadingQuote = false;
        quoteError = null;
      });
    } catch (e) {
      if (!mounted || requestId != _quoteRequestId) {
        return;
      }

      setState(() {
        purchaseQuote = null;
        loadingQuote = false;
        quoteError =
            "Unable to calculate the transaction fee. Please retry.";
      });

      debugPrint("PURCHASE QUOTE ERROR: $e");
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Checkout Summary
  |--------------------------------------------------------------------------
  */

  String _formatPrice(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String _formatMoney(
    String currency,
    double amount,
  ) {
    return "$currency ${_formatPrice(amount)}";
  }

  Widget _summaryRow({
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasize
                    ? Colors.white
                    : AppColors.textSecondary,
                fontSize: emphasize ? 15 : 14,
                fontWeight:
                    emphasize ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: emphasize
                  ? AppColors.primary
                  : Colors.white,
              fontSize: emphasize ? 19 : 14,
              fontWeight:
                  emphasize ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary() {
    final ticket = selectedTicket;

    if (ticket == null) {
      return const SizedBox.shrink();
    }

    final subtotal = ticket.price * quantity;

    final currency = event.currency;

    final quoteMatchesSelection =
        purchaseQuote != null &&
        purchaseQuote!.ticketTypeId == ticket.id &&
        purchaseQuote!.quantity == quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
                size: 25,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Checkout summary",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            ticket.name,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "$quantity ${quantity == 1 ? "ticket" : "tickets"}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          const Divider(
            color: AppColors.border,
          ),

          _summaryRow(
            label: "Ticket subtotal",
            value: ticket.isFree
                ? "Free"
                : _formatMoney(currency, subtotal),
          ),

          if (ticket.isFree) ...[
            _summaryRow(
              label: "Transaction fee",
              value: _formatMoney(currency, 0),
            ),

            const Divider(
              color: AppColors.border,
            ),

            _summaryRow(
              label: "Total payable",
              value: "Free",
              emphasize: true,
            ),
          ] else if (loadingQuote) ...[
            const Divider(
              color: AppColors.border,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Calculating transaction fee...",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (quoteMatchesSelection) ...[
            _summaryRow(
              label: "Transaction fee",
              value: _formatMoney(
                purchaseQuote!.currency,
                purchaseQuote!.transactionFee,
              ),
            ),

            const Divider(
              color: AppColors.border,
            ),

            _summaryRow(
              label: "Total payable",
              value: _formatMoney(
                purchaseQuote!.currency,
                purchaseQuote!.amount,
              ),
              emphasize: true,
            ),
          ] else ...[
            const Divider(
              color: AppColors.border,
            ),

            Text(
              quoteError ??
                  "The final checkout total is not available yet.",
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed:
                    loadingQuote ? null : _refreshPurchaseQuote,
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                ),
                label: const Text("Retry calculation"),
              ),
            ),
          ],

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "The transaction fee is included in your checkout total. "
              "The backend confirms the final amount when your purchase "
              "is created.",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Purchase
  |--------------------------------------------------------------------------
  */

  Future<void> _purchaseTicket() async {
    if (purchasing) return;

    /*
    |--------------------------------------------------------------------------
    | Authentication
    |--------------------------------------------------------------------------
    */

    final auth = context.read<AuthProvider>();

    if (!auth.isAuthenticated) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );

      if (!mounted) return;

      if (!context.read<AuthProvider>().isAuthenticated) {
        return;
      }

      // Authentication may now be available, so fetch the quote.
      await _refreshPurchaseQuote();

      if (!mounted) return;
    }

    /*
    |--------------------------------------------------------------------------
    | Selected Ticket
    |--------------------------------------------------------------------------
    */

    final ticket = selectedTicket;

    if (ticket == null) {
      _showMessage("Select a ticket to continue.");
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
      _showMessage("Select at least one ticket.");
      return;
    }

    if (quantity > ticket.remaining) {
      _showMessage(
        "Only ${ticket.remaining} ticket"
        "${ticket.remaining == 1 ? "" : "s"} remaining.",
      );

      await _loadEvent();

      return;
    }

    /*
    |--------------------------------------------------------------------------
    | Require An Authoritative Quote For Paid Tickets
    |--------------------------------------------------------------------------
    */

    if (!ticket.isFree) {
      final quoteIsValid =
          purchaseQuote != null &&
          purchaseQuote!.ticketTypeId == ticket.id &&
          purchaseQuote!.quantity == quantity;

      if (!quoteIsValid) {
        if (!loadingQuote) {
          await _refreshPurchaseQuote();
        }

        if (!mounted) return;

        final refreshedQuoteIsValid =
            purchaseQuote != null &&
            purchaseQuote!.ticketTypeId == ticket.id &&
            purchaseQuote!.quantity == quantity;

        if (!refreshedQuoteIsValid) {
          _showMessage(
            "Unable to calculate your checkout total. Please retry.",
          );

          return;
        }
      }
    }

    setState(() {
      purchasing = true;
    });

    try {
      /*
      |--------------------------------------------------------------------------
      | Create Purchase
      |--------------------------------------------------------------------------
      |
      | The backend recalculates the fee and total. The quote displayed
      | in the app is informational and is not sent as a trusted amount.
      |
      */

      final result = await _purchaseService.createPurchase(
        ticketTypeId: ticket.id,
        quantity: quantity,
      );

      if (!mounted) return;

      if (!result.success) {
        _showMessage(
          result.message ??
              "Unable to create purchase.",
        );

        // Inventory or pricing may have changed.
        await _loadEvent();

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Free Ticket
      |--------------------------------------------------------------------------
      */

      if (!result.paymentRequired) {
        await _showFreeTicketSuccess();

        if (!mounted) return;

        await _loadEvent();

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | External Payment Checkout
      |--------------------------------------------------------------------------
      |
      | Open the checkout URL returned by the backend.
      | Do not mark the purchase as paid in this screen.
      | The payment webhook remains authoritative.
      |
      */

      final checkoutUrl = result.checkoutUrl;

      if (checkoutUrl == null || checkoutUrl.isEmpty) {
        _showMessage(
          "Payment checkout is unavailable.",
        );

        return;
      }

      final uri = Uri.tryParse(checkoutUrl);

      if (uri == null ||
          !uri.hasScheme ||
          (uri.scheme != "https" && uri.scheme != "http")) {
        _showMessage(
          "Invalid payment checkout URL.",
        );

        return;
      }

      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!mounted) return;

      if (!opened) {
        _showMessage(
          "Unable to open payment checkout.",
        );

        return;
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint("PURCHASE ERROR: $e");

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
  | Free Ticket Success
  |--------------------------------------------------------------------------
  */

  Future<void> _showFreeTicketSuccess() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Ticket acquired",
          ),
          content: const Text(
            "Your ticket is ready. You can access it from My Tickets and My Events.",
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Done"),
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

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
    final ticket = selectedTicket;

    final quoteMatchesSelection =
        ticket != null &&
        purchaseQuote != null &&
        purchaseQuote!.ticketTypeId == ticket.id &&
        purchaseQuote!.quantity == quantity;

    final checkoutBlocked =
        ticket != null &&
        !ticket.isFree &&
        (loadingQuote || !quoteMatchesSelection);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.card,
        onRefresh: _loadEvent,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            /*
            |--------------------------------------------------------------------------
            | Event Hero
            |--------------------------------------------------------------------------
            */

            SliverToBoxAdapter(
              child: EventHero(
                event: event,
              ),
            ),

            if (loadingEvent)
              const SliverToBoxAdapter(
                child: LinearProgressIndicator(),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            /*
            |--------------------------------------------------------------------------
            | Event Information
            |--------------------------------------------------------------------------
            */

            SliverToBoxAdapter(
              child: EventInfoCard(
                event: event,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),

            /*
            |--------------------------------------------------------------------------
            | Event Location
            |--------------------------------------------------------------------------
            */

            SliverToBoxAdapter(
              child: EventLocationMap(
                event: event,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),

            /*
            |--------------------------------------------------------------------------
            | Event Description
            |--------------------------------------------------------------------------
            */

            SliverToBoxAdapter(
              child: EventAbout(
                description: event.description,
              ),
            ),

            /*
            |--------------------------------------------------------------------------
            | Loading Error
            |--------------------------------------------------------------------------
            */

            if (loadError != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          loadError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _loadEvent,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            /*
            |--------------------------------------------------------------------------
            | Ticket Selection
            |--------------------------------------------------------------------------
            */

            if (!loadingEvent && loadError == null)
              SliverToBoxAdapter(
                child: TicketCard(
  tickets: event.tickets,
  currency: event.currency,
  selectedTicket: selectedTicket,
  quantity: quantity,
  onTicketSelected: _onTicketSelected,
  onQuantityChanged: _onQuantityChanged,
  purchaseQuote: purchaseQuote,
  loadingQuote: loadingQuote,
  quoteError: quoteError,
  onRetryQuote: _refreshPurchaseQuote,
),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            /*
            |--------------------------------------------------------------------------
            | Checkout Summary
            |--------------------------------------------------------------------------
            */

            if (!loadingEvent &&
                loadError == null &&
                selectedTicket != null)
              SliverToBoxAdapter(
                child: _buildCheckoutSummary(),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            /*
            |--------------------------------------------------------------------------
            | Register / Checkout Button
            |--------------------------------------------------------------------------
            */

            if (!loadingEvent &&
                loadError == null &&
                selectedTicket != null)
              SliverToBoxAdapter(
                child: RegisterButton(
                  loading: purchasing || checkoutBlocked,
                  onPressed: checkoutBlocked
                      ? null
                      : _purchaseTicket,
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}