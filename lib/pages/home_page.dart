import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../theme/colors.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
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
    _searchFocusNode.dispose();
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

  void _unfocus() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
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

    return GestureDetector(
      onTap: _unfocus,
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: true,
          child: Stack(
            children: [
              Consumer<ShoppingListProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(child: HeaderWidget()),
                      ),
                      SliverToBoxAdapter(
                        child: SearchWidget(focusNode: _searchFocusNode),
                      ),
                      if (provider.items.isEmpty && !provider.isFiltering)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/no_data_empty.svg',
                                height: 200,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Comienza a agregar items a tu lista',
                                style: TextStyle(
                                  color: fontColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (provider.items.isEmpty && provider.isFiltering)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/no_data_filter.svg',
                                height: 200,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No hay items que coincidan con tu búsqueda',
                                style: TextStyle(
                                  color: fontColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 15, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  ItemWidget(item: provider.items[index]),
                              childCount: provider.items.length,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              AnimatedAddButton(showFab: _showFab),
            ],
          ),
        ),
      ),
    );
  }
}
