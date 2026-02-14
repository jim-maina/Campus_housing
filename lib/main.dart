import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/listing_provider.dart';
import 'screens/listings_feed.dart';

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
        ChangeNotifierProvider(create: (_) => ListingProvider()..loadSampleData()),
      ],
      child: MaterialApp(
        title: 'Campus Housing',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const ListingsFeedPage(),
      ),
    );
  }
}

