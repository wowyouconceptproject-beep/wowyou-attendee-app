import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:url_launcher/url_launcher.dart";

import "../../models/event.dart";
import "../../theme/app_colors.dart";

class EventLocationMap extends StatefulWidget {
  final Event event;

  const EventLocationMap({
    super.key,
    required this.event,
  });

  @override
  State<EventLocationMap> createState() =>
      _EventLocationMapState();
}

class _EventLocationMapState
    extends State<EventLocationMap> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final latitude =
        widget.event.venueLatitude;

    final longitude =
        widget.event.venueLongitude;

    /*
    |--------------------------------------------------------------------------
    | Coordinates unavailable
    |--------------------------------------------------------------------------
    |
    | Existing events may not have coordinates yet.
    | Show the venue information instead of rendering
    | an unusable map.
    |
    */

    if (latitude == null ||
        longitude == null) {
      return _buildLocationFallback();
    }

    final position = LatLng(
      latitude,
      longitude,
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        /*
        |--------------------------------------------------------------------------
        | Section Title
        |--------------------------------------------------------------------------
        */

        const Padding(
          padding:
              EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Text(
            "Location",
            style: TextStyle(
              color: AppColors.text,
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        /*
        |--------------------------------------------------------------------------
        | Google Map
        |--------------------------------------------------------------------------
        */

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 260,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(
                  target: position,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId:
                        const MarkerId(
                      "event-location",
                    ),
                    position:
                        position,
                    infoWindow:
                        InfoWindow(
                      title:
                          widget.event.venue,
                      snippet:
                          widget.event
                                  .venueAddress ??
                              widget.event
                                  .city ??
                              "",
                    ),
                  ),
                },
                myLocationButtonEnabled:
                    false,
                zoomControlsEnabled:
                    false,
                mapToolbarEnabled:
                    false,
                compassEnabled:
                    false,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        /*
        |--------------------------------------------------------------------------
        | Address
        |--------------------------------------------------------------------------
        */

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color:
                    AppColors.primary,
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  _locationText(),
                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        /*
        |--------------------------------------------------------------------------
        | Directions
        |--------------------------------------------------------------------------
        */

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed:
                  _openDirections,
              icon: const Icon(
                Icons.directions_outlined,
              ),
              label: const Text(
                "Get Directions",
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Location Text
  |--------------------------------------------------------------------------
  */

  String _locationText() {
    final parts =
        <String>[
      if (widget.event.venueAddress !=
              null &&
          widget.event.venueAddress!
              .trim()
              .isNotEmpty)
        widget.event.venueAddress!
            .trim(),

      if (widget.event.city !=
              null &&
          widget.event.city!
              .trim()
              .isNotEmpty)
        widget.event.city!.trim(),

      if (widget.event.country !=
              null &&
          widget.event.country!
              .trim()
              .isNotEmpty)
        widget.event.country!.trim(),
    ];

    if (parts.isEmpty) {
      return widget.event.venue;
    }

    return parts.join(", ");
  }

  /*
  |--------------------------------------------------------------------------
  | Location Fallback
  |--------------------------------------------------------------------------
  |
  | Used when an existing event does not yet
  | have latitude/longitude.
  |
  */

  Widget _buildLocationFallback() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(20),
        decoration:
            BoxDecoration(
          color: AppColors.card,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color:
                AppColors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color:
                  AppColors
                      .textSecondary,
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Text(
                _locationText(),
                style:
                    const TextStyle(
                  color:
                      AppColors
                          .textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Open Google Maps Directions
  |--------------------------------------------------------------------------
  */

  Future<void> _openDirections() async {
    final latitude =
        widget.event.venueLatitude;

    final longitude =
        widget.event.venueLongitude;

    if (latitude == null ||
        longitude == null) {
      return;
    }

    final uri = Uri.parse(
      "https://www.google.com/maps/dir/"
      "?api=1"
      "&destination=$latitude,$longitude"
      "&travelmode=driving",
    );

    final opened =
        await launchUrl(
      uri,
      mode:
          LaunchMode
              .externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to open directions.",
          ),
        ),
      );
    }
  }
}