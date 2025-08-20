import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/search_screen.dart';
import 'screens/news_screen.dart';

void main() {
  runApp(const FlyJourneyApp());
}

class FlyJourneyApp extends StatelessWidget {
  const FlyJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlyJourney',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/search':
            final args = (settings.arguments as Map?) ?? {};
            return MaterialPageRoute(
              builder: (_) => SearchScreen(
                from: args['from'] as String?,
                to: args['to'] as String?,
                date: args['date'] as DateTime?,
              ),
            );
          case '/booking':
            return MaterialPageRoute(builder: (_) => const BookingScreen());
          case '/news':
            return MaterialPageRoute(builder: (_) => const NewsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}
