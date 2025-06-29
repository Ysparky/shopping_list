import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/shopping_item.dart';
import 'shopping_list_repository.dart';

class InMemoryShoppingListRepository implements ShoppingListRepository {
  final List<ShoppingItem> _items = [];
  final _uuid = const Uuid();

  @override
  Future<List<ShoppingItem>> getItems() async {
    return List.from(_items);
  }

  @override
  Future<ShoppingItem> getItem(String id) async {
    final item = _items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Item not found'),
    );
    return item;
  }

  @override
  Future<ShoppingItem> addItem(String name, String? quantity) async {
    final item = ShoppingItem(id: _uuid.v4(), name: name, quantity: quantity);
    _items.add(item);
    return item;
  }

  @override
  Future<ShoppingItem> updateItem(
    String id, {
    String? name,
    String? quantity,
    bool? isPurchased,
  }) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) throw Exception('Item not found');

    final updatedItem = _items[index].copyWith(
      name: name,
      quantity: quantity,
      isPurchased: isPurchased,
    );
    _items[index] = updatedItem;
    return updatedItem;
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<ShoppingItem>> searchItems(String query) async {
    if (query.isEmpty) return _items;

    final lowercaseQuery = query.toLowerCase();
    return _items.where((item) {
      return item.name.toLowerCase().contains(lowercaseQuery) ||
          (item.quantity?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  @override
  Future<List<ShoppingItem>> filterItems({bool? isPurchased}) async {
    if (isPurchased == null) return _items;

    return _items.where((item) => item.isPurchased == isPurchased).toList();
  }
}
