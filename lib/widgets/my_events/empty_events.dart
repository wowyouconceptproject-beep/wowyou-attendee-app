import "package:flutter/material.dart";

class EmptyEvents
    extends StatelessWidget {
  final VoidCallback onDiscover;

  const EmptyEvents({
    super.key,
    required this.onDiscover,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event,
              size: 90,
              color: Color(
                0xFFD4AF37,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(
              "No Events Yet",
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              "Discover amazing experiences happening around you.",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            ElevatedButton(
              onPressed:
                  onDiscover,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFD4AF37,
                ),
                foregroundColor:
                    Colors.black,
              ),
              child: const Text(
                "Discover Events",
              ),
            ),
          ],
        ),
      ),
    );
  }
}