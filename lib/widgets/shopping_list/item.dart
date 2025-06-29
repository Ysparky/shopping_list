import 'package:flutter/material.dart';
import 'package:pc_3_shopping_list/theme/colors.dart';

class ItemWidget extends StatelessWidget {
  final int index;
  const ItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key(index.toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return Future.value(true);
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(right: 24),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        onDismissed: (direction) {
          print('dismissed $index: $direction');
        },
        child: Container(
          decoration: BoxDecoration(
            color: tileBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: primaryColor.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          activeColor: primaryColor,
                          checkColor: backgroundColor,
                          value: false,
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item $index',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: fontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Added 2 days ago',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: fontSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '10ml',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
