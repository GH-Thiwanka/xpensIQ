import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

enum ExpensType { Shopping, Subscriptions, Food, Health, Transport }

/*final Map<ExpensType, String> expensExpensTypeImage = {
  ExpensType.Food: 'assets/food.png',
  ExpensType.Health: 'assets/health.png',
  ExpensType.Shopping: 'assets/shopping.png',
  ExpensType.Subscriptions: 'assets/subs.png',
  ExpensType.Transport: 'assets/car.png',
};

final Map<ExpensType, Color> expensExpensTypeColor = {
  ExpensType.Food: Color(0xffe57373),
  ExpensType.Health: Color(0xffe57373),
  ExpensType.Shopping: Color(0xffe57373),
  ExpensType.Subscriptions: Color(0xffe57373),
  ExpensType.Transport: Color(0xffe57373),
};*/

// Helper maps for string-based operations
final Map<String, String> expenseTypeImages = {
  'Food': 'assets/food.png',
  'Health': 'assets/health.png',
  'Shopping': 'assets/shopping.png',
  'Subscriptions': 'assets/subs.png',
  'Transport': 'assets/car.png',
};

final Map<String, Color> expenseTypeColors = {
  'Food': Color.fromARGB(255, 109, 226, 224),
  'Health': Color(0xffe57373),
  'Shopping': kAlertWarColor,
  'Subscriptions': Color.fromARGB(255, 179, 239, 15),
  'Transport': kBlueColor,
};

class Expensmodel {
  final String id;
  final String Expenstype; // Changed from ExpensType enum to String
  final String description;
  final double value;
  final DateTime date;
  final DateTime time;

  Expensmodel({
    required this.id,
    required this.Expenstype,
    required this.description,
    required this.value,
    required this.date,
    required this.time,
  });

  factory Expensmodel.fromJson(Map<String, dynamic> doc, String id) {
    return Expensmodel(
      id: id,
      Expenstype:
          doc['Expenstype'] ?? 'Food', // Direct string assignment with fallback
      description: doc['description'] ?? '',
      value: (doc['value'] ?? 0).toDouble(),
      date: (doc['date'] as Timestamp).toDate(),
      time: (doc['time'] as Timestamp).toDate(),
    );
  }

  // Convert the expense model to a Firebase document
  Map<String, dynamic> toJson() {
    return {
      'Expenstype': Expenstype, // Already a string
      'description': description,
      'value': value,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
    };
  }

  // Helper method to get the corresponding enum (if needed for UI)
  /*ExpensType? get expenseTypeEnum {
    try {
      return ExpensType.values.firstWhere((e) => e.name == Expenstype);
    } catch (e) {
      return null; // Return null if no matching enum found
    }
  }

  // Helper method to get image path
  String get imagePath {
    return expenseTypeImages[Expenstype] ?? 'assets/default.png';
  }

  // Helper method to get color
  Color get typeColor {
    return expenseTypeColors[Expenstype] ?? Color(0xffe57373);
  }
}

// Helper class for dropdown items
class ExpenseTypeHelper {
  static List<String> get allTypes {
    return ExpensType.values.map((e) => e.name).toList();
  }

  static List<DropdownMenuItem<String>> get dropdownItems {
    return allTypes.map((String type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Row(
          children: [
            Image.asset(
              expenseTypeImages[type] ?? 'assets/default.png',
              width: 24,
              height: 24,
            ),
            SizedBox(width: 8),
            Text(type),
          ],
        ),
      );
    }).toList();
  }*/
}
