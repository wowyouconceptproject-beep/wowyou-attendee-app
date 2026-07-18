class AttendeeProfile {
  final String? profession;
  final String? industry;
  final String? bio;
  final List<dynamic>? goals;
  final List<dynamic>? skills;

  AttendeeProfile({
    this.profession,
    this.industry,
    this.bio,
    this.goals,
    this.skills,
  });

  factory AttendeeProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendeeProfile(
      profession:
          json["profession"],
      industry:
          json["industry"],
      bio: json["bio"],
      goals: json["goals"],
      skills: json["skills"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profession":
          profession,
      "industry":
          industry,
      "bio": bio,
      "goals": goals,
      "skills": skills,
    };
  }
}