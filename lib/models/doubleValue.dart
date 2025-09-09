import 'package:intl/intl.dart';

class NumberFormatModel {
  // Currency formatting for Sri Lankan Rupees
  static final NumberFormat _lkrFormatter = NumberFormat.currency(
    locale: 'en_LK',
    symbol: 'LKR ',
    decimalDigits: 2,
  );

  // Standard decimal formatter
  static final NumberFormat _decimalFormatter = NumberFormat('#,##0.00');

  // Compact number formatter (1K, 1M, etc.)
  static final NumberFormat _compactFormatter = NumberFormat.compact();

  // Format value with exactly 2 decimal places
  static String toTwoDecimalPlaces(double value) {
    return value.toStringAsFixed(2);
  }

  // Format as currency with LKR symbol
  static String toCurrency(double value) {
    return _lkrFormatter.format(value);
  }

  // Format with thousand separators and 2 decimal places
  static String toFormattedDecimal(double value) {
    return _decimalFormatter.format(value);
  }

  // Format with LKR currency and thousand separators
  static String toLKRFormatted(double value) {
    return 'LKR ${_decimalFormatter.format(value)}';
  }

  // Format large numbers in compact form (1K, 1M, 1B)
  static String toCompact(double value) {
    return _compactFormatter.format(value);
  }

  // Custom currency formatting
  static String toCustomCurrency(double value, String symbol) {
    return '$symbol ${toFormattedDecimal(value)}';
  }

  // Format percentage
  static String toPercentage(double value, {int decimalPlaces = 1}) {
    return '${(value * 100).toStringAsFixed(decimalPlaces)}%';
  }

  // Format with specific decimal places
  static String toDecimalPlaces(double value, int decimalPlaces) {
    return value.toStringAsFixed(decimalPlaces);
  }

  // Remove unnecessary decimal zeros (1.00 becomes 1, 1.50 becomes 1.5)
  static String toCleanDecimal(double value) {
    String formatted = value.toStringAsFixed(2);
    if (formatted.endsWith('.00')) {
      return formatted.substring(0, formatted.length - 3);
    } else if (formatted.endsWith('0')) {
      return formatted.substring(0, formatted.length - 1);
    }
    return formatted;
  }

  // Format for financial transactions (always 2 decimal places)
  static String toTransactionAmount(double value) {
    return toTwoDecimalPlaces(value);
  }

  // Format with currency symbol for transactions
  static String toTransactionCurrency(double value, {String currency = 'LKR'}) {
    return '$currency ${toTransactionAmount(value)}';
  }

  // Format large amounts with K, M, B suffixes
  static String toLargeAmount(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return toTwoDecimalPlaces(value);
    }
  }

  // Check if value has decimal part
  static bool hasDecimalPart(double value) {
    return value != value.truncateToDouble();
  }

  // Format based on value size (auto-select format)
  static String smartFormat(double value) {
    if (value >= 1000000) {
      return toLargeAmount(value);
    } else {
      return toFormattedDecimal(value);
    }
  }

  // Parse string to double safely
  static double? parseDouble(String value) {
    try {
      // Remove currency symbols and commas
      String cleanValue = value
          .replaceAll(RegExp(r'[^\d.-]'), '')
          .replaceAll(',', '');
      return double.parse(cleanValue);
    } catch (e) {
      return null;
    }
  }

  // Validate if string is a valid number
  static bool isValidNumber(String value) {
    return parseDouble(value) != null;
  }

  // Format for display in cards/lists
  static String toDisplayAmount(double value) {
    return 'LKR ${toTwoDecimalPlaces(value)}';
  }

  // Format with different colors based on positive/negative
  static String toSignedAmount(double value) {
    String formatted = toDisplayAmount(value.abs());
    return value >= 0 ? '+$formatted' : '-$formatted';
  }
}
