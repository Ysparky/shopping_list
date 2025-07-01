import '../models/shopping_item.dart';

abstract class ShoppingListRepository {
  Future<List<ShoppingItem>> getItems();
  Future<void> addItem(String name, String? quantity);
  Future<void> updateItem(
    String id, {
    String? name,
    String? quantity,
    bool? isPurchased,
  });
  Future<void> deleteItem(String id);
}
