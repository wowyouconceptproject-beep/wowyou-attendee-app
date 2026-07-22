class Announcement {
  final String id;
  final String eventId;
  final String authorId;

  final String title;
  final String message;

  final String type;
  final String priority;
  final String audience;

  final bool isPinned;

  final DateTime? expiresAt;
  final DateTime createdAt;

  final AnnouncementAuthor? author;

  Announcement({
    required this.id,
    required this.eventId,
    required this.authorId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.audience,
    required this.isPinned,
    required this.createdAt,
    this.expiresAt,
    this.author,
  });

  factory Announcement.fromJson(
    Map<String, dynamic> json,
  ) {
    return Announcement(
      id: json["id"],
      eventId: json["eventId"],
      authorId: json["authorId"],
      title: json["title"],
      message: json["message"],
      type: json["type"],
      priority: json["priority"],
      audience: json["audience"],
      isPinned: json["isPinned"] ?? false,
      createdAt: DateTime.parse(
        json["createdAt"],
      ),
      expiresAt:
          json["expiresAt"] != null
              ? DateTime.parse(
                  json["expiresAt"],
                )
              : null,
      author:
          json["author"] != null
              ? AnnouncementAuthor.fromJson(
                  json["author"],
                )
              : null,
    );
  }
}

class AnnouncementAuthor {
  final String id;
  final String name;
  final String? role;

  AnnouncementAuthor({
    required this.id,
    required this.name,
    this.role,
  });

  factory AnnouncementAuthor.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnnouncementAuthor(
      id: json["id"],
      name: json["name"],
      role: json["role"],
    );
  }
}