import 'package:intl/intl.dart';
import 'package:pc_3_shopping_list/models/shopping_item.dart';

class DateHelper {
  static final DateFormat _fullFormatter = DateFormat('dd MMM yyyy hh:mm a');
  static final DateFormat _shortFormatter = DateFormat('MMM d, y');

  /// Formats a date to "30 Jun 2025 04:50 PM" format
  static String formatFull(DateTime date) {
    return _fullFormatter.format(date);
  }

  /// Formats a date to "Jun 30, 2025" format
  static String formatShort(DateTime date) {
    return _shortFormatter.format(date);
  }

  /// Returns a human-readable relative date
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatShort(date);
    }
  }

  /// Gets the latest creation date from a list of shopping items
  /// Returns null if the list is empty
  static DateTime? getLatestCreationDate(List<ShoppingItem> items) {
    if (items.isEmpty) return null;

    return items
        .map((item) => item.createdAt)
        .reduce((value, element) => value.isAfter(element) ? value : element);
  }

  /// Gets a formatted string of the latest modification
  /// Returns "No items yet" if the list is empty
  static String getLatestModificationText(List<ShoppingItem> items) {
    final latestDate = getLatestCreationDate(items);
    if (latestDate == null) return 'No hay items';

    return 'Última modificación: ${formatFull(latestDate)}';
  }
}
