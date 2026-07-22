class MatchReason {
  final String code;
  final String message;
  final int weight;

  const MatchReason({
    required this.code,
    required this.message,
    required this.weight,
  });

  factory MatchReason.fromJson(
    Map<String, dynamic> json,
  ) {
    return MatchReason(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      weight: json["weight"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "weight": weight,
    };
  }
}