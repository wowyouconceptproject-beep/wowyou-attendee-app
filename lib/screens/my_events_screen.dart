import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/purchased_ticket.dart";
import "../providers/auth_provider.dart";
import "../services/purchase_service.dart";

import "../widgets/auth/protected_feature_view.dart";
import "../widgets/my_events/empty_events.dart";
import "../widgets/my_events/my_event_card.dart";

import "eventhubscreen.dart";
import "login_screen.dart";
import "register_screen.dart";

class MyEventsScreen extends StatefulWidget {
  final VoidCallback? onDiscover;

  const MyEventsScreen({
    super.key,
    this.onDiscover,
  });

  @override
  State<MyEventsScreen> createState() =>
      _MyEventsScreenState();
}

class _MyEventsScreenState
    extends State<MyEventsScreen> {
  final PurchaseService _purchaseService =
      PurchaseService();

  List<PurchasedTicket> _tickets = [];

  bool _loading = false;
  bool _loaded = false;

  String? _error;

  String? _loadedForUserId;

  /*
  |--------------------------------------------------------------------------
  | Dependencies Changed
  |--------------------------------------------------------------------------
  */

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final auth =
        context.read<AuthProvider>();

    /*
    |--------------------------------------------------------------------------
    | Guest
    |--------------------------------------------------------------------------
    */

    if (!auth.isAuthenticated) {
      if (_tickets.isNotEmpty ||
          _loaded ||
          _loadedForUserId != null) {
        _tickets = [];
        _loaded = false;
        _loadedForUserId = null;
        _error = null;
      }

      return;
    }

    final userId =
        auth.user?.id;

    /*
    |--------------------------------------------------------------------------
    | Load Once Authentication Becomes Available
    |--------------------------------------------------------------------------
    */

    if (!_loading &&
        (!_loaded ||
            _loadedForUserId !=
                userId)) {
      WidgetsBinding.instance
          .addPostFrameCallback(
        (_) {
          if (mounted) {
            _loadEvents();
          }
        },
      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Load Events
  |--------------------------------------------------------------------------
  */

  Future<void> _loadEvents() async {
    if (_loading) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    /*
    |--------------------------------------------------------------------------
    | Protected Endpoint
    |--------------------------------------------------------------------------
    */

    if (!auth.isAuthenticated) {
      if (mounted) {
        setState(() {
          _tickets = [];
          _loaded = false;
          _loading = false;
          _error = null;
          _loadedForUserId = null;
        });
      }

      return;
    }

    final userId =
        auth.user?.id;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result =
          await _purchaseService
              .getMyTickets();

      if (!mounted) {
        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Authentication Could Have Changed While Request Was Running
      |--------------------------------------------------------------------------
      */

      final currentAuth =
          context.read<AuthProvider>();

      if (!currentAuth
          .isAuthenticated) {
        setState(() {
          _tickets = [];
          _loaded = false;
          _loadedForUserId =
              null;
        });

        return;
      }

      setState(() {
        _tickets = result;
        _loaded = true;
        _loadedForUserId =
            userId;
      });
    } catch (error) {
      debugPrint(
        "MY EVENTS ERROR: $error",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _error =
            "Unable to load your events.";

        _loaded = true;

        _loadedForUserId =
            userId;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Upcoming Events
  |--------------------------------------------------------------------------
  */

  List<PurchasedTicket> get upcoming {
    final now =
        DateTime.now();

    final result = _tickets
        .where(
          (ticket) =>
              ticket.startDate
                  .isAfter(now),
        )
        .toList();

    result.sort(
      (a, b) =>
          a.startDate.compareTo(
        b.startDate,
      ),
    );

    return result;
  }

  /*
  |--------------------------------------------------------------------------
  | Past Events
  |--------------------------------------------------------------------------
  */

  List<PurchasedTicket> get past {
    final now =
        DateTime.now();

    final result = _tickets
        .where(
          (ticket) =>
              ticket.startDate
                  .isBefore(now),
        )
        .toList();

    result.sort(
      (a, b) =>
          b.startDate.compareTo(
        a.startDate,
      ),
    );

    return result;
  }

  /*
  |--------------------------------------------------------------------------
  | Login
  |--------------------------------------------------------------------------
  */

  Future<void> _openLogin() async {
    await Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    if (auth.isAuthenticated &&
        !_loaded) {
      await _loadEvents();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Register
  |--------------------------------------------------------------------------
  */

  Future<void> _openRegister() async {
    await Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (_) =>
            const RegisterScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    if (auth.isAuthenticated &&
        !_loaded) {
      await _loadEvents();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Open Event Hub
  |--------------------------------------------------------------------------
  */

  void _openEvent(
    PurchasedTicket ticket,
  ) {
    Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (_) =>
            EventHubScreen(
          ticket: ticket,
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Discover Events
  |--------------------------------------------------------------------------
  */

  void _discoverEvents() {
    widget.onDiscover?.call();
  }

  /*
  |--------------------------------------------------------------------------
  | Build
  |--------------------------------------------------------------------------
  */

  @override
  Widget build(
    BuildContext context,
  ) {
    final auth =
        context.watch<AuthProvider>();

    /*
    |--------------------------------------------------------------------------
    | Guest
    |--------------------------------------------------------------------------
    */

    if (!auth.isAuthenticated) {
      return ProtectedFeatureView(
        icon:
            Icons.event_outlined,

        title:
            "Your Events",

        description:
            "Sign in to view your upcoming events, past events and everything you've registered for.",

        benefits: const [
          "View upcoming events",
          "Access your Event Hub",
          "Review past events",
          "Stay updated with event activities",
        ],

        onSignIn:
            _openLogin,

        onCreateAccount:
            _openRegister,
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Authenticated
    |--------------------------------------------------------------------------
    */

    return Scaffold(
      backgroundColor:
          const Color(
        0xFF0B0B0B,
      ),

      appBar: AppBar(
        title:
            const Text(
          "My Events",
        ),
      ),

      body:
          _buildBody(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Body
  |--------------------------------------------------------------------------
  */

  Widget _buildBody() {
    /*
    |--------------------------------------------------------------------------
    | Initial Loading
    |--------------------------------------------------------------------------
    */

    if (_loading &&
        !_loaded) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Error
    |--------------------------------------------------------------------------
    */

    if (_error != null &&
        _tickets.isEmpty) {
      return RefreshIndicator(
        onRefresh:
            _loadEvents,

        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              const EdgeInsets.all(
            24,
          ),

          children: [
            const SizedBox(
              height: 120,
            ),

            const Icon(
              Icons
                  .error_outline_rounded,
              size: 48,
              color:
                  Colors.grey,
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              _error!,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Center(
              child:
                  FilledButton.icon(
                onPressed:
                    _loadEvents,

                icon:
                    const Icon(
                  Icons.refresh,
                ),

                label:
                    const Text(
                  "Try Again",
                ),
              ),
            ),
          ],
        ),
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Empty
    |--------------------------------------------------------------------------
    */

    if (_tickets.isEmpty) {
      return RefreshIndicator(
        onRefresh:
            _loadEvents,

        child:
            LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            return SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              child:
                  ConstrainedBox(
                constraints:
                    BoxConstraints(
                  minHeight:
                      constraints
                          .maxHeight,
                ),

                child:
                    EmptyEvents(
                  onDiscover:
                      _discoverEvents,
                ),
              ),
            );
          },
        ),
      );
    }

    /*
    |--------------------------------------------------------------------------
    | Events
    |--------------------------------------------------------------------------
    */

    return RefreshIndicator(
      onRefresh:
          _loadEvents,

      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),

        children: [
          /*
          |--------------------------------------------------------------------------
          | Refresh Progress
          |--------------------------------------------------------------------------
          */

          if (_loading)
            const LinearProgressIndicator(
              minHeight: 2,
            ),

          /*
          |--------------------------------------------------------------------------
          | Upcoming
          |--------------------------------------------------------------------------
          */

          if (upcoming
              .isNotEmpty) ...[
            const Padding(
              padding:
                  EdgeInsets.fromLTRB(
                24,
                24,
                24,
                18,
              ),

              child:
                  Text(
                "Upcoming",
                style:
                    TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            ...upcoming.map(
              (ticket) =>
                  MyEventCard(
                ticket:
                    ticket,

                onOpen: () =>
                    _openEvent(
                  ticket,
                ),
              ),
            ),
          ],

          /*
          |--------------------------------------------------------------------------
          | Past
          |--------------------------------------------------------------------------
          */

          if (past
              .isNotEmpty) ...[
            const Padding(
              padding:
                  EdgeInsets.fromLTRB(
                24,
                18,
                24,
                18,
              ),

              child:
                  Text(
                "Past Events",
                style:
                    TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            ...past.map(
              (ticket) =>
                  Opacity(
                opacity:
                    .75,

                child:
                    MyEventCard(
                  ticket:
                      ticket,

                  onOpen: () =>
                      _openEvent(
                    ticket,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}