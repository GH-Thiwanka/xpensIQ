import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

enum ExpensType { Shopping, Subscriptions, Food, Health, Transport }

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
}
