import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/category_selection_screen.dart';
import 'screens/order_description_screen.dart';
import 'screens/pvz_selection_screen.dart';
import 'screens/order_confirmation_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Repair Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/category-selection': (context) => const CategorySelectionScreen(),
        '/order-description': (context) => const OrderDescriptionScreen(),
        '/pvz-selection': (context) => const PvzSelectionScreen(),
        '/order-confirmation': (context) => const OrderConfirmationScreen(),
      },
    );
  }
}