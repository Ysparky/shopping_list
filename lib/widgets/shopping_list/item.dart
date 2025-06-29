import 'package:flutter/material.dart';
import 'package:pc_3_shopping_list/models/shopping_item.dart';
import 'package:pc_3_shopping_list/providers/shopping_list_provider.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  final ShoppingItem item;

  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ShoppingListProvider>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async => await _showDeleteDialog(context),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete_rounded, color: fontColor),
        ),
        onDismissed: (direction) => provider.deleteItem(item.id),
        child: ListTile(
          tileColor: tileBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: SizedBox(
            width: 24,
            height: 24,
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: const CircleBorder(),
                side: BorderSide(color: fontColor, width: 2),
                activeColor: primaryColor,
                checkColor: backgroundColor,
                value: item.isPurchased,
                onChanged: (value) {
                  if (value != null) {
                    provider.updateItem(item.id, isPurchased: value);
                  }
                },
              ),
            ),
          ),
          trailing: item.quantity != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.quantity!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: item.isPurchased ? fontSecondaryColor : fontColor,
              fontWeight: FontWeight.w600,
              decoration: item.isPurchased
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: item.isPurchased
                  ? fontSecondaryColor
                  : fontColor,
            ),
            child: Text(item.name),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: tileBackgroundColor,
        title: Text('Borrar item', style: TextStyle(color: fontColor)),
        content: Text(
          '¿Estás seguro de querer borrar "${item.name}"?',
          style: TextStyle(color: fontColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: fontSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Borrar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
