import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum IncomeType { Freelance, Salary, Sales }

final Map<IncomeType, String> incomeIncomeTypeImages = {
  IncomeType.Freelance: 'assets/free.png',
  IncomeType.Salary: 'assets/salary.png',
  IncomeType.Sales: 'assets/sale.png',
};

final Map<IncomeType, Color> incomeIncomeTypeColor = {
  IncomeType.Freelance: const Color(0xffe57373),
  IncomeType.Salary: const Color(0xff81c784),
  IncomeType.Sales: const Color(0xffffd54f),
};

class Incomemodel {
  final String id;
  final IncomeType Incometype;
  final String description;
  final double value;
  final DateTime date;
  final DateTime time;

  Incomemodel({
    required this.id,
    required this.Incometype,
    required this.description,
    required this.value,
    required this.date,
    required this.time,
  });

  factory Incomemodel.fromJson(Map<String, dynamic> doc, String id) {
    return Incomemodel(
      id: id,
      Incometype: doc['Incometype'],
      description: doc['description'],
      value: doc['value'],
      date: (doc['date'] as Timestamp).toDate(),
      time: (doc['time'] as Timestamp).toDate(),
    );
  }

  //convert the income model to a firebase document
  Map<String, dynamic> toJson() {
    return {
      'Incometype': Incometype,
      'description': description,
      'value': value,
      'date': date,
      'time': time,
    };
  }
}
