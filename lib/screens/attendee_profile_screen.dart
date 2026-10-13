import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../services/attendee_profile_service.dart';
import '../../theme/app_colors.dart';

class AttendeeProfileScreen extends StatefulWidget {
  const AttendeeProfileScreen({super.key});

  @override
  State<AttendeeProfileScreen> createState() =>
      _AttendeeProfileScreenState();
}

class _AttendeeProfileScreenState
    extends State<AttendeeProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _professionController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _industryController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _bioController = TextEditingController();

  final AttendeeProfileService _profileService =
      AttendeeProfileService();

  bool loading = false;

  final List<String> _selectedGoals = [];
  final List<String> _selectedSkills = [];

  static const List<String> _goals = [
    'Networking',
    'Hiring',
    'Looking for Work',
    'Seeking Investors',
    'Investing',
    'Learning',
    'Mentorship',
    'Sales',
    'Partnership',
  ];

  static const List<String> _skills = [
    'Software',
    'AI',
    'Marketing',
    'Finance',
    'Design',
    'Product',
    'Legal',
    'Sales',
    'Cybersecurity',
    'Cloud',
    'Data',
    'HR',
  ];

  Color get _mutedText =>
      AppColors.text.withValues(alpha: 0.65);

  Color get _subtleBorder =>
      AppColors.border;

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();
    final token = auth.token;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your session has expired. Please login again.',
          ),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final success = await _profileService.createProfile(
        token: token,
        profession: _professionController.text.trim(),
        industry: _industryController.text.trim(),
        company: _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        bio: _bioController.text.trim(),
        goals: _selectedGoals,
        skills: _selectedSkills,
      );

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile.'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile completed successfully.'),
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
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

  Widget _sectionHeading({
    required String title,
    required String subtitle,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryLight,
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _mutedText,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool requiredField = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (requiredField) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const SizedBox(width: 7),
                Text(
                  'Optional',
                  style: TextStyle(
                    color: _mutedText,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            textCapitalization: maxLines > 1
                ? TextCapitalization.sentences
                : TextCapitalization.words,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
            ),
            cursorColor: AppColors.primaryLight,
            validator: requiredField
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '$label is required.';
                    }
                    return null;
                  }
                : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: _mutedText,
                fontSize: 13,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  bottom: maxLines > 1 ? 65 : 0,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryLight,
                  size: 19,
                ),
              ),
              alignLabelWithHint: true,
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: _subtleBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: _subtleBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> items,
    required List<String> selected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeading(
          title: title,
          subtitle: subtitle,
          icon: icon,
        ),
        const SizedBox(height: 2),
        Wrap(
          spacing: 9,
          runSpacing: 10,
          children: items.map((item) {
            final isSelected = selected.contains(item);

            return FilterChip(
              label: Text(item),
              selected: isSelected,
              showCheckmark: false,
              onSelected: loading
                  ? null
                  : (value) {
                      setState(() {
                        if (value) {
                          if (!selected.contains(item)) {
                            selected.add(item);
                          }
                        } else {
                          selected.remove(item);
                        }
                      });
                    },
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : _mutedText,
                fontSize: 12,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
              backgroundColor: AppColors.card,
              selectedColor: AppColors.primary,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : _subtleBorder,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 7,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _subtleBorder),
      ),
      child: child,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Your profile',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: loading
              ? null
              : () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(23),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.16),
                        AppColors.surface,
                        AppColors.surface,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primaryLight,
                          size: 27,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Complete your profile',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 27,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Introduce yourself to the WowYou community. '
                        'Help us connect you with the right people, '
                        'events and opportunities.',
                        style: TextStyle(
                          color: _mutedText,
                          fontSize: 14,
                          height: 1.65,
                        ),
                      ),
                      const SizedBox(height: 19),
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.primaryLight,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'A better profile means better connections.',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeading(
                        title: 'Professional details',
                        subtitle:
                            'Tell people what you do and where you work.',
                        icon: Icons.work_outline_rounded,
                      ),
                      _field(
                        controller: _professionController,
                        label: 'Profession',
                        hint: 'e.g. Software Engineer',
                        icon: Icons.badge_outlined,
                        requiredField: true,
                      ),
                      _field(
                        controller: _jobTitleController,
                        label: 'Job title',
                        hint: 'e.g. Senior Product Designer',
                        icon: Icons.workspace_premium_outlined,
                      ),
                      _field(
                        controller: _companyController,
                        label: 'Company',
                        hint: 'e.g. Your company name',
                        icon: Icons.business_outlined,
                      ),
                      _field(
                        controller: _industryController,
                        label: 'Industry',
                        hint: 'e.g. Technology',
                        icon: Icons.domain_outlined,
                        requiredField: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _chipSection(
                        title: 'Your networking goals',
                        subtitle:
                            'Select what you want to achieve at events.',
                        icon: Icons.hub_outlined,
                        items: _goals,
                        selected: _selectedGoals,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _chipSection(
                        title: 'Your skills',
                        subtitle:
                            'Choose the areas you know or work in.',
                        icon: Icons.psychology_outlined,
                        items: _skills,
                        selected: _selectedSkills,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeading(
                        title: 'About you',
                        subtitle:
                            'Add a little more detail to your profile.',
                        icon: Icons.person_pin_outlined,
                      ),
                      _field(
                        controller: _linkedinController,
                        label: 'LinkedIn profile',
                        hint: 'https://linkedin.com/in/yourprofile',
                        icon: Icons.link_rounded,
                        keyboardType: TextInputType.url,
                      ),
                      _field(
                        controller: _bioController,
                        label: 'Short bio',
                        hint:
                            'What do you do? What are you passionate about?',
                        icon: Icons.notes_rounded,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: loading ? null : saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Complete profile',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 19,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Your information helps improve networking and '
                      'attendee recommendations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _mutedText,
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}