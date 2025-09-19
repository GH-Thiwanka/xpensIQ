import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum IncomeType { Freelance, Salary, Sales }

final Map<String, String> incomeTypeImages = {
  'Freelance': 'assets/free.png',
  'Salary': 'assets/salary.png',
  'Sales': 'assets/sale.png',
};

final Map<String, Color> incomeTypeColor = {
  'Freelance': const Color.fromARGB(255, 247, 82, 217),
  'Salary': const Color(0xff81c784),
  'Sales': const Color(0xffffd54f),
};

class Incomemodel {
  final String id;
  final String userId;
  final String Incometype;
  final String description;
  final double value;
  final DateTime date;
  final DateTime time;

  Incomemodel({
    required this.id,
    required this.userId,
    required this.Incometype,
    required this.description,
    required this.value,
    required this.date,
    required this.time,
  });

  factory Incomemodel.fromJson(Map<String, dynamic> doc, String id) {
    return Incomemodel(
      id: id,
      userId: doc['userId'] ?? '',
      Incometype: doc['Incometype'] ?? 'Sales',
      description: doc['description'] ?? '',
      value: (doc['value'] ?? 0).toDouble(),
      date: (doc['date'] as Timestamp).toDate(),
      time: (doc['time'] as Timestamp).toDate(),
    );
  }

  // Convert the income model to a Firebase document
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'Incometype': Incometype,
      'description': description,
      'value': value,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
    };
  }
}
