
import "package:flutter/material.dart";

import "../../models/match_card.dart";
import "../../screens/attendee_details_screen.dart";
import "../../services/networking_service.dart";
import "../../theme/app_colors.dart";

class NetworkingMatchCard extends StatefulWidget {
  final MatchCard match;
  final String eventId;

  const NetworkingMatchCard({
    super.key,
    required this.match,
    required this.eventId,
  });

  @override
  State<NetworkingMatchCard> createState() =>
      _NetworkingMatchCardState();
}

class _NetworkingMatchCardState
    extends State<NetworkingMatchCard> {
  final NetworkingService _service = NetworkingService();

  bool _isSending = false;
  bool _requestSent = false;

  MatchCard get match => widget.match;

  Future<void> _sendConnectionRequest() async {
    if (_isSending || _requestSent) return;

    setState(() => _isSending = true);

    try {
      await _service.sendRequest(
        receiverId: match.userId,
        eventId: widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        _requestSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connection request sent successfully"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _viewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendeeDetailsScreen(
          attendee: match,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = match.initials;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ATTENDEE INFORMATION
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  backgroundImage: match.hasAvatar
                      ? NetworkImage(match.avatar!)
                      : null,
                  child: !match.hasAvatar
                      ? Text(
                          initials.isNotEmpty ? initials : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.fullName,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      if (match.profession != null &&
                          match.profession!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            match.profession!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                      if (match.company != null &&
                          match.company!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            match.company!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // MATCH SCORE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "MATCH",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "${match.score}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // AI INSIGHT
            if (match.explanation != null &&
                match.explanation!.isNotEmpty) ...[
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "AI Insight",
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      match.explanation!,
                      style: const TextStyle(
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // MATCH REASONS
            if (match.reasons.isNotEmpty) ...[
              const SizedBox(height: 20),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: match.reasons.map((reason) {
                  return Chip(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    label: Text(
                      reason.message,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // CONNECTION REQUEST
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    _isSending || _requestSent
                        ? null
                        : _sendConnectionRequest,
                icon: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        _requestSent
                            ? Icons.check_circle_outline
                            : Icons.person_add_alt_1,
                      ),
                label: Text(
                  _isSending
                      ? "Sending Request..."
                      : _requestSent
                          ? "Request Sent"
                          : "Connect",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.65),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // VIEW PROFILE
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _viewProfile,
                icon: const Icon(Icons.person_outline),
                label: const Text("View Profile"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.text,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

