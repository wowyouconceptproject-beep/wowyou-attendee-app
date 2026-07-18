import "package:flutter/material.dart";

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
  final controller =
      TextEditingController();

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
            color:
                const Color(
              0xFF181818,
            ),
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
          child: TextField(
            controller:
                controller,
            autofocus: true,
            style:
                const TextStyle(
              color:
                  Colors.white,
            ),
            decoration:
                const InputDecoration(
              border:
                  InputBorder.none,
              hintText:
                  "Search events...",
              hintStyle:
                  TextStyle(
                color:
                    Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.search,
              ),
            ),
          ),
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(
          24,
        ),
        children: [
          const Text(
            "Recent Searches",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _Chip(
                "Business",
              ),
              _Chip(
                "AI",
              ),
              _Chip(
                "Technology",
              ),
              _Chip(
                "Networking",
              ),
            ],
          ),

          const SizedBox(
            height: 40,
          ),

          const Text(
            "Popular",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _Chip(
                "Startup",
              ),
              _Chip(
                "Music",
              ),
              _Chip(
                "Fashion",
              ),
              _Chip(
                "Sports",
              ),
              _Chip(
                "Food",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip
    extends StatelessWidget {
  final String label;

  const _Chip(
    this.label,
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF181818,
        ),
        borderRadius:
            BorderRadius.circular(
          50,
        ),
      ),
      child: Text(
        label,
      ),
    );
  }
}