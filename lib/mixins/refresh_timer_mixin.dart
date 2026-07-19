import "dart:async";

import "package:flutter/material.dart";

mixin RefreshTimerMixin<T extends StatefulWidget>
    on State<T> {
  Timer? refreshTimer;
  Timer? countdownTimer;

  int secondsRemaining = 0;

  Duration get refreshDuration =>
      const Duration(seconds: 60);

  Future<void> onRefresh();

  @mustCallSuper
  void startRefreshTimer() {
    stopRefreshTimer();

    secondsRemaining =
        refreshDuration.inSeconds;

    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        }
      },
    );

    refreshTimer = Timer.periodic(
      refreshDuration,
      (_) async {
        await onRefresh();

        if (!mounted) return;

        setState(() {
          secondsRemaining =
              refreshDuration.inSeconds;
        });
      },
    );
  }

  @mustCallSuper
  void stopRefreshTimer() {
    countdownTimer?.cancel();
    refreshTimer?.cancel();
  }

  @override
  @mustCallSuper
  void dispose() {
    stopRefreshTimer();
    super.dispose();
  }
}