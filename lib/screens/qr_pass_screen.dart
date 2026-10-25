import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../mixins/wakelock_mixin.dart';
import '../models/event_pass.dart';
import '../models/purchased_ticket.dart';
import '../services/nfc_writer_service.dart';
import '../services/pass_service.dart';
import '../services/socket_service.dart';
import '../utils/storage.dart';

class QrPassScreen extends StatefulWidget {
  final PurchasedTicket ticket;

  const QrPassScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<QrPassScreen> createState() => _QrPassScreenState();
}

class _QrPassScreenState extends State<QrPassScreen>
    with WakelockMixin {
  final PassService _passService = PassService();
  final NfcWriterService _nfcWriter = NfcWriterService();
  final SocketService _socket = SocketService.instance;

  bool _loading = true;
  EventPass? _pass;

  PurchasedTicket get ticket => widget.ticket;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await enableWakeLock();

    await _loadSecurePass();

    if (!mounted) return;

    await _initializeRealtime();
  }

  /*
   * Load the permanent pass.
   *
   * The QR code uses pass.qrToken directly.
   * NFC continues to use pass.token.
   */

  Future<void> _loadSecurePass() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      final passes = await _passService.securePass(ticket.id);

      if (passes.isEmpty) {
        throw Exception('No pass issued.');
      }

      final loadedPass = EventPass.fromJson(passes.first);

      if (!mounted) return;

      setState(() {
        _pass = loadedPass;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  /*
   * Manual refresh.
   *
   * Reloads the permanent pass and its current status.
   * No rotating QR token is requested.
   */

  Future<void> _refreshPassScreen() async {
    await _loadSecurePass();
  }

  /*
   * Realtime check-in updates.
   */

  Future<void> _initializeRealtime() async {
    final token = await Storage.getToken();

    if (!mounted || token == null) {
      return;
    }

    await _socket.connect();

    if (!mounted) return;

    _socket.joinAttendee(
      token: token,
    );

    _socket.onPassCheckedIn(
      (data) {
        if (!mounted || _pass == null) {
          return;
        }

        setState(() {
          _pass = EventPass(
            id: _pass!.id,
            passNumber: _pass!.passNumber,
            qrToken: _pass!.qrToken,
            nfcToken: _pass!.nfcToken,
            token: _pass!.token,
            issuedAt: _pass!.issuedAt,
            expiresAt: _pass!.expiresAt,
            active: _pass!.active,
            revoked: _pass!.revoked,
            nfcEnabled: _pass!.nfcEnabled,
            checkedIn: true,
            checkedInAt: DateTime.now(),
            checkedInBy: data['checkedInBy'],
            station: data['station'],
            status: 'CHECKED_IN',
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You have been checked in successfully.',
            ),
          ),
        );
      },
    );
  }

  /*
   * NFC.
   *
   * NFC continues using the permanent signed pass token.
   * Do not replace this with the QR hash.
   */

  Future<void> _writeNfc() async {
    final pass = _pass;

    if (pass == null) {
      return;
    }

    if (!pass.nfcEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'NFC has not been enabled for this pass.',
          ),
        ),
      );
      return;
    }

    if (pass.isCheckedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This pass has already been checked in.',
          ),
        ),
      );
      return;
    }

    if (!pass.isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This pass is no longer active.',
          ),
        ),
      );
      return;
    }

    try {
      await _nfcWriter.writePassToken(pass.token);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Pass successfully saved to your NFC card.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  /*
   * Main UI.
   */

  @override
  Widget build(BuildContext context) {
    final pass = _pass;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Event Pass'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pass == null
              ? _buildEmptyState()
              : _buildPass(pass),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load your pass.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSecurePass,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPass(EventPass pass) {
    final canDisplayQr =
        pass.canEnter && pass.qrToken.isNotEmpty;

    return RefreshIndicator(
      onRefresh: _refreshPassScreen,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (canDisplayQr)
                    QrImageView(
                      key: ValueKey(pass.qrToken),
                      data: pass.qrToken,
                      size: 180,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    )
                  else
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Center(
                        child: Text(
                          pass.isCheckedIn
                              ? 'Already checked in'
                              : pass.isActive
                                  ? 'QR unavailable'
                                  : 'Pass unavailable',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    pass.passNumber,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  _buildStatus(pass),
                  if (canDisplayQr) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Present this QR code at the entrance.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pass Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pass.isCheckedIn
                        ? 'Checked in'
                        : pass.isActive
                            ? 'Active'
                            : 'Inactive',
                  ),
                  if (pass.checkedInAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Checked in at: ${pass.checkedInAt}',
                    ),
                  ],
                  if (pass.station != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Station: ${pass.station}',
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (pass.nfcEnabled)
            ElevatedButton.icon(
              onPressed: pass.isCheckedIn || !pass.isActive
                  ? null
                  : _writeNfc,
              icon: const Icon(Icons.nfc),
              label: const Text('Save Pass to NFC'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatus(EventPass pass) {
    if (pass.isCheckedIn) {
      return const Chip(
        avatar: Icon(
          Icons.check_circle,
          size: 18,
        ),
        label: Text('CHECKED IN'),
      );
    }

    if (pass.revoked) {
      return const Chip(
        avatar: Icon(
          Icons.cancel,
          size: 18,
        ),
        label: Text('REVOKED'),
      );
    }

    if (!pass.isActive) {
      return const Chip(
        avatar: Icon(
          Icons.warning,
          size: 18,
        ),
        label: Text('INACTIVE'),
      );
    }

    return const Chip(
      avatar: Icon(
        Icons.verified,
        size: 18,
      ),
      label: Text('ACTIVE'),
    );
  }

  @override
  void dispose() {
    disableWakeLock();

    _socket.leaveAttendee();
    _socket.removePassListeners();

    super.dispose();
  }
}