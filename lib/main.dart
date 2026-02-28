import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/listing_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/listings_feed.dart';
import 'screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://sjwbystdlxynihmplato.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNqd2J5c3RkbHh5bmlobXBsYXRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIwMzU0NTUsImV4cCI6MjA4NzYxMTQ1NX0._FzNdPJSOl5Qsm_8AVOkBn0Q73OywiZeyZNUO0q52fE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ListingProvider()..loadSampleData(),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Campus Housing',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const _HomeRouter(),
      ),
    );
  }
}

/// _HomeRouter handles navigation based on auth state
/// If user is logged in, show the listings feed
/// Otherwise, show the role selector
class _HomeRouter extends StatelessWidget {
  const _HomeRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoggedIn) {
          return const ListingsFeedPage();
        } else {
          return const LandingPage();
        }
      },
    );
  }
}
