import "dart:async";

import "package:app_links/app_links.dart";
import "package:flutter/foundation.dart";

class PaymentDeepLinkService {
  PaymentDeepLinkService._();

  static final PaymentDeepLinkService instance =
      PaymentDeepLinkService._();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  Future<void> initialize({
    required void Function(String purchaseId) onPaymentReturn,
  }) async {
    try {
      final initialUri =
          await _appLinks.getInitialLink();

      if (initialUri != null) {
        _handleUri(
          initialUri,
          onPaymentReturn,
        );
      }
    } catch (error) {
      debugPrint(
        "PAYMENT DEEP LINK INITIAL ERROR: $error",
      );
    }

    _subscription?.cancel();

    _subscription =
        _appLinks.uriLinkStream.listen(
      (uri) {
        _handleUri(
          uri,
          onPaymentReturn,
        );
      },
      onError: (error) {
        debugPrint(
          "PAYMENT DEEP LINK ERROR: $error",
        );
      },
    );
  }

  void _handleUri(
    Uri uri,
    void Function(String purchaseId)
        onPaymentReturn,
  ) {
    debugPrint(
      "DEEP LINK RECEIVED: $uri",
    );

    if (uri.scheme != "wowyou") {
      return;
    }

    if (uri.host != "payment-return") {
      return;
    }

    final purchaseId =
        uri.queryParameters["purchase"];

    if (purchaseId == null ||
        purchaseId.isEmpty) {
      debugPrint(
        "PAYMENT DEEP LINK: Missing purchase ID.",
      );

      return;
    }

    onPaymentReturn(
      purchaseId,
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}