import "package:flutter/material.dart";

import "../services/attendee_profile_service.dart";
import "../utils/storage.dart";

class AttendeeProfileScreen extends StatefulWidget {
  const AttendeeProfileScreen({
    super.key,
  });

  @override
  State<AttendeeProfileScreen> createState() =>
      _AttendeeProfileScreenState();
}

class _AttendeeProfileScreenState
    extends State<AttendeeProfileScreen> {
  final _professionController =
      TextEditingController();

  final _jobTitleController =
      TextEditingController();

  final _companyController =
      TextEditingController();

  final _industryController =
      TextEditingController();

  final _linkedinController =
      TextEditingController();

  final _bioController =
      TextEditingController();

  final AttendeeProfileService
      _profileService =
          AttendeeProfileService();

  bool loading = false;

  final List<String> _selectedGoals = [];

  final List<String> _selectedSkills = [];

  static const List<String> _goals = [
    "Networking",
    "Hiring",
    "Looking for Work",
    "Seeking Investors",
    "Investing",
    "Learning",
    "Mentorship",
    "Sales",
    "Partnership",
  ];

  static const List<String> _skills = [
    "Software",
    "AI",
    "Marketing",
    "Finance",
    "Design",
    "Product",
    "Legal",
    "Sales",
    "Cybersecurity",
    "Cloud",
    "Data",
    "HR",
  ];

  Future<void> saveProfile() async {
    if (_professionController.text
            .trim()
            .isEmpty ||
        _industryController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Profession and Industry are required.",
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final token =
          await Storage.getToken();

      if (token == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              "Please login again.",
            ),
          ),
        );

        return;
      }

      final success =
          await _profileService
              .createProfile(
        token: token,

        profession:
            _professionController.text
                .trim(),

        industry:
            _industryController.text
                .trim(),

        company:
            _companyController.text
                .trim(),

        jobTitle:
            _jobTitleController.text
                .trim(),

        linkedin:
            _linkedinController.text
                .trim(),

        bio:
            _bioController.text
                .trim(),

        goals: _selectedGoals,

        skills: _selectedSkills,
      );

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to save profile.",
            ),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile completed successfully.",
          ),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        "/home",
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget field({
    required TextEditingController
        controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 20,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration:
            InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget chipSection({
    required String title,
    required List<String> items,
    required List<String> selected,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map(
              (item) {
                return FilterChip(
                  label: Text(item),

                  selected:
                      selected.contains(
                    item,
                  ),

                  onSelected:
                      (value) {
                    setState(() {
                      if (value) {
                        selected.add(
                          item,
                        );
                      } else {
                        selected
                            .remove(
                          item,
                        );
                      }
                    });
                  },
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _professionController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _industryController.dispose();
    _linkedinController.dispose();
    _bioController.dispose();

    super.dispose();
  }

    @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const SizedBox(
                height: 20,
              ),

              const Text(
                "Complete Your Profile",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                "Help WowYou introduce you to the right people, recommend relevant sessions and create better networking opportunities.",
                style: TextStyle(
                  color:
                      Colors.white70,
                  height: 1.6,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              field(
                controller:
                    _professionController,
                label:
                    "Profession",
                hint:
                    "Software Engineer",
              ),

              field(
                controller:
                    _jobTitleController,
                label:
                    "Job Title",
                hint:
                    "Senior Product Designer",
              ),

              field(
                controller:
                    _companyController,
                label:
                    "Company",
                hint:
                    "OpenAI",
              ),

              field(
                controller:
                    _industryController,
                label:
                    "Industry",
                hint:
                    "Artificial Intelligence",
              ),

              chipSection(
                title:
                    "What are you hoping to achieve?",
                items: _goals,
                selected:
                    _selectedGoals,
              ),

              chipSection(
                title:
                    "Your Skills",
                items: _skills,
                selected:
                    _selectedSkills,
              ),

              field(
                controller:
                    _linkedinController,
                label:
                    "LinkedIn (Optional)",
                hint:
                    "https://linkedin.com/in/yourprofile",
              ),

              field(
                controller:
                    _bioController,
                label:
                    "Short Bio",
                hint:
                    "Tell attendees about yourself...",
                maxLines: 5,
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width:
                    double.infinity,
                height: 56,
                child:
                    ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : saveProfile,
                  child:
                      loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2.5,
                              ),
                            )
                          : const Text(
                              "Complete Profile",
                            ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Center(
                child: Text(
                  "This information is only used to improve networking and attendee recommendations.",
                  textAlign:
                      TextAlign.center,
                  style:
                      TextStyle(
                    color: Colors
                        .grey.shade500,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}