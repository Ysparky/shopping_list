import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'shopping_list/add_item_dialog.dart';

class AnimatedAddButton extends StatelessWidget {
  const AnimatedAddButton({super.key, required bool showFab})
    : _showFab = showFab;

  final bool _showFab;

  Future<void> _showAddItemDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: _showFab ? null : 0,
      bottom: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 56,
          width: _showFab ? 56 : MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_showFab ? 28 : 10),
          ),
          child: Material(
            color: primaryColor,
            borderRadius: BorderRadius.circular(_showFab ? 28 : 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(_showFab ? 28 : 10),
              onTap: () => _showAddItemDialog(context),
              splashColor: primaryColor.withValues(alpha: 0.12),
              highlightColor: primaryColor.withValues(alpha: 0.08),
              child: Center(
                child: _showFab
                    ? Icon(Icons.add, color: backgroundColor)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: backgroundColor),
                          if (!_showFab) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Add New Item',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: backgroundColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
