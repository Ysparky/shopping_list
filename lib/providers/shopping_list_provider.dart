import 'package:flutter/foundation.dart';
import '../models/shopping_item.dart';
import '../repositories/shopping_list_repository.dart';

class ShoppingListProvider extends ChangeNotifier {
  final ShoppingListRepository _repository;
  List<ShoppingItem> _allItems = [];
  List<ShoppingItem> _filteredItems = [];
  bool _isLoading = false;
  String _searchQuery = '';
  bool? _filterPurchased;

  ShoppingListProvider(this._repository) {
    _loadItems();
  }

  List<ShoppingItem> get items => _filteredItems;
  List<ShoppingItem> get allItems => _allItems;
  bool get isLoading => _isLoading;
  bool get isFiltering => _searchQuery.isNotEmpty || _filterPurchased != null;
  int get totalItems => _allItems.length;
  int get purchasedItems => _allItems.where((item) => item.isPurchased).length;

  Future<void> _loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allItems = await _repository.getItems();
      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilters() {
    var filtered = List<ShoppingItem>.from(_allItems);

    // Apply purchase filter
    if (_filterPurchased != null) {
      filtered = filtered
          .where((item) => item.isPurchased == _filterPurchased)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(query) ||
            (item.quantity?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort by creation date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _filteredItems = filtered;
    notifyListeners();
  }

  Future<void> addItem(String name, String? quantity) async {
    await _repository.addItem(name, quantity);
    await _loadItems();
  }

  Future<void> updateItem(
    String id, {
    String? name,
    String? quantity,
    bool? isPurchased,
  }) async {
    await _repository.updateItem(
      id,
      name: name,
      quantity: quantity,
      isPurchased: isPurchased,
    );
    await _loadItems();
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteItem(id);
    await _loadItems();
  }

  void searchItems(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterItems(bool? isPurchased) {
    _filterPurchased = isPurchased;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterPurchased = null;
    _applyFilters();
  }
}
