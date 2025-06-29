import 'package:flutter/material.dart';
import 'package:pc_3_shopping_list/providers/shopping_list_provider.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';
import 'package:pc_3_shopping_list/utils/date_helper.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Lista de compras',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Consumer<ShoppingListProvider>(
                builder: (context, provider, child) {
                  final totalItems = provider.totalItems;
                  final filteredItems = provider.items.length;
                  final isFiltering = provider.isFiltering;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        final inAnimation = Tween<Offset>(
                          begin: const Offset(0, -0.5),
                          end: Offset.zero,
                        ).animate(animation);
                        final outAnimation = Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(0, 0.5),
                        ).animate(animation);

                        return SlideTransition(
                          position: animation.status == AnimationStatus.reverse
                              ? outAnimation
                              : inAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        isFiltering
                            ? '$filteredItems / $totalItems'
                            : totalItems.toString(),
                        key: ValueKey(
                          '$filteredItems-$totalItems-$isFiltering',
                        ),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<ShoppingListProvider>(
            builder: (context, provider, child) {
              return Text(
                DateHelper.getLatestModificationText(provider.allItems),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: fontSecondaryColor),
              );
            },
          ),
        ],
      ),
    );
  }
}
