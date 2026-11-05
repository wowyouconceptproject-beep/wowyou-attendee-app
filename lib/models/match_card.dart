
import "match_reason.dart";

class MatchCard {
  final String userId;

  final String firstName;
  final String lastName;

  final String? profession;
  final String? company;
  final String? jobTitle;

  final String? avatar;

  final int score;

  final List<MatchReason> reasons;

  final String? explanation;

  const MatchCard({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profession,
    this.company,
    this.jobTitle,
    this.avatar,
    required this.score,
    required this.reasons,
    this.explanation,
  });

  // ============================================
  // DISPLAY HELPERS
  // ============================================

  String get fullName => "$firstName $lastName".trim();

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : "";
    final last = lastName.isNotEmpty ? lastName[0] : "";

    return "$first$last".toUpperCase();
  }

  bool get hasAvatar =>
      avatar != null && avatar!.trim().isNotEmpty;

  String get fullName => "$firstName $lastName".trim();

  String get initials {
  final first = firstName.isNotEmpty ? firstName[0] : "";
  final last = lastName.isNotEmpty ? lastName[0] : "";

  return "$first$last".toUpperCase();
}

  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  // ============================================
  // JSON PARSING
  // ============================================

  factory MatchCard.fromJson(Map<String, dynamic> json) {
    final rawReasons = json["reasons"];

    return MatchCard(
      userId: json["userId"]?.toString() ?? "",
      firstName: json["firstName"]?.toString() ?? "",
      lastName: json["lastName"]?.toString() ?? "",

      profession: json["profession"]?.toString(),
      company: json["company"]?.toString(),
      jobTitle: json["jobTitle"]?.toString(),
      avatar: json["avatar"]?.toString(),

      score: _parseInt(json["score"]),

      explanation: json["explanation"]?.toString(),

      reasons: rawReasons is List
          ? rawReasons
              .whereType<Map>()
              .map(
                (item) => MatchReason.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }

  // ============================================
  // JSON SERIALIZATION
  // ============================================

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "profession": profession,
      "company": company,
      "jobTitle": jobTitle,
      "avatar": avatar,
      "score": score,
      "explanation": explanation,
      "reasons": reasons.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================
  // HELPERS
  // ============================================

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;

    return 0;
  }
}
