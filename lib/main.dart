import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shopping_list_provider.dart';
import 'repositories/firebase_shopping_list_repository.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = FirebaseAnalytics.instance;

    return ChangeNotifierProvider(
      create: (_) => ShoppingListProvider(
        FirebaseShoppingListRepository(FirebaseFirestore.instance, analytics),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping List',
        theme: AppTheme.theme,
        home: const HomePage(),
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      ),
    );
  }
}
