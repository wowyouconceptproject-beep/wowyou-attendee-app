class EventPass {
  final String id;

  final String passNumber;

  final String qrToken;

  final String nfcToken;

  final String token;

  final DateTime issuedAt;

  final DateTime? expiresAt;

  final bool active;

  final bool revoked;

  final bool nfcEnabled;

  /*
  |--------------------------------------------------------------------------
  | Check In
  |--------------------------------------------------------------------------
  */

  final bool checkedIn;

  final DateTime? checkedInAt;

  final String? checkedInBy;

  final String? station;

  /*
  |--------------------------------------------------------------------------
  | Status
  |--------------------------------------------------------------------------
  */

  final String status;

  EventPass({
    required this.id,
    required this.passNumber,
    required this.qrToken,
    required this.nfcToken,
    required this.token,
    required this.issuedAt,
    required this.expiresAt,
    required this.active,
    required this.revoked,
    required this.nfcEnabled,
    required this.checkedIn,
    this.checkedInAt,
    this.checkedInBy,
    this.station,
    required this.status,
  });

  factory EventPass.fromJson(
    Map<String, dynamic> json,
  ) {
    return EventPass(
      id: json["id"],

      passNumber:
          json["passNumber"],

      qrToken:
          json["qrToken"],

      nfcToken:
          json["nfcToken"],

      token:
          json["token"],

      issuedAt:
          DateTime.parse(
        json["issuedAt"],
      ),

      expiresAt:
          json["expiresAt"] != null
              ? DateTime.parse(
                  json["expiresAt"],
                )
              : null,

      active:
          json["active"] ??
              true,

      revoked:
          json["revoked"] ??
              false,

      nfcEnabled:
          json["nfcEnabled"] ??
              false,

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

      checkedInBy:
          json["checkedInBy"],

      station:
          json["station"],

      status:
          json["status"] ??
              "ACTIVE",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "passNumber":
          passNumber,

      "qrToken":
          qrToken,

      "nfcToken":
          nfcToken,

      "token": token,

      "issuedAt":
          issuedAt
              .toIso8601String(),

      "expiresAt":
          expiresAt
              ?.toIso8601String(),

      "active": active,

      "revoked": revoked,

      "nfcEnabled":
          nfcEnabled,

      "checkedIn":
          checkedIn,

      "checkedInAt":
          checkedInAt
              ?.toIso8601String(),

      "checkedInBy":
          checkedInBy,

      "station":
          station,

      "status":
          status,
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Helpers
  |--------------------------------------------------------------------------
  */

  bool get isCheckedIn =>
      checkedIn;

  bool get isExpired =>
      expiresAt != null &&
      expiresAt!.isBefore(
        DateTime.now(),
      );

  bool get isRevoked =>
      revoked;

  bool get isActive =>
      active &&
      !revoked &&
      !isExpired;

  bool get canEnter =>
      isActive &&
      !checkedIn;
}