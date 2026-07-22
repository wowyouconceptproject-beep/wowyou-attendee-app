import "package:flutter/material.dart";

import "../../models/activity.dart";
import "../../models/purchased_ticket.dart";
import "../../services/activity_service.dart";
import "../../services/socket_service.dart";

class ActivityPanel extends StatefulWidget {
  final PurchasedTicket ticket;

  const ActivityPanel({
    super.key,
    required this.ticket,
  });

  @override
  State<ActivityPanel> createState() =>
      _ActivityPanelState();
}

class _ActivityPanelState
    extends State<ActivityPanel> {
  bool _loading = true;

  List<Activity> _activities = [];

  @override
  void initState() {
    super.initState();

    _loadActivity();

    SocketService.instance
        .onActivityCreated(
      _onActivityCreated,
    );
  }

  Future<void> _loadActivity() async {
    try {
      final result =
          await ActivityService.instance
              .getActivity(
        eventId: widget.ticket.eventId,
      );

      if (!mounted) return;

      setState(() {
        _activities = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  void _onActivityCreated(
    dynamic data,
  ) {
    if (!mounted) return;

    final activity =
        Activity.fromJson(data);

    setState(() {
      _activities.insert(
        0,
        activity,
      );
    });
  }

  IconData _icon(
    String type,
  ) {
    switch (type) {
      case "CHECK_IN":
        return Icons.check_circle;

      case "STAFF_LOGIN":
        return Icons.login;

      case "STAFF_LOGOUT":
        return Icons.logout;

      case "NOTIFICATION":
        return Icons.notifications;

      case "VENDOR_CHECK_IN":
        return Icons.store;

      default:
        return Icons.timeline;
    }
  }

  Color _color(
    String type,
  ) {
    switch (type) {
      case "CHECK_IN":
        return Colors.green;

      case "STAFF_LOGIN":
        return Colors.blue;

      case "STAFF_LOGOUT":
        return Colors.orange;

      case "NOTIFICATION":
        return Colors.deepPurple;

      case "VENDOR_CHECK_IN":
        return const Color(
          0xFFD4AF37,
        );

      default:
        return Colors.grey;
    }
  }

  Widget _activityItem(
    Activity activity,
  ) {
    final color =
        _color(activity.type);

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  color.withValues(
                alpha: .15,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              _icon(activity.type),
              color: color,
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
                  activity.title,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                if (activity
                        .description !=
                    null)
                  Text(
                    activity
                        .description!,
                    style:
                        const TextStyle(
                      color:
                          Colors.grey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                const SizedBox(
                  height: 8,
                ),

                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    if (activity
                            .actorName !=
                        null)
                      Text(
                        activity
                            .actorName!,
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFFD4AF37,
                          ),
                          fontSize: 12,
                        ),
                      ),

                    if (activity
                            .ticketTypeName !=
                        null)
                      Text(
                        activity
                            .ticketTypeName!,
                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                    if (activity
                            .station !=
                        null)
                      Text(
                        activity
                            .station!,
                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SocketService.instance
        .removeActivityListeners();

    super.dispose();
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
                Icons.timeline,
                color:
                    Color(
                  0xFFD4AF37,
                ),
              ),

              SizedBox(
                width: 12,
              ),

              Text(
                "Activity",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          const Text(
            "Live activity happening across your event.",
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          if (_loading)
            const Center(
              child:
                  CircularProgressIndicator(),
            )
          else if (_activities
              .isEmpty)
            const Padding(
              padding:
                  EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Text(
                "No activity yet.",
                style: TextStyle(
                  color:
                      Colors.grey,
                ),
              ),
            )
          else
            Column(
              children:
                  _activities
                      .take(5)
                      .map(
                        _activityItem,
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}