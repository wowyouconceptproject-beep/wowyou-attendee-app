import "package:flutter/material.dart";

import "../../theme/app_colors.dart";
import "legal_policies_screen.dart";

class PolicyDocumentScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final PolicyType type;

  const PolicyDocumentScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  String get _policyVersion {
    switch (type) {
      case PolicyType.terms:
      case PolicyType.privacy:
      case PolicyType.refund:
      case PolicyType.acceptableUse:
      case PolicyType.ai:
      case PolicyType.vendor:
      case PolicyType.subprocessors:
      case PolicyType.dpa:
        return "v1.0";
    }
  }

  String get _effectiveDate {
    return "August 2026";
  }

  String get _content {
    switch (type) {
      case PolicyType.terms:
        return _terms;

      case PolicyType.privacy:
        return _privacy;

      case PolicyType.refund:
        return _refund;

      case PolicyType.acceptableUse:
        return _acceptableUse;

      case PolicyType.ai:
        return _ai;

      case PolicyType.vendor:
        return _vendor;

      case PolicyType.subprocessors:
        return _subprocessors;

      case PolicyType.dpa:
        return _dpa;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          22,
          20,
          22,
          48,
        ),
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            "Version $_policyVersion • Effective $_effectiveDate",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const Divider(
            height: 36,
          ),

          _PolicyContent(
            content: _content,
          ),

          const SizedBox(
            height: 40,
          ),

          const Divider(),

          const SizedBox(
            height: 20,
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

  static const String _terms = """
TERMS OF SERVICE

1. Introduction

These Terms of Service govern your access to and use of WoWYou EventTech / EventOS, including our websites, mobile applications, event registration systems, ticketing services, digital passes, check-in tools, attendee engagement features, networking tools, AI-powered features, analytics, marketplace services and related technology.

By creating an account, registering for an event, purchasing a ticket, creating an event, using the EventOS mobile application or otherwise using the platform, you agree to these Terms.

If you do not agree with these Terms, you must not use EventOS.

2. Who These Terms Apply To

These Terms apply to event organisers, attendees, vendors, sponsors, exhibitors, speakers, corporate and enterprise customers, public sector organisations, community organisations, platform administrators and other users of EventOS.

3. About EventOS

EventOS is an event operating system designed to help organisations plan, manage, deliver and measure events.

Features may include event planning, registration, ticketing, digital tickets and QR passes, secure check-in, attendee engagement, networking, AI recommendations, vendor and sponsor management, analytics and event communications.

4. Your Account

You must provide accurate and current information when creating an account.

You are responsible for keeping your login credentials secure, all activity performed through your account, maintaining accurate information and reporting suspected unauthorised access.

5. Organiser Responsibilities

Organisers are responsible for ensuring that their events are lawful, properly authorised and accurately represented.

Organisers must comply with applicable consumer protection, advertising, tax, health and safety, accessibility, venue, licensing and data protection requirements.

6. Attendee Responsibilities

Attendees must provide accurate registration information, follow event and venue rules, use tickets and QR codes only as authorised and behave respectfully towards other users.

7. Tickets, Payments and Refunds

EventOS may support free and paid events.

Where an organiser is responsible for an event, the organiser remains responsible for the event, its delivery, cancellations and refund decisions unless WoWYou Concepts Ltd is expressly acting as the organiser.

8. AI Features

EventOS may use AI for planning, recommendations, networking, analytics, content generation and automation.

AI outputs can be inaccurate or incomplete. Users remain responsible for reviewing and validating AI-generated content and recommendations.

9. User Content

You retain ownership of content you upload.

You grant WoWYou Concepts Ltd the rights necessary to host, process, display, transmit and use that content to provide EventOS.

10. Intellectual Property

EventOS, its software, interface, workflows, designs, branding, databases, AI systems, documentation and technology are owned by or licensed to WoWYou Concepts Ltd.

11. Acceptable Use

You must not use EventOS for illegal activity, fraud, abuse, harassment, discrimination, malware, phishing, unauthorised access, data misuse, intellectual property infringement, spam or ticket fraud.

12. Data Protection

Personal data is handled according to our Privacy Policy.

Depending on the activity, WoWYou Concepts Ltd may act as a data controller or data processor acting on behalf of an event organiser.

13. Availability and Security

We aim to provide a reliable service but cannot guarantee uninterrupted or error-free availability.

We use reasonable technical and organisational measures to protect the platform, but no online system is completely secure.

14. Suspension and Termination

We may suspend or terminate accounts where users breach these Terms, fail to pay applicable fees, misuse the platform or create legal, security or reputational risk.

15. Governing Law

These Terms are governed by the laws of Ireland, subject to mandatory consumer protection rights and other applicable laws.

16. Contact

WoWYou Concepts Ltd

enquiries@wowyouconcepts.com
""";

  static const String _privacy = """
PRIVACY POLICY

1. Introduction

WoWYou Concepts Ltd respects your privacy.

This Privacy Policy explains how we collect, use, store, share and protect personal data when you use EventOS.

2. Who We Are

WoWYou Concepts Ltd operates WoWYou EventTech / EventOS.

For some activities, we act as a data controller.

Where an event organiser uses EventOS to manage attendee data, we may act as a data processor on behalf of that organiser.

3. Information We Collect

Depending on how you use EventOS, we may process account information, event registration information, ticket and check-in information, payment information, technical information, communications and information relating to AI features.

4. How We Use Personal Data

We may use personal data to create and manage accounts, register attendees, issue tickets and QR passes, provide check-in, support networking, provide AI features, send event communications, process payments, provide support, improve security, detect fraud, provide analytics and meet legal obligations.

5. Legal Bases

Where GDPR or UK GDPR applies, processing may be based on contract, consent, legal obligation, legitimate interests or explicit consent where required.

6. AI

EventOS may use AI for event planning, recommendations, networking, analytics, reporting and automation.

AI should not be used to make solely automated decisions producing legal or similarly significant effects without appropriate safeguards.

7. Cookies

We may use cookies and similar technologies for essential functionality, login and security, preferences, analytics, performance and marketing.

8. Who We Share Data With

Personal data may be shared with event organisers, payment providers, cloud providers, email providers, analytics providers, security providers, AI providers, support providers, professional advisers and authorities where legally required.

We do not sell your personal data.

9. International Transfers

Where personal data is transferred internationally, we use appropriate safeguards where required.

10. Data Retention

We retain personal data only for as long as reasonably necessary for providing EventOS, supporting events, business records, legal obligations, dispute resolution, security and fraud prevention.

11. Security

We use appropriate technical and organisational measures including access controls, authentication, encryption where appropriate, monitoring, secure development and backups.

12. Your Rights

Depending on applicable law, you may have rights to access, correct, delete, restrict, object to processing, request portability, withdraw consent and complain to a data protection authority.

13. Marketing

You can unsubscribe from marketing communications at any time.

We do not sell personal data.

14. Children

EventOS is not intended by default for children under 16.

15. Contact

WoWYou Concepts Ltd

enquiries@wowyouconcepts.com
""";

  static const String _refund = """
REFUND & CANCELLATION POLICY

1. Purpose

This policy explains how EventOS handles refunds, cancellations, postponements, rescheduled events and ticket transfers.

2. Who Is Responsible for the Event?

Unless WoWYou Concepts Ltd is expressly identified as the event organiser, the event organiser is responsible for the event and its refund policy.

3. Refund Principles

Refund terms should be clear, visible before checkout and easy to understand.

Mandatory consumer rights are not removed by a "no refunds" policy.

4. Event Refund Settings

Organisers may use flexible, moderate, strict or custom refund terms.

5. Cancelled Events

If an event is cancelled, attendees may be entitled to a refund, transfer, credit or another lawful remedy.

6. Postponed Events

If an event is postponed, attendees should be informed of material changes and given any refund rights required by applicable law.

7. Material Changes

Material changes may include significant changes to the date, venue, format, main speaker or performer, ticket category or core event experience.

8. No-Shows

Refunds are generally not available simply because an attendee does not attend, arrives late or fails to use their ticket, subject to applicable law.

9. Ticket Transfers and Resale

Organisers determine whether tickets are transferable.

Unauthorised resale, counterfeit tickets, ticket scraping and automated bulk purchasing may result in cancellation.

10. Refund Timing

Approved refunds will normally be processed without undue delay and according to applicable legal and payment-provider requirements.

11. Chargebacks and Fraud

EventOS may investigate chargebacks, fraudulent refund requests, counterfeit tickets, payment fraud and suspicious transactions.

12. Contact

For event-specific refund disputes, contact the organiser.

For platform issues:

enquiries@wowyouconcepts.com
""";

  static const String _acceptableUse = """
ACCEPTABLE USE POLICY

1. Purpose

EventOS must be used lawfully, safely and respectfully.

2. General Conduct

Users must provide accurate information, respect other users, follow event and venue rules, use tickets and credentials correctly and report suspected abuse or fraud.

3. Prohibited Activities

You must not use EventOS for illegal activity, fraud, fake events, fake tickets, impersonation, phishing, harassment, threats, hate or discrimination, exploitation, unlawful surveillance, intellectual property infringement or privacy violations.

4. Organisers

Organisers must ensure events are lawful, information is accurate, required licences exist, pricing and fees are clear, refund terms are published and attendee data is lawfully processed.

5. Vendors

Vendors must provide accurate listings, offer lawful services, maintain required licences and insurance and deliver services professionally.

6. Platform Security

You must not access accounts without permission, bypass authentication or payment controls, introduce malware, attack infrastructure, scrape data without permission, reverse engineer the platform or abuse APIs.

7. AI

AI must not be used to generate harmful or illegal content, discriminate, manipulate users, create deceptive impersonations, process sensitive information without lawful authority or bypass security controls.

8. Payments

Users must not use stolen payment information, create fake events, commit payment fraud, manipulate refunds or circumvent platform fees.

9. Data Protection

Users must only collect and use personal data lawfully.

10. Enforcement

WoWYou may warn users, remove content, restrict accounts, suspend accounts, cancel events, freeze payouts, remove vendors or terminate accounts.

11. Contact

enquiries@wowyouconcepts.com
""";

  static const String _ai = """
AI USAGE POLICY

1. Purpose

EventOS uses AI to assist users with event planning, recommendations, networking, analytics, communications and other event workflows.

AI is designed to assist people, not replace accountable human judgement.

2. AI Features

AI features may include AI Event Planner, AI Marketing Assistant, AI Attendee Matching, AI Event Assistant, AI Analytics, AI Sponsor Intelligence and AI Operations Alerts.

3. Transparency

Where AI is used, EventOS may display labels such as "AI-assisted", "Generated by EventOS AI" or "Suggested by EventOS AI".

4. Human Oversight

AI outputs must be reviewed before important operational, public or commercial use.

5. AI Limitations

AI outputs may be incorrect, incomplete, outdated, biased or inappropriate.

6. Prohibited AI Uses

Users must not use EventOS AI to generate illegal content, discriminate, create deceptive impersonations, make significant automated decisions without safeguards, conduct unlawful surveillance or generate malware or phishing.

7. Personal Data and AI

Users should only submit information necessary for the AI feature.

Do not submit passwords, private keys, payment card information or unnecessary sensitive data.

8. AI Networking

AI networking may suggest connections based on profile information, interests, event activity, session choices and networking preferences.

9. AI Analytics

AI analytics may summarise attendance, engagement, feedback, networking activity, sponsor visibility and event performance.

10. Reporting AI Problems

Users can report AI outputs that are incorrect, unsafe, biased, discriminatory, harmful or inappropriate.

11. Contact

enquiries@wowyouconcepts.com
""";

  static const String _vendor = """
MARKETPLACE VENDOR TERMS

1. Marketplace

EventOS allows approved vendors to list and offer event-related products and services.

Unless expressly stated otherwise, WoWYou provides the technology platform and is not the supplier of independent vendor services.

2. Vendor Eligibility

Vendors may be required to provide legal business information, registration information, tax information, insurance, licences, qualifications, bank details and service information.

3. Vendor Listings

Listings must accurately describe services, pricing, availability, location, duration, inclusions, exclusions, additional charges and cancellation terms.

4. Pricing

Vendors must display lawful and transparent pricing and are responsible for applicable taxes.

5. Payments and Payouts

WoWYou may delay or withhold payouts where there is fraud risk, chargeback risk, refund exposure, verification issues, legal risk or breach of terms.

6. Service Delivery

Vendors must deliver services professionally, arrive on time, provide appropriate staff and equipment, follow venue rules and honour accepted bookings.

7. Licences and Insurance

Vendors are responsible for maintaining all licences, permits, qualifications, insurance and approvals required for their services.

8. Data Protection

Vendors must use EventOS data only for authorised purposes, protect personal data and not sell or scrape attendee information.

9. Marketing

Vendor marketing must be truthful and comply with applicable advertising and privacy laws.

10. Suspension

WoWYou may suspend or remove vendors where there is serious misconduct, fraud, safety risk, legal risk, repeated complaints or failure to deliver.

11. Contact

enquiries@wowyouconcepts.com
""";

  static const String _subprocessors = """
SUB-PROCESSORS

WoWYou Concepts Ltd uses selected third-party service providers to operate EventOS.

These providers may assist with:

• Hosting
• Databases
• Payments
• Email
• Analytics
• AI
• Authentication
• Customer support
• Notifications
• Security

The production sub-processor list will identify each provider, the service provided, categories of data processed, processing location and applicable transfer safeguards.

This list is maintained separately and updated when providers are added, removed or replaced.

For questions about sub-processors:

enquiries@wowyouconcepts.com
""";

  static const String _dpa = """
DATA PROCESSING AGREEMENT

1. Purpose

This Data Processing Agreement applies where WoWYou Concepts Ltd processes personal data on behalf of an organiser or enterprise customer.

2. Roles

The customer acts as controller and WoWYou acts as processor where WoWYou processes customer data on the customer's behalf.

3. Processing Instructions

WoWYou processes personal data only in accordance with documented instructions and the applicable agreement.

4. Security

WoWYou maintains appropriate technical and organisational measures designed to protect personal data.

5. Confidentiality

Personnel authorised to process personal data are subject to appropriate confidentiality obligations.

6. Sub-processors

WoWYou may engage approved sub-processors subject to appropriate contractual and data protection safeguards.

7. International Transfers

International transfers are subject to appropriate legal safeguards where required.

8. Data Subject Requests

WoWYou will provide reasonable assistance to the customer in responding to data subject requests where required.

9. Data Breaches

WoWYou will notify the customer of applicable personal data breaches in accordance with the agreed contractual and legal requirements.

10. Data Deletion

At the end of the applicable service, personal data will be returned or deleted in accordance with the agreement and applicable law.

11. Audits

WoWYou will provide appropriate information necessary to demonstrate compliance with applicable processor obligations, subject to reasonable conditions.

12. Contact

WoWYou Concepts Ltd

enquiries@wowyouconcepts.com
""";
}

class _PolicyContent extends StatelessWidget {
  final String content;

  const _PolicyContent({
    required this.content,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final lines = content
        .trim()
        .split("\n");

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: lines.map((line) {
        final text = line.trim();

        if (text.isEmpty) {
          return const SizedBox(
            height: 12,
          );
        }

        final isHeading =
            RegExp(r"^\d+\.")
                .hasMatch(text) ||
            text == "TERMS OF SERVICE" ||
            text == "PRIVACY POLICY" ||
            text ==
                "REFUND & CANCELLATION POLICY" ||
            text ==
                "ACCEPTABLE USE POLICY" ||
            text ==
                "AI USAGE POLICY" ||
            text ==
                "MARKETPLACE VENDOR TERMS" ||
            text == "SUB-PROCESSORS" ||
            text ==
                "DATA PROCESSING AGREEMENT";

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.text,
              fontSize: isHeading
                  ? 17
                  : 14.5,
              height: 1.65,
              fontWeight: isHeading
                  ? FontWeight.w700
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}