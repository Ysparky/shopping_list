import 'package:flutter/material.dart';
import 'package:pc_3_shopping_list/models/shopping_item.dart';
import 'package:pc_3_shopping_list/providers/shopping_list_provider.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:pc_3_shopping_list/widgets/custom_snackbar.dart';

class ItemWidget extends StatefulWidget {
  final ShoppingItem item;

  const ItemWidget({super.key, required this.item});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool _isUpdating = false;

  Future<void> _handleCheckboxChange(bool? value) async {
    if (value == null || _isUpdating) return;

    setState(() => _isUpdating = true);

    try {
      await context.read<ShoppingListProvider>().updateItem(
        widget.item.id,
        isPurchased: value,
      );
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: 'Error al actualizar el item',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(widget.item.id),
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
        onDismissed: (direction) {
          context.read<ShoppingListProvider>().deleteItem(widget.item.id);
          CustomSnackBar.show(context, message: 'Item eliminado exitosamente');
        },
        child: ListTile(
          tileColor: tileBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: SizedBox(
            width: 24,
            height: 24,
            child: _isUpdating
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      shape: const CircleBorder(),
                      side: BorderSide(color: fontColor, width: 2),
                      activeColor: primaryColor,
                      checkColor: backgroundColor,
                      value: widget.item.isPurchased,
                      onChanged: _handleCheckboxChange,
                    ),
                  ),
          ),
          trailing: widget.item.quantity != null
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
                    widget.item.quantity!,
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
              color: widget.item.isPurchased ? fontSecondaryColor : fontColor,
              fontWeight: FontWeight.w600,
              decoration: widget.item.isPurchased
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: widget.item.isPurchased
                  ? fontSecondaryColor
                  : fontColor,
            ),
            child: Text(widget.item.name),
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
          '¿Estás seguro de querer borrar "${widget.item.name}"?',
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
