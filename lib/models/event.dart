class Event {
  final String id;
  final String title;
  final String description;
  final String venue;

  final String? coverImage;
  final String? featuredImage;

  final int capacity;
  final String status;

  final DateTime startDate;
  final DateTime endDate;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,

    this.coverImage,
    this.featuredImage,

    required this.capacity,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  factory Event.fromJson(
    Map<String, dynamic> json,
  ) {
    return Event(
      id: json["id"],

      title:
          json["title"] ?? "",

      description:
          json["description"] ?? "",

      venue:
          json["venue"] ?? "",

      coverImage:
          json["coverImage"],

      featuredImage:
          json["featuredImage"],

      capacity:
          json["capacity"] ?? 0,

      status:
          json["status"] ?? "",

      startDate:
          DateTime.parse(
        json["startDate"],
      ),

      endDate:
          DateTime.parse(
        json["endDate"],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "venue": venue,
      "coverImage": coverImage,
      "featuredImage": featuredImage,
      "capacity": capacity,
      "status": status,
      "startDate":
          startDate.toIso8601String(),
      "endDate":
          endDate.toIso8601String(),
    };
  }
}