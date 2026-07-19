import "package:flutter/material.dart";
import "package:wakelock_plus/wakelock_plus.dart";

mixin WakelockMixin<T extends StatefulWidget>
    on State<T> {
  @mustCallSuper
  Future<void> enableWakeLock() async {
    await WakelockPlus.enable();
  }

  @mustCallSuper
  Future<void> disableWakeLock() async {
    await WakelockPlus.disable();
  }

  @override
  @mustCallSuper
  void dispose() {
    disableWakeLock();
    super.dispose();
  }
}