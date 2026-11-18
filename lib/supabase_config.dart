// Supabase Configuration
// Values can be loaded from:
// 1. --dart-define flags (recommended for CI/CD): --dart-define=GEMINI_API_KEY=xxx --dart-define=KIMI_API_KEY=xxx
// 2. .env file at runtime using flutter_dotenv (for local development)
// 3. Hardcoded constants below (fallback for development only)
// Get your credentials from: https://supabase.com/dashboard/project/_/settings/api

import 'dart:io';
import 'package:flutter/foundation.dart';

class SupabaseConfig {
  // Supabase Project URL (e.g., https://your-project.supabase.co)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gofycnzmutyborktxryo.supabase.co',
  );

  // Supabase Anon/Public Key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_OhN_rv_HiZduFAbjb2cAJA__z_7N9P4',
  );

  // --- API Keys loaded from --dart-define (CI/CD) or .env (local) ---
  // Note: const values from String.fromEnvironment are compile-time constants.
  // The .env values are read at runtime and stored in _runtimeValues for actual use.

  // Gemini API Key for Google Generative AI
  // Get your key from: https://aistudio.google.com/apikey
  static const String _geminiApiKeyConst = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AQ.Ab8RN6Ik2Uao_eOyhvUvwRKIsFF4hlu3-VgmDUQEJZFCqrUkew',
  );

  // Kimi (Moonshot AI) API Key - OpenAI compatible endpoint
  // Get your key from: https://platform.moonshot.cn/console/api-keys
  static const String _kimiApiKeyConst = String.fromEnvironment(
    'KIMI_API_KEY',
    defaultValue: 'sk-hQ8DzKiot6xfhuKY5WbOLUdzOEHWJjx3OCXd0kGgVlKDLQAm',
  );

  // Kimi API Base URL (OpenAI compatible)
  static const String _kimiBaseUrlConst = String.fromEnvironment(
    'KIMI_BASE_URL',
    defaultValue: 'https://api.moonshot.cn/v1',
  );

  // Cerebras API Key - Ultra-fast inference
  // Get your key from: https://cloud.cerebras.ai/
  static const String _cerebrasApiKeyConst = String.fromEnvironment(
    'CEREBRAS_API_KEY',
    defaultValue: '',
  );

  // Cerebras API Base URL (OpenAI compatible)
  static const String _cerebrasBaseUrlConst = String.fromEnvironment(
    'CEREBRAS_BASE_URL',
    defaultValue: 'https://api.cerebras.ai/v1',
  );

  // Runtime values loaded from .env (take precedence over const defaults)
  static final Map<String, String> _runtimeValues = {};

  /// Get Gemini API Key (runtime value from .env takes precedence)
  static String get geminiApiKey => _runtimeValues['GEMINI_API_KEY'] ?? _geminiApiKeyConst;

  /// Get Kimi API Key (runtime value from .env takes precedence)
  static String get kimiApiKey => _runtimeValues['KIMI_API_KEY'] ?? _runtimeValues['kimi_api_key'] ?? _kimiApiKeyConst;

  /// Get Kimi API Base URL
  static String get kimiBaseUrl => _runtimeValues['KIMI_BASE_URL'] ?? _kimiBaseUrlConst;

  /// Get Cerebras API Key (runtime value from .env takes precedence)
  static String get cerebrasApiKey => _runtimeValues['CEREBRAS_API_KEY'] ?? _cerebrasApiKeyConst;

  /// Get Cerebras API Base URL
  static String get cerebrasBaseUrl => _runtimeValues['CEREBRAS_BASE_URL'] ?? _cerebrasBaseUrlConst;

  /// Validates that Cerebras API key is configured
  static bool get isCerebrasConfigured {
    return cerebrasApiKey.isNotEmpty &&
        cerebrasApiKey != 'YOUR_CEREBRAS_API_KEY';
  }

  /// Validates that the configuration is properly set
  static bool get isConfigured {
    return supabaseUrl != 'https://your-project.supabase.co' &&
        supabaseAnonKey != 'your-anon-key';
  }

  /// Validates that Gemini API key is configured
  static bool get isGeminiConfigured {
    return geminiApiKey.isNotEmpty &&
        geminiApiKey != 'YOUR_GEMINI_API_KEY' &&
        !geminiApiKey.startsWith('sk-'); // Not a Kimi key
  }

  /// Validates that Kimi API key is configured
  static bool get isKimiConfigured {
    return kimiApiKey.isNotEmpty &&
        kimiApiKey != 'sk-hQ8DzKiot6xfhuKY5WbOLUdzOEHWJjx3OCXd0kGgVlKDLQAm' &&
        kimiApiKey.startsWith('sk-'); // Kimi keys start with sk-
  }

  /// Load environment variables from .env file if available
  static Future<void> loadEnv() async {
    // Try to load from .env file for local development
    // This is optional and won't fail if .env doesn't exist
    try {
      final envFile = File('.env');
      final exists = await envFile.exists();
      if (exists) {
        final content = await envFile.readAsString();
        final lines = content.split('\n');
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
          final parts = trimmed.split('=');
          if (parts.length >= 2) {
            final key = parts[0].trim().toUpperCase();
            final value = parts.sublist(1).join('=').trim();
            _runtimeValues[key] = value;
            if (kDebugMode) {
              debugPrint('📦 Loaded from .env: $key=${value.isNotEmpty ? (value.length > 8 ? '${value.substring(0, 4)}...${value.substring(value.length - 4)}' : '****') : '(empty)'}');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to load .env: $e');
      }
      // Ignore .env loading errors
    }
  }

  /// Initialize Supabase with the configured credentials
  static Future<void> initialize() async {
    await loadEnv();

    if (!isConfigured) {
      if (kDebugMode) {
        debugPrint('⚠️ Supabase not configured. Using placeholder values.');
        debugPrint('   Set SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define or .env');
      }
      // Still initialize with placeholder to avoid crashes in development
      // The app will handle missing config gracefully
    }

    if (!isGeminiConfigured) {
      if (kDebugMode) {
        debugPrint('❌ Gemini API key not configured. AI features will not work.');
        debugPrint('   Set GEMINI_API_KEY via --dart-define or .env');
      }
    } else if (kDebugMode) {
      final maskedKey = geminiApiKey.length > 8
          ? '${geminiApiKey.substring(0, 4)}...${geminiApiKey.substring(geminiApiKey.length - 4)}'
          : '****';
      debugPrint('✅ Gemini API key loaded: $maskedKey (CONFIGURED)');
    }

    if (!isKimiConfigured) {
      if (kDebugMode) {
        debugPrint('⚠️ Kimi API key not configured. Fallback AI provider unavailable.');
        debugPrint('   Set KIMI_API_KEY via --dart-define or .env');
      }
    } else if (kDebugMode) {
      final maskedKey = kimiApiKey.length > 8
          ? '${kimiApiKey.substring(0, 4)}...${kimiApiKey.substring(kimiApiKey.length - 4)}'
          : '****';
      debugPrint('✅ Kimi API key loaded: $maskedKey (CONFIGURED)');
    }

    if (!isCerebrasConfigured) {
      if (kDebugMode) {
        debugPrint('⚠️ Cerebras API key not configured. Ultra-fast inference unavailable.');
        debugPrint('   Set CEREBRAS_API_KEY via --dart-define or .env');
      }
    } else if (kDebugMode) {
      final maskedKey = cerebrasApiKey.length > 8
          ? '${cerebrasApiKey.substring(0, 4)}...${cerebrasApiKey.substring(cerebrasApiKey.length - 4)}'
          : '****';
      debugPrint('✅ Cerebras API key loaded: $maskedKey (CONFIGURED)');
    }
  }
}