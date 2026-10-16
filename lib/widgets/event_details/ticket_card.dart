import "package:flutter/material.dart";

import "../../models/event.dart";
import "package:attendee_app/theme/app_colors.dart";
import "../../services/purchase_service.dart";

class TicketCard extends StatelessWidget {
  final List<TicketType> tickets;
  final String currency;
  final TicketType? selectedTicket;
  final int quantity;

  final ValueChanged<TicketType> onTicketSelected;
  final ValueChanged<int> onQuantityChanged;

  /// Quote returned by POST /purchase/quote.
  ///
  /// The backend is authoritative for the transaction fee and final amount.
  final PurchaseQuote? purchaseQuote;

  /// True while the screen is fetching an updated quote.
  final bool loadingQuote;

  /// Error from fetching the latest quote, if any.
  final String? quoteError;

  /// Callback to retry fetching the quote.
  final VoidCallback? onRetryQuote;

  const TicketCard({
    super.key,
    required this.tickets,
    required this.currency,
    required this.selectedTicket,
    required this.quantity,
    required this.onTicketSelected,
    required this.onQuantityChanged,
    this.purchaseQuote,
    this.loadingQuote = false,
    this.quoteError,
    this.onRetryQuote,
  });

  @override
  Widget build(BuildContext context) {
    final activeTickets = tickets
        .where((ticket) => ticket.isActive)
        .toList();

    final ticket = selectedTicket;

    final quoteMatchesSelection = ticket != null &&
        purchaseQuote != null &&
        purchaseQuote!.ticketTypeId == ticket.id &&
        purchaseQuote!.quantity == quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                color: AppColors.primary,
                size: 36,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tickets",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Choose your ticket",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Empty state
          if (activeTickets.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Tickets are not available for this event yet.",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // Available tickets
          ...activeTickets.map((ticketOption) {
            final selected = ticket?.id == ticketOption.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TicketOption(
                ticket: ticketOption,
                currency: currency,
                selected: selected,
                onTap: ticketOption.soldOut
                    ? null
                    : () => onTicketSelected(ticketOption),
              ),
            );
          }),

          // Quantity controls and purchase summary
          if (ticket != null && ticket.available) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quantity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Number of tickets",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      enabled: quantity > 1,
                      onPressed: () {
                        if (quantity > 1) {
                          onQuantityChanged(quantity - 1);
                        }
                      },
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        "$quantity",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      enabled: quantity < ticket.remaining,
                      onPressed: () {
                        if (quantity < ticket.remaining) {
                          onQuantityChanged(quantity + 1);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Purchase summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: ticket.isFree
                  ? _buildFreeSummary()
                  : _buildPaidSummary(
                      ticket: ticket,
                      quoteMatchesSelection: quoteMatchesSelection,
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFreeSummary() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total payable",
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          "Free",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaidSummary({
    required TicketType ticket,
    required bool quoteMatchesSelection,
  }) {
    // Never present a locally calculated amount as the authoritative
    // purchase total. Wait for the matching backend quote.
    if (loadingQuote && !quoteMatchesSelection) {
      return const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Updating price and transaction fee...",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    if (quoteError != null && !quoteMatchesSelection) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Unable to load the current price breakdown.",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            quoteError!,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
            ),
          ),
          if (onRetryQuote != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onRetryQuote,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ),
          ],
        ],
      );
    }

    if (!quoteMatchesSelection) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Price breakdown",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "The final price and transaction fee will appear after the price quote loads.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      );
    }

    final quote = purchaseQuote!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price breakdown",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),

        _SummaryRow(
          label: "Ticket subtotal ($quantity)",
          value: _formatMoney(quote.currency, quote.subtotal),
        ),

        const SizedBox(height: 10),

        _SummaryRow(
          label: "Transaction fee",
          value: _formatMoney(quote.currency, quote.transactionFee),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Divider(color: AppColors.border),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "Total payable",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                _formatMoney(quote.currency, quote.amount),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        if (loadingQuote) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            minHeight: 2,
            color: AppColors.primary,
          ),
        ],
      ],
    );
  }

  static String _formatMoney(String currencyCode, double value) {
    return "$currencyCode ${_formatPrice(value)}";
  }

  static String _formatPrice(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/*
|--------------------------------------------------------------------------
| Ticket Option
|--------------------------------------------------------------------------
*/

class _TicketOption extends StatelessWidget {
  final TicketType ticket;
  final String currency;
  final bool selected;
  final VoidCallback? onTap;

  const _TicketOption({
    required this.ticket,
    required this.currency,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: selected
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
                child: selected
                    ? const Center(
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: AppColors.primary,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    if (ticket.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        ticket.description!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 6),

                    Text(
                      ticket.soldOut
                          ? "Sold out"
                          : "${ticket.remaining} remaining",
                      style: TextStyle(
                        color: ticket.soldOut
                            ? Colors.redAccent
                            : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Text(
                ticket.isFree
                    ? "Free"
                    : "$currency ${TicketCard._formatPrice(ticket.price)}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: ticket.soldOut
                      ? Colors.grey
                      : AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
|--------------------------------------------------------------------------
| Quantity Button
|--------------------------------------------------------------------------
*/

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledForegroundColor: AppColors.textSecondary,
      ),
    );
  }
}