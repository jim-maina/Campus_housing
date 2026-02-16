import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/listing_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/listings_feed.dart';
import 'screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        title: 'Nyumba nguvu',
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
