import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/models/expensModel.dart';

class IncomeFormService {
  // Reference to the firestore collections
  final CollectionReference _incomeCollection = FirebaseFirestore.instance
      .collection('income');
  final CollectionReference _expenseCollection = FirebaseFirestore.instance
      .collection('expenses');

  // Method to add income to Firestore
  Future<void> addIncome(
    dynamic incomeType,
    String description,
    double value,
  ) async {
    try {
      // Convert incomeType to String (handles enum, string, or any other type)
      String incomeTypeString = incomeType.toString();

      // If it's an enum, get the name property
      if (incomeType is Enum) {
        incomeTypeString = (incomeType as dynamic).name;
      }
      // Create a new income record
      final income = Incomemodel(
        id: '', // Firestore will auto-generate the ID
        Incometype: incomeType,
        description: description,
        value: value,
        date: DateTime.now(),
        time: DateTime.now(),
      );

      // Convert to map using the fixed toJson method
      final Map<String, dynamic> data = income.toJson();

      // Add to income collection
      DocumentReference docRef = await _incomeCollection.add(data);

      // Update the document with its own ID
      await docRef.update({'id': docRef.id});

      print('Income added successfully with ID: ${docRef.id}');
    } catch (error) {
      print('Error adding income: $error');
      rethrow;
    }
  }

  // Method to add expense to Firestore
  Future<void> addExpense(
    dynamic expenseType,
    String description,
    double value,
  ) async {
    try {
      // Convert expenseType to String (handles enum, string, or any other type)
      String expenseTypeString = expenseType.toString();

      // If it's an enum, get the name property
      if (expenseType is Enum) {
        expenseTypeString = (expenseType as dynamic).name;
      }
      // Create a new expense record
      final expense = Expensmodel(
        id: '', // Firestore will auto-generate the ID
        Expenstype: expenseType,
        description: description,
        value: value,
        date: DateTime.now(),
        time: DateTime.now(),
      );

      // Convert to map using the fixed toJson method
      final Map<String, dynamic> data = expense.toJson();

      // Add to expense collection
      DocumentReference docRef = await _expenseCollection.add(data);

      // Update the document with its own ID
      await docRef.update({'id': docRef.id});

      print('Expense added successfully with ID: ${docRef.id}');
    } catch (error) {
      print('Error adding expense: $error');
      rethrow;
    }
  }

  // Universal method that can handle both income and expense
  Future<void> addTransaction(
    bool isIncome,
    dynamic categoryType,
    String title,
    String description,
    double value,
  ) async {
    if (isIncome) {
      await addIncome(categoryType, description, value);
    } else {
      await addExpense(categoryType, description, value);
    }
  }
}
