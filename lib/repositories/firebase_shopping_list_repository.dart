import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:uuid/uuid.dart';
import 'package:pc_3_shopping_list/models/shopping_item.dart';
import 'package:pc_3_shopping_list/repositories/shopping_list_repository.dart';

class FirebaseShoppingListRepository implements ShoppingListRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAnalytics _analytics;
  final _uuid = const Uuid();

  FirebaseShoppingListRepository(this._firestore, this._analytics) {
    _initializeFirestore();
  }

  Future<void> _initializeFirestore() async {
    // Configurar para usar caché primero
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      _firestore.collection('shopping_items');

  Future<void> _logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Error logging event: $e');
    }
  }

  @override
  Future<List<ShoppingItem>> getItems() async {
    try {
      final snapshot = await _itemsCollection
          .get(const GetOptions(source: Source.cache))
          .timeout(const Duration(seconds: 5))
          .onError((error, stackTrace) => _itemsCollection.get());

      await _logEvent(
        'items_loaded',
        parameters: {'count': snapshot.docs.length},
      );

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ShoppingItem(
          id: doc.id,
          name: data['name'] as String,
          quantity: data['quantity'] as String?,
          isPurchased: data['isPurchased'] as bool,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error getting items: $e');
      rethrow;
    }
  }

  @override
  Future<void> addItem(String name, String? quantity) async {
    try {
      final id = _uuid.v4();
      await _itemsCollection.doc(id).set({
        'name': name,
        'quantity': quantity,
        'isPurchased': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _logEvent(
        'item_added',
        parameters: {'item_name': name, 'has_quantity': quantity != null},
      );
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateItem(
    String id, {
    String? name,
    String? quantity,
    bool? isPurchased,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (quantity != null) updates['quantity'] = quantity;
      if (isPurchased != null) updates['isPurchased'] = isPurchased;

      await _itemsCollection.doc(id).update(updates);
      await _logEvent(
        'item_updated',
        parameters: {
          'item_id': id,
          'updated_fields': updates.keys.join(','),
          'marked_as_purchased': isPurchased == true,
        },
      );
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await _itemsCollection.doc(id).delete();
      await _logEvent('item_deleted', parameters: {'item_id': id});
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }
}
