import "package:flutter/material.dart";

import "../../models/event.dart";
import "../../services/search_service.dart";

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
  final TextEditingController controller =
      TextEditingController();

  final SearchService _searchService =
      SearchService();

  List<Event> _results = [];

  bool _loading = false;

  Future<void> _search(
    String query,
  ) async {
    final q = query.trim();

    if (q.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    final events =
        await _searchService.searchEvents(
      q,
    );

    if (!mounted) return;

    setState(() {
      _results = events;
      _loading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(
              0xFF181818,
            ),
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            textInputAction:
                TextInputAction.search,
            onChanged: _search,
            onSubmitted: _search,
            decoration:
                const InputDecoration(
              border: InputBorder.none,
              hintText:
                  "Search events...",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.search,
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : controller.text.trim().isEmpty
              ? const Center(
                  child: Text(
                    "Search for events",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                )
              : _results.isEmpty
                  ? const Center(
                      child: Text(
                        "No events found",
                        style: TextStyle(
                          color:
                              Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),
                      itemCount:
                          _results.length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final event =
                            _results[
                                index];

                        return Card(
                          color:
                              const Color(
                            0xFF181818,
                          ),
                          margin:
                              const EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: ListTile(
                            leading:
                                event.coverImage !=
                                            null &&
                                        event
                                            .coverImage!
                                            .isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                          8,
                                        ),
                                        child:
                                            Image.network(
                                          event.coverImage!,
                                          width:
                                              60,
                                          height:
                                              60,
                                          fit: BoxFit
                                              .cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons
                                            .event,
                                      ),
                            title: Text(
                              event.title,
                            ),
                            subtitle:
                                Text(
                              event.venue,
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}