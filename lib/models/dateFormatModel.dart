import 'package:intl/intl.dart';

class DateFormatModel {
  // Different date format patterns
  static const String ddMmYyyy = 'dd/MM/yyyy';
  static const String mmDdYyyy = 'MM/dd/yyyy';
  static const String yyyyMmDd = 'yyyy-MM-dd';
  static const String mmmDdYyyy = 'MMM dd, yyyy';
  static const String fullDate = 'EEEE, MMMM dd, yyyy';
  static const String shortDate = 'MMM dd';
  static const String monthYear = 'MMMM yyyy';
  static const String dayMonth = 'dd MMM';

  // Time format patterns
  static const String time12Hour = 'hh:mm a';
  static const String time24Hour = 'HH:mm';
  static const String timeWithSeconds = 'HH:mm:ss';

  // Combined date and time patterns
  static const String dateTime12 = 'MMM dd, yyyy hh:mm a';
  static const String dateTime24 = 'MMM dd, yyyy HH:mm';
  static const String fullDateTime = 'EEEE, MMMM dd, yyyy hh:mm a';

  // Format date with custom pattern
  static String formatDate(DateTime date, String pattern) {
    try {
      return DateFormat(pattern).format(date);
    } catch (e) {
      return date.toString();
    }
  }

  // Predefined formatting methods
  static String toStandardDate(DateTime date) {
    return formatDate(date, mmmDdYyyy);
  }

  static String toShortDate(DateTime date) {
    return formatDate(date, shortDate);
  }

  static String toFullDate(DateTime date) {
    return formatDate(date, fullDate);
  }

  static String toDayMonth(DateTime date) {
    return formatDate(date, dayMonth);
  }

  static String toMonthYear(DateTime date) {
    return formatDate(date, monthYear);
  }

  static String toTime12Hour(DateTime time) {
    return formatDate(time, time12Hour);
  }

  static String toTime24Hour(DateTime time) {
    return formatDate(time, time24Hour);
  }

  static String toDateTime12Hour(DateTime dateTime) {
    return formatDate(dateTime, dateTime12);
  }

  static String toDateTime24Hour(DateTime dateTime) {
    return formatDate(dateTime, dateTime24);
  }

  static String toFullDateTime(DateTime dateTime) {
    return formatDate(dateTime, fullDateTime);
  }

  // Utility methods
  static String getRelativeTime(DateTime date) {
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
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.day == yesterday.day &&
        date.month == yesterday.month &&
        date.year == yesterday.year;
  }

  // Check if date is in current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Smart date formatting based on how recent the date is
  static String smartFormat(DateTime date) {
    if (isToday(date)) {
      return 'Today, ${toTime12Hour(date)}';
    } else if (isYesterday(date)) {
      return 'Yesterday, ${toTime12Hour(date)}';
    } else if (isThisWeek(date)) {
      return DateFormat('EEEE, hh:mm a').format(date);
    } else if (date.year == DateTime.now().year) {
      return formatDate(date, 'MMM dd, hh:mm a');
    } else {
      return formatDate(date, 'MMM dd, yyyy');
    }
  }

  // Format for financial transactions (commonly used format)
  static String transactionFormat(DateTime date) {
    return toStandardDate(date);
  }

  // Get month name from date
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  // Get short month name from date
  static String getShortMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  // Get day name from date
  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  // Get short day name from date
  static String getShortDayName(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  // Parse string to DateTime (useful for form inputs)
  static DateTime? parseDate(String dateString, String pattern) {
    try {
      return DateFormat(pattern).parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
