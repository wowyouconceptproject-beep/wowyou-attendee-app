import "dart:async";

import "package:flutter/material.dart";

import "../../models/event.dart";
import "../../services/search_service.dart";

import "../event_details_screen.dart";
import "package:attendee_app/theme/app_colors.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final TextEditingController
      _controller =
      TextEditingController();

  final SearchService
      _searchService =
      SearchService();

  Timer? _debounce;

  List<Event> _results = [];

  bool _loading = false;

  String _error = "";

  String _activeQuery = "";

  int _searchGeneration = 0;

  /*
  |--------------------------------------------------------------------------
  | Search Changed
  |--------------------------------------------------------------------------
  */

  void _onSearchChanged(
    String value,
  ) {
    _debounce?.cancel();

    final query =
        value.trim();

    if (query.isEmpty) {
      _searchGeneration++;

      setState(() {
        _results = [];
        _loading = false;
        _error = "";
        _activeQuery = "";
      });

      return;
    }

    /*
    |--------------------------------------------------------------------------
    | Debounce
    |--------------------------------------------------------------------------
    |
    | We don't want to hit the backend for every keystroke.
    |
    */

    _debounce = Timer(
      const Duration(
        milliseconds: 400,
      ),
      () {
        _search(query);
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Search
  |--------------------------------------------------------------------------
  */

  Future<void> _search(
    String query,
  ) async {
    final q =
        query.trim();

    if (q.isEmpty) {
      return;
    }

    /*
    |--------------------------------------------------------------------------
    | Generation
    |--------------------------------------------------------------------------
    |
    | If:
    |
    | "mus" starts searching
    | "music" starts searching
    |
    | and "mus" finishes last, we do not want the old response replacing
    | the newer "music" response.
    |
    */

    final generation =
        ++_searchGeneration;

    setState(() {
      _loading = true;
      _error = "";
      _activeQuery = q;
    });

    try {
      final events =
          await _searchService
              .searchEvents(
        q,
      );

      if (!mounted ||
          generation !=
              _searchGeneration) {
        return;
      }

      setState(() {
        _results = events;
        _loading = false;
      });
    } catch (error) {
      debugPrint(
        "SEARCH SCREEN ERROR: $error",
      );

      if (!mounted ||
          generation !=
              _searchGeneration) {
        return;
      }

      setState(() {
        _results = [];
        _loading = false;
        _error =
            "Unable to search events.";
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Submit Search
  |--------------------------------------------------------------------------
  */

  void _submitSearch(
    String value,
  ) {
    _debounce?.cancel();

    FocusScope.of(context)
        .unfocus();

    _search(value);
  }

  /*
  |--------------------------------------------------------------------------
  | Clear Search
  |--------------------------------------------------------------------------
  */

  void _clearSearch() {
    _debounce?.cancel();

    _searchGeneration++;

    _controller.clear();

    setState(() {
      _results = [];
      _loading = false;
      _error = "";
      _activeQuery = "";
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Open Event
  |--------------------------------------------------------------------------
  */

  void _openEvent(
    Event event,
  ) {
    FocusScope.of(context)
        .unfocus();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            EventDetailsScreen(
          event: event,
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Dispose
  |--------------------------------------------------------------------------
  */

  @override
  void dispose() {
    _debounce?.cancel();

    _controller.dispose();

    super.dispose();
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
    final query =
        _controller.text.trim();

    return Scaffold(
      backgroundColor: AppColors.background,

  /*
|--------------------------------------------------------------------------
| Search Header
|--------------------------------------------------------------------------
*/

appBar: AppBar(
  backgroundColor: AppColors.background,
  elevation: 0,
  titleSpacing: 0,
  title: Container(
    height: 48,
    margin: const EdgeInsets.only(
      right: 16,
    ),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius:
          BorderRadius.circular(
        16,
      ),
      border: Border.all(
        color: AppColors.border,
      ),
    ),
    child: TextField(
      controller:
          _controller,
      autofocus: true,
      style:
          const TextStyle(
        color: AppColors.text,
        fontSize: 15,
      ),
      cursorColor:
          AppColors.primary,
      textInputAction:
          TextInputAction.search,
      onChanged:
          _onSearchChanged,
      onSubmitted:
          _submitSearch,
      decoration:
          InputDecoration(
        border:
            InputBorder.none,
        hintText:
            "Search events, venues...",
        hintStyle:
            const TextStyle(
          color:
              AppColors.textSecondary,
        ),
        prefixIcon:
            const Icon(
          Icons.search,
          color:
              AppColors.textSecondary,
        ),
        suffixIcon:
            query.isNotEmpty
                ? IconButton(
                    onPressed:
                        _clearSearch,
                    icon:
                        const Icon(
                      Icons.close,
                      color:
                          AppColors.textSecondary,
                    ),
                  )
                : null,
      ),
    ),
  ),
),

/*
|--------------------------------------------------------------------------
| Body
|--------------------------------------------------------------------------
*/

body: _buildBody(),
);
}

/*
|--------------------------------------------------------------------------
| Body State
|--------------------------------------------------------------------------
*/

Widget _buildBody() {
  final query =
      _controller.text.trim();

  /*
  |--------------------------------------------------------------------------
  | Empty Search
  |--------------------------------------------------------------------------
  */

  if (query.isEmpty) {
    return const Center(
      child: Padding(
        padding:
            EdgeInsets.all(
          32,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .search_rounded,
              size: 52,
              color:
                  AppColors.textSecondary,
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              "Discover something",
              style:
                  TextStyle(
                color:
                    AppColors.text,
                fontSize: 20,
                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Search for events, venues and experiences.",
              textAlign:
                  TextAlign
                      .center,
              style:
                  TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Loading
  |--------------------------------------------------------------------------
  */

  if (_loading) {
    return const Center(
      child:
          CircularProgressIndicator(
        color:
            AppColors.primary,
      ),
    );
  }

  /*
|--------------------------------------------------------------------------
| Error
|--------------------------------------------------------------------------
*/

if (_error.isNotEmpty) {
  return Center(
    child: Padding(
      padding:
          const EdgeInsets.all(
        32,
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons
                .error_outline_rounded,
            size: 44,
            color:
                AppColors.textSecondary,
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            _error,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  AppColors.text,
              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          FilledButton.icon(
            onPressed: () {
              _search(
                _controller
                    .text,
              );
            },
            icon:
                const Icon(
              Icons.refresh,
            ),
            label:
                const Text(
              "Try Again",
            ),
          ),
        ],
      ),
    ),
  );
}

/*
|--------------------------------------------------------------------------
| No Results
|--------------------------------------------------------------------------
*/

if (_results.isEmpty) {
  return Center(
    child: Padding(
      padding:
          const EdgeInsets.all(
        32,
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons
                .event_busy_outlined,
            size: 48,
            color:
                AppColors.textSecondary,
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            "No events found",
            style:
                TextStyle(
              color:
                  AppColors.text,
              fontSize: 18,
              fontWeight:
                  FontWeight
                      .w600,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            'We couldn\'t find anything for "$_activeQuery".',
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}

/*
|--------------------------------------------------------------------------
| Results
|--------------------------------------------------------------------------
*/

return ListView(
  keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,
  padding:
      const EdgeInsets.fromLTRB(
    20,
    20,
    20,
    40,
  ),
  children: [
      /*
|--------------------------------------------------------------------------
| Result Count
|--------------------------------------------------------------------------
*/

Padding(
  padding:
      const EdgeInsets.only(
    bottom: 16,
  ),
  child: Text(
    "${_results.length} "
    "${_results.length == 1 ? "event" : "events"} found",
    style:
        const TextStyle(
      color:
          AppColors.textSecondary,
      fontSize: 14,
    ),
  ),
),

/*
|--------------------------------------------------------------------------
| Event Results
|--------------------------------------------------------------------------
*/

..._results.map(
  (event) =>
      _EventSearchCard(
    event: event,
    onTap: () =>
        _openEvent(
      event,
    ),
  ),
),
      ],
    );
  }
}

/*
|--------------------------------------------------------------------------
| Search Event Card
|--------------------------------------------------------------------------
*/

class _EventSearchCard
    extends StatelessWidget {
  final Event event;

  final VoidCallback onTap;

  const _EventSearchCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final hasImage =
        event.coverImage !=
            null &&
        event.coverImage!
            .trim()
            .isNotEmpty;

    return Card(
      color: AppColors.card,
      elevation: 0,
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        side: BorderSide(
          color: AppColors.border,
        ),
      ),
      clipBehavior:
          Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(
            12,
          ),
          child: Row(
            children: [
              /*
              |--------------------------------------------------------------------------
              | Image
              |--------------------------------------------------------------------------
              */

              ClipRRect(
                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
                child: SizedBox(
                  width: 78,
                  height: 78,
                  child: hasImage
                      ? Image.network(
                          event
                              .coverImage!,
                          fit: BoxFit
                              .cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const _EventImagePlaceholder();
                          },
                        )
                      : const _EventImagePlaceholder(),
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              /*
              |--------------------------------------------------------------------------
              | Information
              |--------------------------------------------------------------------------
              */

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            AppColors.text,
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          size: 16,
                          color:
                              AppColors.textSecondary,
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Expanded(
                          child: Text(
                            event
                                .venue,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              color:
                                  AppColors.textSecondary,
                              fontSize:
                                  13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              const Icon(
                Icons
                    .chevron_right_rounded,
                color:
                    AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
|--------------------------------------------------------------------------
| Event Image Placeholder
|--------------------------------------------------------------------------
*/

class _EventImagePlaceholder
    extends StatelessWidget {
  const _EventImagePlaceholder();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      color: AppColors.surface,
      alignment:
          Alignment.center,
      child: const Icon(
        Icons
            .event_outlined,
        color:
            AppColors.textSecondary,
        size: 28,
      ),
    );
  }
}