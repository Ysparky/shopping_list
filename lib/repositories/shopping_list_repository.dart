import '../models/shopping_item.dart';

abstract class ShoppingListRepository {
  Future<List<ShoppingItem>> getItems();
  Future<ShoppingItem> getItem(String id);
  Future<ShoppingItem> addItem(String name, String? quantity);
  Future<ShoppingItem> updateItem(
    String id, {
    String? name,
    String? quantity,
    bool? isPurchased,
  });
  Future<void> deleteItem(String id);
  Future<List<ShoppingItem>> searchItems(String query);
  Future<List<ShoppingItem>> filterItems({bool? isPurchased});
}
