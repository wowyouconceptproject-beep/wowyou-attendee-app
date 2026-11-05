
class MatchReason {
  final String code;
  final String message;
  final int weight;

  const MatchReason({
    required this.code,
    required this.message,
    required this.weight,
  });

  // ============================================
  // DISPLAY HELPERS
  // ============================================

  String get title {
    switch (code.toLowerCase()) {
      case "skills":
        return "Shared Skills";

      case "goals":
        return "Shared Goals";

      case "profession":
        return "Same Profession";

      case "industry":
        return "Same Industry";

      case "company":
        return "Same Company";

      default:
        return code.isNotEmpty ? code : "Match Reason";
    }
  }

  // ============================================
  // JSON PARSING
  // ============================================

  factory MatchReason.fromJson(Map<String, dynamic> json) {
    return MatchReason(
      code: json["code"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      weight: _parseInt(json["weight"]),
    );
  }

  // ============================================
  // JSON SERIALIZATION
  // ============================================

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "weight": weight,
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
