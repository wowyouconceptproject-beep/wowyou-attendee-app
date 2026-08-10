import "package:flutter/material.dart";

import "../../theme/app_colors.dart";
import "policy_document_screen.dart";

class LegalPoliciesScreen extends StatelessWidget {
  const LegalPoliciesScreen({
    super.key,
  });

  void _openPolicy(
    BuildContext context, {
    required String title,
    required String subtitle,
    required PolicyType type,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PolicyDocumentScreen(
          title: title,
          subtitle: subtitle,
          type: type,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Legal & Policies",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        children: [
          const Text(
            "Legal & Policies",
            style: TextStyle(
              color: AppColors.text,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            "Review the policies that govern your use of WowYou Event Technology.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 28,
          ),

          _PolicyTile(
            title: "Terms of Service",
            subtitle:
                "The rules governing your use of EventOS.",
            icon: Icons.description_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Terms of Service",
              subtitle:
                  "Rules governing your use of EventOS",
              type: PolicyType.terms,
            ),
          ),

          _PolicyTile(
            title: "Privacy Policy",
            subtitle:
                "How we collect, use and protect personal data.",
            icon: Icons.privacy_tip_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Privacy Policy",
              subtitle:
                  "How EventOS handles personal data",
              type: PolicyType.privacy,
            ),
          ),

          _PolicyTile(
            title: "Refund & Cancellation",
            subtitle:
                "Ticket refunds, cancellations and postponements.",
            icon: Icons.receipt_long_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Refund & Cancellation",
              subtitle:
                  "Refunds and event cancellations",
              type: PolicyType.refund,
            ),
          ),

          _PolicyTile(
            title: "Acceptable Use",
            subtitle:
                "Rules for safe and responsible use of EventOS.",
            icon: Icons.security_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Acceptable Use",
              subtitle:
                  "Safe and responsible platform use",
              type: PolicyType.acceptableUse,
            ),
          ),

          _PolicyTile(
            title: "AI Usage Policy",
            subtitle:
                "How EventOS AI works and its limitations.",
            icon: Icons.auto_awesome_outlined,
            onTap: () => _openPolicy(
              context,
              title: "AI Usage Policy",
              subtitle:
                  "AI features, safeguards and limitations",
              type: PolicyType.ai,
            ),
          ),

          _PolicyTile(
            title: "Marketplace Vendor Terms",
            subtitle:
                "Terms for vendors using the EventOS marketplace.",
            icon: Icons.storefront_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Marketplace Vendor Terms",
              subtitle:
                  "Rules for EventOS marketplace vendors",
              type: PolicyType.vendor,
            ),
          ),

          _PolicyTile(
            title: "Sub-processors",
            subtitle:
                "Third-party services used to operate EventOS.",
            icon: Icons.cloud_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Sub-processors",
              subtitle:
                  "Services used to operate EventOS",
              type: PolicyType.subprocessors,
            ),
          ),

          _PolicyTile(
            title: "Data Processing Agreement",
            subtitle:
                "For organisers and enterprise customers.",
            icon: Icons.gavel_outlined,
            onTap: () => _openPolicy(
              context,
              title: "Data Processing Agreement",
              subtitle:
                  "For organisers and enterprise customers",
              type: PolicyType.dpa,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          const Center(
            child: Text(
              "WoWYou Concepts Ltd\n"
              "enquiries@wowyouconcepts.com",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PolicyTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary
                .withValues(alpha: 0.10),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(
            subtitle,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}

enum PolicyType {
  terms,
  privacy,
  refund,
  acceptableUse,
  ai,
  vendor,
  subprocessors,
  dpa,
}