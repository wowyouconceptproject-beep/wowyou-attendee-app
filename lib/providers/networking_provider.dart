
import "package:flutter/foundation.dart";

import "../models/match_card.dart";
import "../services/networking_service.dart";

class NetworkingProvider extends ChangeNotifier {
  final NetworkingService _service = NetworkingService();

  // ============================================
  // STATE
  // ============================================

  bool isLoading = false;
  bool isLoadingProfile = false;
  bool isLoadingRequests = false;
  bool isLoadingConnections = false;
  bool isUpdatingProfile = false;
  bool isSendingRequest = false;

  String? errorMessage;

  List<MatchCard> matches = [];

  Map<String, dynamic>? profile;

  List<Map<String, dynamic>> incomingRequests = [];
  List<Map<String, dynamic>> outgoingRequests = [];
  List<Map<String, dynamic>> connections = [];

  // ============================================
  // MATCHES
  // ============================================

  Future<void> loadMatches({
    required String eventId,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      matches = await _service.getMatches(
        eventId: eventId,
      );
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING PROVIDER MATCH ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({
    required String eventId,
  }) async {
    await loadMatches(eventId: eventId);
  }

  // ============================================
  // PROFILE
  // ============================================

  Future<void> loadProfile() async {
    isLoadingProfile = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _service.getProfile();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING PROFILE ERROR: $e");
    } finally {
      isLoadingProfile = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    isUpdatingProfile = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _service.updateProfile(
        profile: data,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING PROFILE UPDATE ERROR: $e");
      return false;
    } finally {
      isUpdatingProfile = false;
      notifyListeners();
    }
  }

  // ============================================
  // CONNECTION REQUESTS
  // ============================================

  Future<bool> sendRequest({
    required String receiverId,
    required String eventId,
    String? message,
  }) async {
    isSendingRequest = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.sendRequest(
        receiverId: receiverId,
        eventId: eventId,
        message: message,
      );

      await loadOutgoingRequests();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING SEND REQUEST ERROR: $e");
      return false;
    } finally {
      isSendingRequest = false;
      notifyListeners();
    }
  }

  Future<void> loadIncomingRequests() async {
    isLoadingRequests = true;
    errorMessage = null;
    notifyListeners();

    try {
      incomingRequests =
          await _service.getIncomingRequests();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING INCOMING ERROR: $e");
    } finally {
      isLoadingRequests = false;
      notifyListeners();
    }
  }

  Future<void> loadOutgoingRequests() async {
    isLoadingRequests = true;
    errorMessage = null;
    notifyListeners();

    try {
      outgoingRequests =
          await _service.getOutgoingRequests();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING OUTGOING ERROR: $e");
    } finally {
      isLoadingRequests = false;
      notifyListeners();
    }
  }

  Future<bool> acceptRequest({
    required String requestId,
  }) async {
    try {
      await _service.acceptRequest(
        requestId: requestId,
      );

      await Future.wait([
        loadIncomingRequests(),
        loadConnections(),
      ]);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING ACCEPT ERROR: $e");
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectRequest({
    required String requestId,
  }) async {
    try {
      await _service.rejectRequest(
        requestId: requestId,
      );

      await loadIncomingRequests();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING REJECT ERROR: $e");
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelRequest({
    required String requestId,
  }) async {
    try {
      await _service.cancelRequest(
        requestId: requestId,
      );

      await loadOutgoingRequests();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING CANCEL ERROR: $e");
      notifyListeners();
      return false;
    }
  }

  // ============================================
  // ACCEPTED CONNECTIONS
  // ============================================

  Future<void> loadConnections() async {
    isLoadingConnections = true;
    errorMessage = null;
    notifyListeners();

    try {
      connections =
          await _service.getConnections();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING CONNECTIONS ERROR: $e");
    } finally {
      isLoadingConnections = false;
      notifyListeners();
    }
  }

  Future<bool> removeConnection({
    required String connectionId,
  }) async {
    try {
      final success =
          await _service.removeConnection(
        connectionId: connectionId,
      );

      if (success) {
        connections.removeWhere(
          (connection) =>
              connection["id"] == connectionId,
        );

        notifyListeners();
      }

      return success;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("NETWORKING REMOVE ERROR: $e");
      notifyListeners();
      return false;
    }
  }

  // ============================================
  // LOAD ALL NETWORKING DATA
  // ============================================

  Future<void> loadNetworking({
    required String eventId,
  }) async {
    await Future.wait([
      loadMatches(eventId: eventId),
      loadProfile(),
      loadIncomingRequests(),
      loadOutgoingRequests(),
      loadConnections(),
    ]);
  }

  // ============================================
  // RESET STATE
  // ============================================

  void clear() {
    matches = [];
    profile = null;
    incomingRequests = [];
    outgoingRequests = [];
    connections = [];
    errorMessage = null;

    isLoading = false;
    isLoadingProfile = false;
    isLoadingRequests = false;
    isLoadingConnections = false;
    isUpdatingProfile = false;
    isSendingRequest = false;

    notifyListeners();
  }
}
