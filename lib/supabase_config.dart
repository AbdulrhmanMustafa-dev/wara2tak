// Supabase Configuration
// Values are loaded from .env file at runtime using flutter_dotenv
// Get your credentials from: https://supabase.com/dashboard/project/_/settings/api

import 'package:flutter/foundation.dart';

class SupabaseConfig {
  // Supabase Project URL (e.g., https://your-project.supabase.co)
  static const String supabaseUrl = 'https://gofycnzmutyborktxryo.supabase.co';

  // Supabase Anon/Public Key
  static const String supabaseAnonKey = 'sb_publishable_OhN_rv_HiZduFAbjb2cAJA__z_7N9P4';

  /// Validates that the configuration is properly set
  static bool get isConfigured {
    return supabaseUrl != 'https://your-project.supabase.co' &&
        supabaseAnonKey != 'your-anon-key';
  }

  /// Load environment variables (no-op, using constants)
  static Future<void> loadEnv() async {
    // Using hardcoded values for now
  }

  /// Initialize Supabase with the configured credentials
  static Future<void> initialize() async {
    await loadEnv();

    if (!isConfigured) {
      if (kDebugMode) {
        debugPrint('⚠️ Supabase not configured. Using placeholder values.');
        debugPrint('   Ensure .env file exists with SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY.');
      }
      // Still initialize with placeholder to avoid crashes in development
      // The app will handle missing config gracefully
    }
  }
}