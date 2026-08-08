import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../config/api.dart';
import '../config/socket_events.dart';

class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  io.Socket get socket => _socket!;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      return;
    }

    _socket = io.io(
      ApiConfig.baseUrl,
      io.OptionBuilder()
          .setTransports([
            'websocket',
          ])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      if (kDebugMode) {
        debugPrint('🟢 Socket Connected');
      }
    });

    _socket!.onDisconnect((_) {
      if (kDebugMode) {
        debugPrint('🔴 Socket Disconnected');
      }
    });

    _socket!.onConnectError((error) {
      if (kDebugMode) {
        debugPrint('Socket Connect Error: $error');
      }
    });

    _socket!.onError((error) {
      if (kDebugMode) {
        debugPrint('Socket Error: $error');
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  // ---------------------------------------------------------------------------
  // Join / Leave Rooms
  // ---------------------------------------------------------------------------

  void joinEvent({
    required String eventId,
    required String token,
  }) {
    _socket?.emit(
      SocketEvents.joinEvent,
      {
        'eventId': eventId,
        'token': token,
      },
    );
  }

  void leaveEvent(String eventId) {
    _socket?.emit(
      SocketEvents.leaveEvent,
      eventId,
    );
  }

  void joinAttendee({
    required String token,
  }) {
    _socket?.emit(
      SocketEvents.joinAttendee,
      {
        'token': token,
      },
    );
  }

  void leaveAttendee() {
    _socket?.emit(SocketEvents.leaveAttendee);
  }

  void joinOrganizer({
    required String organizerId,
    required String token,
  }) {
    _socket?.emit(
      SocketEvents.joinOrganizer,
      {
        'organizerId': organizerId,
        'token': token,
      },
    );
  }

  void leaveOrganizer(String organizerId) {
    _socket?.emit(
      SocketEvents.leaveOrganizer,
      organizerId,
    );
  }

  // ---------------------------------------------------------------------------
  // Announcement Events
  // ---------------------------------------------------------------------------

  void onAnnouncementCreated(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.announcementCreated,
      listener,
    );
  }

  void onAnnouncementUpdated(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.announcementUpdated,
      listener,
    );
  }

  void onAnnouncementDeleted(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.announcementDeleted,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Activity Events
  // ---------------------------------------------------------------------------

  void onActivityCreated(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.activityCreated,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Notification Events
  // ---------------------------------------------------------------------------

  void onNotification(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.notification,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Attendance Events
  // ---------------------------------------------------------------------------

  void onAttendanceUpdated(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.attendanceUpdated,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Pass Events
  // ---------------------------------------------------------------------------

  void onPassIssued(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.passIssued,
      listener,
    );
  }

  void onPassCheckedIn(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.passCheckedIn,
      listener,
    );
  }

  void onPassRevoked(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.passRevoked,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Capacity Events
  // ---------------------------------------------------------------------------

  void onCapacityUpdated(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.capacityUpdated,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Event Status Events
  // ---------------------------------------------------------------------------

  void onEventStatusChanged(
    Function(dynamic data) listener,
  ) {
    _socket?.on(
      SocketEvents.eventStatusChanged,
      listener,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Announcement Listeners
  // ---------------------------------------------------------------------------

  void removeAnnouncementListeners() {
    _socket?.off(
      SocketEvents.announcementCreated,
    );

    _socket?.off(
      SocketEvents.announcementUpdated,
    );

    _socket?.off(
      SocketEvents.announcementDeleted,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Activity Listeners
  // ---------------------------------------------------------------------------

  void removeActivityListeners() {
    _socket?.off(
      SocketEvents.activityCreated,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Notification Listeners
  // ---------------------------------------------------------------------------

  void removeNotificationListeners() {
    _socket?.off(
      SocketEvents.notification,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Attendance Listeners
  // ---------------------------------------------------------------------------

  void removeAttendanceListeners() {
    _socket?.off(
      SocketEvents.attendanceUpdated,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Pass Listeners
  // ---------------------------------------------------------------------------

  void removePassListeners() {
    _socket?.off(
      SocketEvents.passIssued,
    );

    _socket?.off(
      SocketEvents.passCheckedIn,
    );

    _socket?.off(
      SocketEvents.passRevoked,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Capacity Listeners
  // ---------------------------------------------------------------------------

  void removeCapacityListeners() {
    _socket?.off(
      SocketEvents.capacityUpdated,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove Event Status Listeners
  // ---------------------------------------------------------------------------

  void removeEventListeners() {
    _socket?.off(
      SocketEvents.eventStatusChanged,
    );
  }

  // ---------------------------------------------------------------------------
  // Remove All Listeners
  // ---------------------------------------------------------------------------

  void removeAllListeners() {
    removeAnnouncementListeners();
    removeActivityListeners();
    removeNotificationListeners();
    removeAttendanceListeners();
    removePassListeners();
    removeCapacityListeners();
    removeEventListeners();

    _socket?.clearListeners();
  }
}