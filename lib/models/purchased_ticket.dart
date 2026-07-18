class PurchasedTicket {
  final String id;

  final int quantity;

  final double amount;

  final bool checkedIn;

  final DateTime? checkedInAt;

  /*
  |--------------------------------------------------------------------------
  | Event
  |--------------------------------------------------------------------------
  */

  final String eventId;

  final String eventTitle;

  final String venue;

  final DateTime startDate;

  final DateTime? endDate;

  final String? coverImage;

  final String? featuredImage;

  final String currency;

  /*
  |--------------------------------------------------------------------------
  | Ticket
  |--------------------------------------------------------------------------
  */

  final String ticketId;

  final String ticketName;

  /*
  |--------------------------------------------------------------------------
  | Attendee
  |--------------------------------------------------------------------------
  */

  final String attendeeName;

  final String? attendeeAvatar;

  final String? profession;

  final String? company;

  final String? jobTitle;

  PurchasedTicket({
    required this.id,
    required this.quantity,
    required this.amount,
    required this.checkedIn,
    this.checkedInAt,

    required this.eventId,
    required this.eventTitle,
    required this.venue,
    required this.startDate,
    this.endDate,
    this.coverImage,
    this.featuredImage,
    required this.currency,

    required this.ticketId,
    required this.ticketName,

    required this.attendeeName,
    this.attendeeAvatar,
    this.profession,
    this.company,
    this.jobTitle,
  });

  factory PurchasedTicket.fromJson(
    Map<String, dynamic> json,
  ) {
    final event =
        json["event"] ?? {};

    final ticket =
        json["ticket"] ?? {};

    final user =
        json["user"] ?? {};

    final profile =
        user["attendeeProfile"] ?? {};

    return PurchasedTicket(
      id: json["id"],

      quantity:
          json["quantity"],

      amount:
          (json["amount"] as num)
              .toDouble(),

      checkedIn:
          json["checkedIn"] ??
              false,

      checkedInAt:
          json["checkedInAt"] !=
                  null
              ? DateTime.parse(
                  json["checkedInAt"],
                )
              : null,

      eventId:
          event["id"],

      eventTitle:
          event["title"],

      venue:
          event["venue"],

      startDate:
          DateTime.parse(
        event["startDate"],
      ),

      endDate:
          event["endDate"] !=
                  null
              ? DateTime.parse(
                  event["endDate"],
                )
              : null,

      coverImage:
          event["coverImage"],

      featuredImage:
          event["featuredImage"],

      currency:
          event["currency"],

      ticketId:
          ticket["id"],

      ticketName:
          ticket["name"],

      attendeeName:
          "${user["firstName"]} ${user["lastName"]}",

      attendeeAvatar:
          profile["avatar"],

      profession:
          profile["profession"],

      company:
          profile["company"],

      jobTitle:
          profile["jobTitle"],
    );
  }
}