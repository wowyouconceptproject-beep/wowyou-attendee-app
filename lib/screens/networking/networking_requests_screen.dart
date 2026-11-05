
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../providers/networking_provider.dart";
import "../../theme/app_colors.dart";

class NetworkingRequestsScreen extends StatefulWidget {
  const NetworkingRequestsScreen({super.key});

  @override
  State<NetworkingRequestsScreen> createState() =>
      _NetworkingRequestsScreenState();
}

class _NetworkingRequestsScreenState
    extends State<NetworkingRequestsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<NetworkingProvider>()
          .loadIncomingRequests();
    });
  }

  Future<void> _refresh() async {
    await context
        .read<NetworkingProvider>()
        .loadIncomingRequests();
  }

  Future<void> _accept(String requestId) async {
    final provider = context.read<NetworkingProvider>();

    final success =
        await provider.acceptRequest(requestId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Connection accepted"
              : "Unable to accept connection",
        ),
      ),
    );
  }

  Future<void> _reject(String requestId) async {
    final provider = context.read<NetworkingProvider>();

    final success =
        await provider.rejectRequest(requestId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Connection request declined"
              : "Unable to decline request",
        ),
      ),
    );
  }

  String _readString(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return "";
  }

  Map<String, dynamic> _requester(
    Map<String, dynamic> request,
  ) {
    final requester = request["requester"];

    if (requester is Map) {
      return Map<String, dynamic>.from(requester);
    }

    final user = request["user"];

    if (user is Map) {
      return Map<String, dynamic>.from(user);
    }

    return request;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Connection Requests"),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: Consumer<NetworkingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingRequests &&
              provider.incomingRequests.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null &&
              provider.incomingRequests.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.incomingRequests.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Icon(
                    Icons.people_outline,
                    size: 72,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "No connection requests yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "When attendees want to connect with you, "
                        "their requests will appear here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.incomingRequests.length,
              itemBuilder: (context, index) {
                final request =
                    provider.incomingRequests[index];

                final sender = _requester(request);

                final requestId = _readString(
                  request,
                  ["id", "requestId"],
                );

                final firstName = _readString(
                  sender,
                  ["firstName", "firstname"],
                );

                final lastName = _readString(
                  sender,
                  ["lastName", "lastname"],
                );

                final name = _readString(
                  sender,
                  ["fullName", "name"],
                ).isNotEmpty
                    ? _readString(
                        sender,
                        ["fullName", "name"],
                      )
                    : "$firstName $lastName".trim();

                final profession = _readString(
                  sender,
                  ["profession", "jobTitle"],
                );

                final company = _readString(
                  sender,
                  ["company"],
                );

                final avatar = _readString(
                  sender,
                  ["avatar", "avatarUrl", "profileImage"],
                );

                return _RequestCard(
                  name: name.isEmpty ? "Attendee" : name,
                  profession: profession,
                  company: company,
                  avatar: avatar,
                  onAccept: requestId.isEmpty
                      ? null
                      : () => _accept(requestId),
                  onReject: requestId.isEmpty
                      ? null
                      : () => _reject(requestId),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String name;
  final String profession;
  final String company;
  final String avatar;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _RequestCard({
    required this.name,
    required this.profession,
    required this.company,
    required this.avatar,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(" ").map((e) => e.isNotEmpty
            ? e[0].toUpperCase()
            : "").take(2).join()
        : "?";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                backgroundImage: avatar.isNotEmpty
                    ? NetworkImage(avatar)
                    : null,
                child: avatar.isEmpty
                    ? Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (profession.isNotEmpty)
                      Text(
                        profession,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (company.isNotEmpty)
                      Text(
                        company,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Accept"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Decline"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
