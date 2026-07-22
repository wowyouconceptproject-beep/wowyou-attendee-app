class UserSettings {
  final String id;

  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String role;

  final String? avatar;
  final String? bio;

  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;

  const UserSettings({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.role,
    this.avatar,
    this.bio,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
  });

  String get fullName =>
      "$firstName $lastName";

  factory UserSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    final user = json["user"] ?? {};

    return UserSettings(
      id: json["id"],

      firstName:
          user["firstName"] ?? "",

      lastName:
          user["lastName"] ?? "",

      email:
          user["email"] ?? "",

      phone:
          user["phone"],

      role:
          user["role"] ?? "",

      avatar:
          json["avatar"],

      bio:
          json["bio"],

      pushNotifications:
          json["pushNotifications"] ??
              true,

      emailNotifications:
          json["emailNotifications"] ??
              true,

      smsNotifications:
          json["smsNotifications"] ??
              false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "avatar": avatar,
      "bio": bio,
      "pushNotifications":
          pushNotifications,
      "emailNotifications":
          emailNotifications,
      "smsNotifications":
          smsNotifications,
    };
  }

  UserSettings copyWith({
    String? avatar,
    String? bio,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
  }) {
    return UserSettings(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      pushNotifications:
          pushNotifications ??
              this.pushNotifications,
      emailNotifications:
          emailNotifications ??
              this.emailNotifications,
      smsNotifications:
          smsNotifications ??
              this.smsNotifications,
    );
  }
}