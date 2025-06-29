class ShoppingItem {
  final String id;
  final String name;
  final String? quantity;
  final bool isPurchased;
  final DateTime createdAt;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity,
    bool? isPurchased,
    DateTime? createdAt,
  }) : isPurchased = isPurchased ?? false,
       createdAt = createdAt ?? DateTime.now();

  ShoppingItem copyWith({String? name, String? quantity, bool? isPurchased}) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isPurchased: isPurchased ?? this.isPurchased,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isPurchased': isPurchased,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String?,
      isPurchased: json['isPurchased'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
