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

  String get fullName =>
      "$firstName $lastName";

  factory MatchCard.fromJson(
    Map<String, dynamic> json,
  ) {
    return MatchCard(
      userId: json["userId"] ?? "",

      firstName:
          json["firstName"] ?? "",

      lastName:
          json["lastName"] ?? "",

      profession:
          json["profession"],

      company:
          json["company"],

      jobTitle:
          json["jobTitle"],

      avatar:
          json["avatar"],

      score:
          json["score"] ?? 0,

      explanation:
          json["explanation"],

      reasons:
          (json["reasons"] as List?)
                  ?.map(
                    (e) =>
                        MatchReason.fromJson(e),
                  )
                  .toList() ??
              [],
    );
  }

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
      "reasons":
          reasons
              .map(
                (e) => e.toJson(),
              )
              .toList(),
    };
  }
}