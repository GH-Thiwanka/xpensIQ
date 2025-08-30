import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ExpensType { Shopping, Subscriptions, Food, Health, Transport }

final Map<ExpensType, String> expensExpensTypeImage = {
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
};

class Expensmodel {
  final String id;
  final ExpensType Expenstype;
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
      Expenstype: doc['Expenstype'],
      description: doc['description'],
      value: doc['value'],
      date: (doc['date'] as Timestamp).toDate(),
      time: (doc['time'] as Timestamp).toDate(),
    );
  }

  //convert the income model to a firebase document
  Map<String, dynamic> toJson() {
    return {
      'Expenstype': Expenstype,
      'description': description,
      'value': value,
      'date': date,
      'time': time,
    };
  }
}
