import "package:flutter/material.dart";

import "../../models/event.dart";
import "package:attendee_app/theme/app_colors.dart";

class TicketCard
    extends StatelessWidget {
  final List<TicketType>
      tickets;

  final String currency;

  final TicketType?
      selectedTicket;

  final int quantity;

  final ValueChanged<TicketType>
      onTicketSelected;

  final ValueChanged<int>
      onQuantityChanged;

  const TicketCard({
    super.key,
    required this.tickets,
    required this.currency,
    required this.selectedTicket,
    required this.quantity,
    required this.onTicketSelected,
    required this.onQuantityChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final activeTickets =
        tickets
            .where(
              (ticket) =>
                  ticket.isActive,
            )
            .toList();

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 24,
      ),
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
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          /*
          |--------------------------------------------------------------------------
          | Header
          |--------------------------------------------------------------------------
          */

          const Row(
            children: [
              Icon(
                Icons
                    .confirmation_number_outlined,
                color: AppColors.primary,
                size: 36,
              ),

              SizedBox(
                width: 16,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      "Tickets",
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize:
                            20,
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Text(
                      "Choose your ticket",
                      style:
                          TextStyle(
                        color:
                            Colors
                                .grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 22,
          ),

          /*
          |--------------------------------------------------------------------------
          | Empty
          |--------------------------------------------------------------------------
          */

          if (activeTickets
              .isEmpty)
            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets
                      .all(
                18,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.white
                        .withValues(
                  alpha:
                      0.04,
                ),
                borderRadius:
                    BorderRadius
                        .circular(
                  16,
                ),
              ),
              child:
                  const Text(
                "Tickets are not available for this event yet.",
                style:
                    TextStyle(
                  color:
                      Colors.grey,
                ),
              ),
            ),

          /*
          |--------------------------------------------------------------------------
          | Tickets
          |--------------------------------------------------------------------------
          */

          ...activeTickets.map(
            (ticket) {
              final selected =
                  selectedTicket
                          ?.id ==
                      ticket.id;

              return Padding(
                padding:
                    const EdgeInsets
                        .only(
                  bottom: 12,
                ),
                child:
                    _TicketOption(
                  ticket:
                      ticket,
                  currency:
                      currency,
                  selected:
                      selected,
                  onTap:
                      ticket.soldOut
                          ? null
                          : () {
                              onTicketSelected(
                                ticket,
                              );
                            },
                ),
              );
            },
          ),

          /*
          |--------------------------------------------------------------------------
          | Quantity
          |--------------------------------------------------------------------------
          */

          if (selectedTicket !=
                  null &&
              selectedTicket!
                  .available) ...[
            const SizedBox(
              height: 12,
            ),

            const Divider(
              color: AppColors.border,
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      "Quantity",
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize:
                            16,
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Text(
                      "Number of tickets",
                      style:
                          TextStyle(
                        color:
                            Colors
                                .grey,
                        fontSize:
                            13,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    _QuantityButton(
                      icon:
                          Icons.remove,
                      enabled:
                          quantity >
                              1,
                      onPressed:
                          () {
                        if (quantity >
                            1) {
                          onQuantityChanged(
                            quantity -
                                1,
                          );
                        }
                      },
                    ),

                    SizedBox(
                      width: 48,
                      child:
                          Text(
                        "$quantity",
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            const TextStyle(
                          fontSize:
                              18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),

                    _QuantityButton(
                      icon:
                          Icons.add,
                      enabled:
                          quantity <
                              selectedTicket!
                                  .remaining,
                      onPressed:
                          () {
                        if (quantity <
                            selectedTicket!
                                .remaining) {
                          onQuantityChanged(
                            quantity +
                                1,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            /*
            |--------------------------------------------------------------------------
            | Total
            |--------------------------------------------------------------------------
            */

            Container(
              padding:
                  const EdgeInsets
                      .all(
                18,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.white
                        .withValues(
                  alpha:
                      0.04,
                ),
                borderRadius:
                    BorderRadius
                        .circular(
                  16,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style:
                        TextStyle(
                      color:
                          Colors.grey,
                    ),
                  ),

                  Text(
                    selectedTicket!
                            .isFree
                        ? "Free"
                        : "$currency ${_formatPrice(
                            selectedTicket!
                                    .price *
                                quantity,
                          )}",
                    style:
                        const TextStyle(
                      color: AppColors.primary,
                      fontSize:
                          20,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatPrice(
    double value,
  ) {
    if (
      value ==
      value.truncateToDouble()
    ) {
      return value
          .toStringAsFixed(
        0,
      );
    }

    return value.toStringAsFixed(
      2,
    );
  }
}

/*
|--------------------------------------------------------------------------
| Ticket Option
|--------------------------------------------------------------------------
*/

class _TicketOption
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color:
          Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds:
                200,
          ),
          padding:
              const EdgeInsets.all(
            18,
          ),
          decoration:
              BoxDecoration(
            color:
                selected
                    ? AppColors.primary.withValues(
                        alpha:
                            0.08,
                      )
                    : AppColors.card,
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
            border:
                Border.all(
              color:
                  selected
                      ? AppColors.primary
                      : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape
                          .circle,
                  border:
                      Border.all(
                    width: 2,
                    color:
                        selected
    ? AppColors.primary
                            : Colors
                                .grey,
                  ),
                ),
                child:
                    selected
                        ? const Center(
                            child:
                                CircleAvatar(
                              radius:
                                  5,
                             backgroundColor: AppColors.primary,
                            ),
                          )
                        : null,
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      ticket.name,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize:
                            16,
                      ),
                    ),

                    if (ticket
                            .description !=
                        null) ...[
                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        ticket
                            .description!,
                        style:
                            const TextStyle(
                          color:
                              Colors
                                  .grey,
                          fontSize:
                              13,
                        ),
                      ),
                    ],

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      ticket.soldOut
                          ? "Sold out"
                          : "${ticket.remaining} remaining",
                      style:
                          TextStyle(
                        color:
                            ticket
                                    .soldOut
                                ? Colors
                                    .redAccent
                                : Colors
                                    .grey,
                        fontSize:
                            12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Text(
                ticket.isFree
                    ? "Free"
                    : "$currency ${TicketCard._formatPrice(
                        ticket
                            .price,
                      )}",
                style:
                    TextStyle(
                  color:
                      ticket.soldOut
                          ? Colors
                              .grey
                          : AppColors.primary,
                  fontSize:
                      17,
                  fontWeight:
                      FontWeight
                          .bold,
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

class _QuantityButton
    extends StatelessWidget {
  final IconData icon;

  final bool enabled;

  final VoidCallback
      onPressed;

  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return IconButton(
      onPressed:
          enabled
              ? onPressed
              : null,
      icon:
          Icon(
        icon,
      ),
     style: IconButton.styleFrom(
  backgroundColor: AppColors.primary,
  foregroundColor: Colors.white,
  disabledForegroundColor: AppColors.textSecondary,
),
    );
  }
}