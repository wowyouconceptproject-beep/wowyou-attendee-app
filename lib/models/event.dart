class Event {
  final String id;
  final String title;
  final String description;
  final String venue;

  /*
  |--------------------------------------------------------------------------
  | Location
  |--------------------------------------------------------------------------
  */

  final String? venueAddress;
  final String? city;
  final String? country;

  final double? venueLatitude;
  final double? venueLongitude;

  /*
  |--------------------------------------------------------------------------
  | Images
  |--------------------------------------------------------------------------
  */

  final String? coverImage;
  final String? featuredImage;

  /*
  |--------------------------------------------------------------------------
  | Event
  |--------------------------------------------------------------------------
  */

  final int capacity;
  final String status;

  final String currency;
  final String? category;

  final DateTime startDate;
  final DateTime endDate;

  /*
  |--------------------------------------------------------------------------
  | Tickets
  |--------------------------------------------------------------------------
  */

  final List<TicketType> tickets;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,

    this.venueAddress,
    this.city,
    this.country,

    this.venueLatitude,
    this.venueLongitude,

    this.coverImage,
    this.featuredImage,

    required this.capacity,
    required this.status,
    required this.currency,
    this.category,
    required this.startDate,
    required this.endDate,
    this.tickets = const [],
  });

  factory Event.fromJson(
    Map<String, dynamic> json,
  ) {
    /*
    |--------------------------------------------------------------------------
    | Ticket Payload
    |--------------------------------------------------------------------------
    |
    | Supports both:
    |
    | tickets: [...]
    |
    | and:
    |
    | ticketTypes: [...]
    |
    | This gives us some compatibility while the backend endpoints are being
    | unified.
    |
    */

    final dynamic ticketData =
        json["tickets"] ??
        json["ticketTypes"] ??
        [];

    final List<dynamic> ticketList =
        ticketData is List
            ? ticketData
            : [];

    return Event(
      /*
      |--------------------------------------------------------------------------
      | Basic Information
      |--------------------------------------------------------------------------
      */

      id:
          json["id"]?.toString() ??
          "",

      title:
          json["title"]?.toString() ??
          "",

      description:
          json["description"]
              ?.toString() ??
          "",

      venue:
          json["venue"]?.toString() ??
          "",

      /*
      |--------------------------------------------------------------------------
      | Location
      |--------------------------------------------------------------------------
      */

      venueAddress:
          json["venueAddress"]
              ?.toString(),

      city:
          json["city"]?.toString(),

      country:
          json["country"]?.toString(),

      venueLatitude:
          _toDoubleOrNull(
        json["venueLatitude"],
      ),

      venueLongitude:
          _toDoubleOrNull(
        json["venueLongitude"],
      ),

      /*
      |--------------------------------------------------------------------------
      | Images
      |--------------------------------------------------------------------------
      */

      coverImage:
          json["coverImage"]
              ?.toString(),

      featuredImage:
          json["featuredImage"]
              ?.toString(),

      /*
      |--------------------------------------------------------------------------
      | Event
      |--------------------------------------------------------------------------
      */

      capacity:
          _toInt(
        json["capacity"],
      ),

      status:
          json["status"]?.toString() ??
          "",

      currency:
          json["currency"]
              ?.toString()
              .toUpperCase() ??
          "USD",

      category:
          json["category"]
              ?.toString(),

      startDate:
          _parseDate(
        json["startDate"],
      ),

      endDate:
          _parseDate(
        json["endDate"],
      ),

      /*
      |--------------------------------------------------------------------------
      | Tickets
      |--------------------------------------------------------------------------
      */

      tickets:
          ticketList
              .whereType<
                  Map<String, dynamic>
                >()
              .map(
                TicketType.fromJson,
              )
              .toList(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | JSON
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "title":
          title,

      "description":
          description,

      "venue":
          venue,

      /*
      |--------------------------------------------------------------------------
      | Location
      |--------------------------------------------------------------------------
      */

      "venueAddress":
          venueAddress,

      "city":
          city,

      "country":
          country,

      "venueLatitude":
          venueLatitude,

      "venueLongitude":
          venueLongitude,

      /*
      |--------------------------------------------------------------------------
      | Images
      |--------------------------------------------------------------------------
      */

      "coverImage":
          coverImage,

      "featuredImage":
          featuredImage,

      /*
      |--------------------------------------------------------------------------
      | Event
      |--------------------------------------------------------------------------
      */

      "capacity":
          capacity,

      "status":
          status,

      "currency":
          currency,

      "category":
          category,

      "startDate":
          startDate
              .toIso8601String(),

      "endDate":
          endDate
              .toIso8601String(),

      /*
      |--------------------------------------------------------------------------
      | Tickets
      |--------------------------------------------------------------------------
      */

      "tickets":
          tickets
              .map(
                (ticket) =>
                    ticket.toJson(),
              )
              .toList(),
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Integer Parser
  |--------------------------------------------------------------------------
  */

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ??
              "",
        ) ??
        0;
  }

  /*
  |--------------------------------------------------------------------------
  | Double Parser
  |--------------------------------------------------------------------------
  */

  static double? _toDoubleOrNull(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Date Parser
  |--------------------------------------------------------------------------
  */

  static DateTime _parseDate(
    dynamic value,
  ) {
    return DateTime.tryParse(
          value?.toString() ??
              "",
        ) ??
        DateTime
            .fromMillisecondsSinceEpoch(
          0,
        );
  }
}

/*
|--------------------------------------------------------------------------
| Ticket Type
|--------------------------------------------------------------------------
*/

class TicketType {
  final String id;
  final String name;
  final String? description;

  final double price;

  final int quantity;
  final int sold;

  final bool isActive;

  final String? color;

  TicketType({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
    required this.sold,
    required this.isActive,
    this.color,
  });

  /*
  |--------------------------------------------------------------------------
  | Ticket Availability
  |--------------------------------------------------------------------------
  */

  int get remaining {
    final value =
        quantity - sold;

    return value < 0
        ? 0
        : value;
  }

  bool get soldOut =>
      remaining <= 0;

  bool get available =>
      isActive && !soldOut;

  bool get isFree =>
      price <= 0;

  /*
  |--------------------------------------------------------------------------
  | From JSON
  |--------------------------------------------------------------------------
  */

  factory TicketType.fromJson(
    Map<String, dynamic> json,
  ) {
    return TicketType(
      id:
          json["id"]?.toString() ??
          "",

      name:
          json["name"]?.toString() ??
          "Ticket",

      description:
          json["description"]
              ?.toString(),

      price:
          _toDouble(
        json["price"],
      ),

      quantity:
          _toInt(
        json["quantity"],
      ),

      sold:
          _toInt(
        json["sold"],
      ),

      isActive:
          json["isActive"] ==
              true,

      color:
          json["color"]
              ?.toString(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | To JSON
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> toJson() {
    return {
      "id":
          id,

      "name":
          name,

      "description":
          description,

      "price":
          price,

      "quantity":
          quantity,

      "sold":
          sold,

      "isActive":
          isActive,

      "color":
          color,
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Integer Parser
  |--------------------------------------------------------------------------
  */

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ??
              "",
        ) ??
        0;
  }

  /*
  |--------------------------------------------------------------------------
  | Double Parser
  |--------------------------------------------------------------------------
  */

  static double _toDouble(
    dynamic value,
  ) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ??
              "",
        ) ??
        0;
  }
}