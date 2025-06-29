import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';
import 'package:pc_3_shopping_list/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShowFab = _scrollController.offset > 0;
    if (shouldShowFab != _showFab) {
      setState(() {
        _showFab = shouldShowFab;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(child: HeaderWidget()),
                ),
                const SliverToBoxAdapter(child: SearchWidget()),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 15, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ItemWidget(index: index),
                      childCount: 10,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedAddButton(showFab: _showFab),
          ],
        ),
      ),
    );
  }
}
