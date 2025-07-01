import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_list_provider.dart';
import '../../theme/colors.dart';

class SearchWidget extends StatefulWidget {
  final FocusNode focusNode;

  const SearchWidget({super.key, required this.focusNode});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isSearchFocused = widget.focusNode.hasFocus;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: tileBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchFocused ? primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.search_rounded,
            color: _isSearchFocused ? primaryColor : fontSecondaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: widget.focusNode,
              style: TextStyle(color: fontColor),
              decoration: InputDecoration(
                hintText: 'Buscar items...',
                hintStyle: TextStyle(color: fontSecondaryColor),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (value) {
                context.read<ShoppingListProvider>().searchItems(value);
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              color: fontSecondaryColor,
              onPressed: () {
                _searchController.clear();
                context.read<ShoppingListProvider>().clearFilters();
              },
            ),
        ],
      ),
    );
  }
}

// Search Result Item Widget for better organization
class SearchResultItem extends StatelessWidget {
  final String name;
  final String category;
  final String quantity;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.name,
    required this.category,
    required this.quantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.shopping_bag_outlined, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$category • $quantity',
                    style: TextStyle(color: fontSecondaryColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
