import "package:flutter/material.dart";

import "../../models/announcement.dart";
import "../../models/purchased_ticket.dart";
import "../../services/announcement_service.dart";
import "../../services/socket_service.dart";

class AnnouncementPanel extends StatefulWidget {
  final PurchasedTicket ticket;

  const AnnouncementPanel({
    super.key,
    required this.ticket,
  });

  @override
  State<AnnouncementPanel> createState() =>
      _AnnouncementPanelState();
}

class _AnnouncementPanelState
    extends State<AnnouncementPanel> {
  bool _loading = true;

  List<Announcement> _announcements = [];

  @override
  void initState() {
    super.initState();

    _loadAnnouncements();

    SocketService.instance
        .onAnnouncementCreated(
      _onAnnouncementCreated,
    );

    SocketService.instance
        .onAnnouncementUpdated(
      _onAnnouncementUpdated,
    );

    SocketService.instance
        .onAnnouncementDeleted(
      _onAnnouncementDeleted,
    );
  }

  Future<void> _loadAnnouncements() async {
    try {
      final announcements =
          await AnnouncementService
              .instance
              .getAnnouncements(
        eventId: widget.ticket.eventId,
      );

      if (!mounted) return;

      setState(() {
        _announcements =
            announcements;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  void _onAnnouncementCreated(
    dynamic data,
  ) {
    if (!mounted) return;

    final announcement =
        Announcement.fromJson(data);

    setState(() {
      _announcements.insert(
        0,
        announcement,
      );
    });
  }

  void _onAnnouncementUpdated(
    dynamic data,
  ) {
    if (!mounted) return;

    final updated =
        Announcement.fromJson(data);

    final index =
        _announcements.indexWhere(
      (e) => e.id == updated.id,
    );

    if (index == -1) return;

    setState(() {
      _announcements[index] =
          updated;
    });
  }

  void _onAnnouncementDeleted(
    dynamic data,
  ) {
    if (!mounted) return;

    final id = data["id"];

    setState(() {
      _announcements.removeWhere(
        (e) => e.id == id,
      );
    });
  }

  @override
  void dispose() {
    SocketService.instance
        .removeAnnouncementListeners();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
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
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.campaign,
                color: Color(
                  0xFFD4AF37,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Announcements",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          if (_loading)
            const Center(
              child:
                  CircularProgressIndicator(),
            )
          else if (_announcements
              .isEmpty)
            const Padding(
              padding:
                  EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Text(
                "No announcements yet.",
                style: TextStyle(
                  color:
                      Colors.grey,
                ),
              ),
            )
          else
            Column(
              children:
                  _announcements.map(
                (announcement) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: _AnnouncementItem(
                      announcement:
                          announcement,
                    ),
                  );
                },
              ).toList(),
            ),
        ],
      ),
    );
  }
}

class _AnnouncementItem
    extends StatelessWidget {
  final Announcement
      announcement;

  const _AnnouncementItem({
    required this.announcement,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            const Color(
          0xFF242424,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  announcement.title,
                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              if (announcement
                  .isPinned)
                const Icon(
                  Icons.push_pin,
                  color: Color(
                    0xFFD4AF37,
                  ),
                  size: 18,
                ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            announcement.message,
            style:
                const TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Row(
            children: [
              Text(
                announcement
                        .author
                        ?.name ??
                    "Organizer",
                style:
                    const TextStyle(
                  color: Color(
                    0xFFD4AF37,
                  ),
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const Spacer(),

              Text(
                announcement.type,
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
    );
  }
}