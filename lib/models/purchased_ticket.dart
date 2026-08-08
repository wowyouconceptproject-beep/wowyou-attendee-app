class PurchasedTicket {
  final String id;

  final String status;

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

  /*
  |--------------------------------------------------------------------------
  | Issued Passes
  |--------------------------------------------------------------------------
  */

  final int totalPasses;

  final int activePasses;

  final bool hasPass;

  PurchasedTicket({
    required this.id,
    required this.status,
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

    required this.totalPasses,
    required this.activePasses,
    required this.hasPass,
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
        user["attendeeProfile"] ??
            {};

    final passes =
        (json["passes"] as List?)
                ?.cast<
                    Map<String,
                        dynamic>>() ??
            const [];

    final active =
        passes.where(
      (pass) =>
          pass["isActive"] ==
              true &&
          pass["isRevoked"] !=
              true,
    );

    return PurchasedTicket(
      id: json["id"],

      status:
          json["status"] ??
              "PENDING",

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
                  json[
                      "checkedInAt"],
                )
              : null,

      /*
      |--------------------------------------------------------------------------
      | Event
      |--------------------------------------------------------------------------
      */

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
                  event[
                      "endDate"],
                )
              : null,

      coverImage:
          event["coverImage"],

      featuredImage:
          event[
              "featuredImage"],

      currency:
          event["currency"],

      /*
      |--------------------------------------------------------------------------
      | Ticket
      |--------------------------------------------------------------------------
      */

      ticketId:
          ticket["id"],

      ticketName:
          ticket["name"],

      /*
      |--------------------------------------------------------------------------
      | Attendee
      |--------------------------------------------------------------------------
      */

      attendeeName:
          "${user["firstName"] ?? ""} ${user["lastName"] ?? ""}"
              .trim(),

      attendeeAvatar:
          profile["avatar"],

      profession:
          profile["profession"],

      company:
          profile["company"],

      jobTitle:
          profile["jobTitle"],

      /*
      |--------------------------------------------------------------------------
      | Passes
      |--------------------------------------------------------------------------
      */

      totalPasses:
          passes.length,

      activePasses:
          active.length,

      hasPass:
          passes.isNotEmpty,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Helpers
  |--------------------------------------------------------------------------
  */

  bool get paid =>
      status == "PAID";

  bool get pending =>
      status == "PENDING";

  bool get cancelled =>
      status == "CANCELLED";

  bool get completed =>
      checkedIn;
}