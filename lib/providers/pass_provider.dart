import "package:flutter/material.dart";

import "../models/event_pass.dart";
import "../services/pass_service.dart";

class PassProvider extends ChangeNotifier {
  final PassService _service =
      PassService();

  bool loading = false;

  Map<String, dynamic>? purchase;

  List<EventPass> passes = [];

  /*
  |--------------------------------------------------------------------------
  | Load Purchase Pass
  |--------------------------------------------------------------------------
  */

  Future<void> load(
    String purchaseId,
  ) async {
    loading = true;

    notifyListeners();

    try {
      final data =
          await _service.getPass(
        purchaseId,
      );

      purchase =
          data["purchase"];

      final issued =
          await _service
              .securePass(
        purchaseId,
      );

      passes = issued
          .map(
            (e) =>
                EventPass.fromJson(
              e,
            ),
          )
          .toList();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Refresh
  |--------------------------------------------------------------------------
  */

  Future<void> refresh(
    String purchaseId,
  ) async {
    final issued =
        await _service
            .refreshPass(
      purchaseId,
    );

    passes = issued
        .map(
          (e) =>
              EventPass.fromJson(
            e,
          ),
        )
        .toList();

    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | Current Pass
  |--------------------------------------------------------------------------
  */

  EventPass? get currentPass {
    if (passes.isEmpty) {
      return null;
    }

    return passes.first;
  }

  /*
  |--------------------------------------------------------------------------
  | Status
  |--------------------------------------------------------------------------
  */

  bool get hasPass =>
      currentPass != null;

  bool get revoked =>
      currentPass?.revoked ??
      false;

  bool get active =>
      currentPass?.active ??
      false;

  bool get expired {
    final pass =
        currentPass;

    if (pass == null) {
      return false;
    }

    if (pass.expiresAt ==
        null) {
      return false;
    }

    return pass.expiresAt!
        .isBefore(
      DateTime.now(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Reset
  |--------------------------------------------------------------------------
  */

  void clear() {
    purchase = null;

    passes.clear();

    notifyListeners();
  }
}