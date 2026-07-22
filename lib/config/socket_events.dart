class SocketEvents {
  SocketEvents._();

  /*
  |--------------------------------------------------------------------------
  | Room Commands
  |--------------------------------------------------------------------------
  */

  static const String joinEvent =
      "join-event";

  static const String leaveEvent =
      "leave-event";

  static const String joinAttendee =
      "join-attendee";

  static const String leaveAttendee =
      "leave-attendee";

  static const String joinOrganizer =
      "join-organizer";

  static const String leaveOrganizer =
      "leave-organizer";

  /*
  |--------------------------------------------------------------------------
  | Realtime Events
  |--------------------------------------------------------------------------
  */

  static const String attendanceUpdated =
      "attendance.updated";

  static const String activityCreated =
      "activity.created";

  static const String announcementCreated =
      "announcement.created";

  static const String announcementUpdated =
      "announcement.updated";

  static const String announcementDeleted =
      "announcement.deleted";

  static const String staffOnline =
      "staff.online";

  static const String staffOffline =
      "staff.offline";

  static const String notification =
      "notification";

  static const String vendorApplicationCreated =
      "vendor.application.created";

  static const String vendorApplicationUpdated =
      "vendor.application.updated";
}