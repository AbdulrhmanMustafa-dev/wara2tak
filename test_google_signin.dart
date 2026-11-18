// Test script to verify Google Sign-In configuration
// Run this in the app to test

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void testConfiguration() async {
  // Test 1: Check if GoogleSignIn can be initialized
  final googleSignIn = GoogleSignIn(
    serverClientId: '471240171200-74earbu056i61eav87pdtn0el3sjvcbf.apps.googleusercontent.com',
  );
  
  print('GoogleSignIn initialized: $googleSignIn');
  
  // Test 2: Try to sign in silently
  try {
    final account = await googleSignIn.signInSilently();
    print('Silent sign in: ${account?.email ?? "none"}');
  } catch (e) {
    print('Silent sign in error: $e');
  }
  
  // Test 3: Check Supabase Auth configuration
  final supabase = Supabase.instance.client;

}
