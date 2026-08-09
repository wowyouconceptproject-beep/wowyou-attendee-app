import "package:shared_preferences/shared_preferences.dart";

class Storage {
  static const String tokenKey =
      "auth_token";

  static const String
      _policyConsentVersionKey =
      "policy_consent_version";

  static Future<void> saveToken(
    String token,
  ) async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      tokenKey,
      token,
    );
  }

  static Future<String?>
      getToken() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      tokenKey,
    );
  }

  static Future<void> clearToken()
      async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
      tokenKey,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Legal Policy Consent
  |--------------------------------------------------------------------------
  */

  static Future<void>
      setPolicyConsent({
    required String version,
  }) async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      _policyConsentVersionKey,
      version,
    );
  }

  static Future<String?>
      getPolicyConsentVersion()
      async {
    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      _policyConsentVersionKey,
    );
  }
}