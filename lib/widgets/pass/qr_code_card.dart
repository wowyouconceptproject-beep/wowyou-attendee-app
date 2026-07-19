import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";

class QrCodeCard extends StatelessWidget {
  final bool loading;
  final String qrToken;

  const QrCodeCard({
    super.key,
    required this.loading,
    required this.qrToken,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF37),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFD4AF37),
                  width: 3,
                ),
              ),
              child: QrImageView(
                data: qrToken,
                version: QrVersions.auto,
                size: 280,
              ),
            ),
    );
  }
}