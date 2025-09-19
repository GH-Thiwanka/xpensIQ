import 'package:cloud_firestore/cloud_firestore.dart';
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
    String userId,
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
        userId: userId,
        Incometype: incomeTypeString,
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
    String userId,
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
        userId: userId,
        Expenstype: expenseTypeString,
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

  // Method to update income
  Future<void> updateIncome(
    String id,
    String incomeType,
    String description,
    double value,
  ) async {
    try {
      await _incomeCollection.doc(id).update({
        'Incometype': incomeType,
        'description': description,
        'value': value,
        'time': Timestamp.fromDate(DateTime.now()), // Update the time
      });

      print('Income updated successfully with ID: $id');
    } catch (error) {
      print('Error updating income: $error');
      rethrow;
    }
  }

  // Method to update expense
  Future<void> updateExpense(
    String id,
    String expenseType,
    String description,
    double value,
  ) async {
    try {
      await _expenseCollection.doc(id).update({
        'Expenstype': expenseType,
        'description': description,
        'value': value,
        'time': Timestamp.fromDate(DateTime.now()), // Update the time
      });

      print('Expense updated successfully with ID: $id');
    } catch (error) {
      print('Error updating expense: $error');
      rethrow;
    }
  }

  // Method to delete income
  Future<void> deleteIncome(String id) async {
    try {
      await _incomeCollection.doc(id).delete();
      print('Income deleted successfully with ID: $id');
    } catch (error) {
      print('Error deleting income: $error');
      rethrow;
    }
  }

  // Method to delete expense
  Future<void> deleteExpense(String id) async {
    try {
      await _expenseCollection.doc(id).delete();
      print('Expense deleted successfully with ID: $id');
    } catch (error) {
      print('Error deleting expense: $error');
      rethrow;
    }
  }

  // Universal method that can handle both income and expense
  Future<void> addTransaction(
    String userId,
    bool isIncome,
    dynamic categoryType,
    String description,
    double value,
  ) async {
    if (isIncome) {
      await addIncome(userId, categoryType, description, value);
    } else {
      await addExpense(userId, categoryType, description, value);
    }
  }

  // Method to get all the income for a specific user
  Stream<List<Incomemodel>> getIncome(String userId) {
    return _incomeCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Incomemodel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  // Method to get all the expenses for a specific user
  Stream<List<Expensmodel>> getExpens(String userId) {
    return _expenseCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Expensmodel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  // Method to get single income by ID
  Future<Incomemodel?> getIncomeById(String id) async {
    try {
      DocumentSnapshot doc = await _incomeCollection.doc(id).get();
      if (doc.exists) {
        return Incomemodel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (error) {
      print('Error getting income by ID: $error');
      rethrow;
    }
  }

  // Method to get single expense by ID
  Future<Expensmodel?> getExpenseById(String id) async {
    try {
      DocumentSnapshot doc = await _expenseCollection.doc(id).get();
      if (doc.exists) {
        return Expensmodel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (error) {
      print('Error getting expense by ID: $error');
      rethrow;
    }
  }
}
