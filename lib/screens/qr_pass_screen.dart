
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../mixins/refresh_timer_mixin.dart';
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
    with RefreshTimerMixin, WakelockMixin {
  final PassService _passService = PassService();

  final NfcWriterService _nfcWriter = NfcWriterService();

  final SocketService _socket = SocketService.instance;

  bool _loading = true;

  bool _refreshingQr = false;

  EventPass? _pass;

  String? _rotatingQrToken;

  PurchasedTicket get ticket => widget.ticket;

  @override
  Duration get refreshDuration => const Duration(seconds: 50);

  @override
  Future<void> onRefresh() async {
    await _loadRotatingQr();
  }

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await enableWakeLock();

    await _loadSecurePass();

    if (!mounted) return;

    if (_pass != null && _pass!.canEnter) {
      await _loadRotatingQr();
    }

    await _initializeRealtime();

    if (mounted) {
      startRefreshTimer();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Load Permanent Pass
  |--------------------------------------------------------------------------
  |
  | This token remains the credential used by the existing NFC writer.
  |
  */

  Future<void> _loadSecurePass() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      final passes = await _passService.securePass(
        ticket.id,
      );

      if (passes.isEmpty) {
        throw Exception('No pass issued.');
      }

      if (!mounted) return;

      setState(() {
        _pass = EventPass.fromJson(
          passes.first,
        );

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
  |--------------------------------------------------------------------------
  | Load Rotating QR
  |--------------------------------------------------------------------------
  |
  | The rotating QR is fetched separately from the permanent pass.
  | If refreshing fails, remove the previous token from the screen
  | rather than continuing to display a potentially expired QR code.
  |
  */

  Future<void> _loadRotatingQr() async {
    if (_refreshingQr || !mounted) return;

    final pass = _pass;

    if (pass == null || !pass.canEnter) {
      setState(() {
        _rotatingQrToken = null;
      });
      return;
    }

    setState(() {
      _refreshingQr = true;
      _rotatingQrToken = null;
    });

    try {
      final token = await _passService.rotatingQrToken(
        ticket.id,
      );

      if (!mounted) return;

      setState(() {
        _rotatingQrToken = token;
        secondsRemaining = refreshDuration.inSeconds;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _rotatingQrToken = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to refresh QR code. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _refreshingQr = false;
        });
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Manual Refresh
  |--------------------------------------------------------------------------
  */

  Future<void> _refreshPassScreen() async {
    await _loadSecurePass();

    if (!mounted) return;

    if (_pass != null && _pass!.canEnter) {
      await _loadRotatingQr();
    } else {
      setState(() {
        _rotatingQrToken = null;
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Realtime
  |--------------------------------------------------------------------------
  */

  Future<void> _initializeRealtime() async {
    final token = await Storage.getToken();

    if (token == null) {
      return;
    }

    await _socket.connect();

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

          _rotatingQrToken = null;
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
  |--------------------------------------------------------------------------
  | NFC
  |--------------------------------------------------------------------------
  |
  | NFC continues using the permanent signed pass token.
  | Do not replace this with the rotating QR token.
  |
  */

  Future<void> _writeNfc() async {
    if (_pass == null) {
      return;
    }

    if (!_pass!.nfcEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'NFC has not been enabled for this pass.',
          ),
        ),
      );

      return;
    }

    if (_pass!.isCheckedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This pass has already been checked in.',
          ),
        ),
      );

      return;
    }

    if (!_pass!.isActive) {
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
      await _nfcWriter.writePassToken(
        _pass!.token,
      );

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
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | UI
  |--------------------------------------------------------------------------
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
                  if (pass.canEnter && _rotatingQrToken != null)
                    QrImageView(
                      key: ValueKey(_rotatingQrToken),
                      data: _rotatingQrToken!,
                      size: 180,
                      errorCorrectionLevel:
                          QrErrorCorrectLevel.M,
                    )
                  else
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Center(
                        child: _refreshingQr
                            ? const CircularProgressIndicator()
                            : Text(
                                pass.isCheckedIn
                                    ? 'Already checked in'
                                    : pass.isActive
                                        ? 'QR unavailable.\nPull down to retry.'
                                        : 'Pass unavailable',
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    pass.passNumber,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  _buildStatus(pass),
                  if (pass.canEnter) ...[
                    const SizedBox(height: 8),
                    Text(
                      _refreshingQr
                          ? 'Refreshing QR code…'
                          : 'QR refreshes in about '
                              '$secondsRemaining seconds',
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
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
              label: const Text(
                'Save Pass to NFC',
              ),
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
    stopRefreshTimer();

    disableWakeLock();

    _socket.leaveAttendee();

    _socket.removePassListeners();

    super.dispose();
  }
}
