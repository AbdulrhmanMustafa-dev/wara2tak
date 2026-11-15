import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Supabase database operations
class SupabaseDatabaseService {
  final SupabaseClient _client;

  SupabaseDatabaseService(this._client);

  /// Get the Supabase client for direct database access
  SupabaseClient get client => _client;

  /// Generic query builder for a table
  PostgrestQueryBuilder from(String table) => _client.from(table);
}