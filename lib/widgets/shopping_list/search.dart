import 'package:flutter/material.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                  focusNode: _searchFocusNode,
                  style: TextStyle(color: fontColor),
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: fontSecondaryColor),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (value) {
                    // TODO: Implement search functionality
                    print('Searching for: $value');
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: fontSecondaryColor,
                  onPressed: () {
                    _searchController.clear();
                    // TODO: Clear search results
                  },
                ),
            ],
          ),
        ),
        // Animated search results container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _searchController.text.isNotEmpty ? 300 : 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: tileBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 0, // TODO: Replace with actual search results
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Search Result $index',
                      style: TextStyle(color: fontColor),
                    ),
                    subtitle: Text(
                      'Category • Quantity',
                      style: TextStyle(color: fontSecondaryColor),
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: primaryColor,
                      ),
                    ),
                    onTap: () {
                      // TODO: Handle search result tap
                      print('Tapped search result $index');
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
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
