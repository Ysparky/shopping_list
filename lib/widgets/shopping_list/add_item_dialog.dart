import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_list_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_snackbar.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedUnit = 'unidad';

  final Map<String, List<String>> _unitCategories = {
    'Unidades': ['unidad', 'par', 'docena', 'paquete'],
    'Peso': ['g', 'kg', 'lb'],
    'Volumen': ['ml', 'l', 'oz'],
    'Longitud': ['cm', 'm'],
  };

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final quantity = _quantityController.text.isNotEmpty
          ? '${_quantityController.text}$_selectedUnit'
          : null;

      await context.read<ShoppingListProvider>().addItem(
        _nameController.text.trim(),
        quantity,
      );

      if (mounted) {
        Navigator.pop(context);
        CustomSnackBar.show(context, message: 'Item agregado exitosamente');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: 'Error al agregar item: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    List<DropdownMenuItem<String>> items = [];

    _unitCategories.forEach((category, units) {
      // Agregar el encabezado de la categoría
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(
            category,
            style: TextStyle(
              color: fontSecondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );

      // Agregar las unidades de la categoría
      items.addAll(
        units.map(
          (unit) => DropdownMenuItem<String>(
            value: unit,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(unit, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      );

      // Agregar un divisor si no es la última categoría
      if (category != _unitCategories.keys.last) {
        items.add(
          DropdownMenuItem<String>(
            enabled: false,
            child: Divider(color: fontSecondaryColor),
          ),
        );
      }
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: tileBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Item',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: fontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: fontColor),
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(color: fontSecondaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: fontSecondaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      style: TextStyle(color: fontColor),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Quantity (Optional)',
                        labelStyle: TextStyle(color: fontSecondaryColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: fontSecondaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: fontSecondaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedUnit,
                          dropdownColor: tileBackgroundColor,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: fontSecondaryColor,
                          ),
                          isExpanded: true,
                          style: TextStyle(color: fontColor, fontSize: 14),
                          items: _buildDropdownItems(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() => _selectedUnit = newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: _isLoading
                            ? fontSecondaryColor.withValues(alpha: 0.5)
                            : fontSecondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: primaryColor.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
