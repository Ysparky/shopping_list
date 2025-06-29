import 'package:flutter/material.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';
import 'package:pc_3_shopping_list/widgets/shopping_list/add_item_dialog.dart';

class AnimatedAddButton extends StatelessWidget {
  const AnimatedAddButton({super.key, required bool showFab})
    : _showFab = showFab;

  final bool _showFab;

  Future<void> _showAddItemDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (result != null) {
      // TODO: Handle the new item data
      print(
        'New item: ${result['name']} - ${result['quantity']}${result['unit']}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: _showFab ? null : 0,
      bottom: 20,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
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
                            SizedBox(width: 8),
                            Text(
                              'Agregar nuevo item',
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
