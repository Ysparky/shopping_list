import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pc_3_shopping_list/providers/shopping_list_provider.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';
import 'package:pc_3_shopping_list/widgets/widgets.dart';
import 'package:pc_3_shopping_list/models/shopping_item.dart';

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
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: HeaderWidget()),
                  ),
                  SliverToBoxAdapter(
                    child: SearchWidget(focusNode: _searchFocusNode),
                  ),
                  _ShoppingListContent(
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 100),
                  ),
                ],
              ),
              AnimatedAddButton(showFab: _showFab),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShoppingListContent extends StatelessWidget {
  final EdgeInsets padding;

  const _ShoppingListContent({required this.padding});

  @override
  Widget build(BuildContext context) {
    return Selector<ShoppingListProvider, _ShoppingListState>(
      selector: (_, provider) => _ShoppingListState(
        items: provider.items,
        isLoading: provider.isLoading,
        isFiltering: provider.isFiltering,
      ),
      builder: (context, state, _) {
        if (state.isLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (state.items.isEmpty && !state.isFiltering) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/no_data_empty.svg', height: 200),
                const SizedBox(height: 16),
                const Text(
                  'Comienza a agregar items a tu lista',
                  style: TextStyle(color: fontColor, fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state.items.isEmpty && state.isFiltering) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/no_data_filter.svg', height: 200),
                const SizedBox(height: 16),
                const Text(
                  'No hay items que coincidan con tu búsqueda',
                  style: TextStyle(color: fontColor, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ItemWidget(item: state.items[index]),
              childCount: state.items.length,
            ),
          ),
        );
      },
    );
  }
}

class _ShoppingListState {
  final List<ShoppingItem> items;
  final bool isLoading;
  final bool isFiltering;

  const _ShoppingListState({
    required this.items,
    required this.isLoading,
    required this.isFiltering,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _ShoppingListState &&
        other.isLoading == isLoading &&
        other.isFiltering == isFiltering &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode =>
      Object.hash(isLoading, isFiltering, Object.hashAll(items));
}
