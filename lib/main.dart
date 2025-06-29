import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'providers/shopping_list_provider.dart';
import 'repositories/in_memory_shopping_list_repository.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShoppingListProvider(InMemoryShoppingListRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping List',
        theme: AppTheme.theme,
        home: const HomePage(),
      ),
    );
  }
}
