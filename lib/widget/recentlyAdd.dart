import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/constants/color.dart';
import 'dart:async';

class TransactionItem {
  final String id;
  final TransactionType type;
  final String category;
  final String description;
  final double value;
  final DateTime date;
  final DateTime time;

  TransactionItem({
    required this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.value,
    required this.date,
    required this.time,
  });
}

enum TransactionType { income, expense }

class RecentTransactionsScreen extends StatelessWidget {
  final String userId;
  const RecentTransactionsScreen({required this.userId, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Transactions'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
      ),
      body: RecentTransactionsList(userId: userId),
    );
  }
}

class RecentTransactionsList extends StatelessWidget {
  final String userId;
  const RecentTransactionsList({required this.userId, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionItem>>(
      stream: _getRecentTransactionsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error in RecentTransactionsList: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error loading transactions',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No transactions found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Add some income or expenses to see them here',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(const Duration(milliseconds: 300));
          },
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(transaction: transaction);
            },
          ),
        );
      },
    );
  }

  Stream<List<TransactionItem>> _getRecentTransactionsStream() {
    // Create a stream controller to manually control the stream
    StreamController<List<TransactionItem>> controller =
        StreamController<List<TransactionItem>>();

    // Set up listeners for both collections
    StreamSubscription? expenseSubscription;
    StreamSubscription? incomeSubscription;

    List<TransactionItem> currentTransactions = [];
    bool expensesLoaded = false;
    bool incomesLoaded = false;

    void updateTransactions() {
      if (expensesLoaded && incomesLoaded) {
        // Sort by date (newest first) and limit to 10
        currentTransactions.sort((a, b) => b.date.compareTo(a.date));
        controller.add(currentTransactions.take(10).toList());
      }
    }

    void processExpenses(QuerySnapshot snapshot) {
      try {
        List<TransactionItem> expenses = [];
        for (var doc in snapshot.docs) {
          try {
            final data = doc.data() as Map<String, dynamic>;

            // Double-check user isolation
            if (data['userId'] != userId) {
              print(
                'Warning: Expense document ${doc.id} has different userId: ${data['userId']}',
              );
              continue;
            }

            final expense = Expensmodel.fromJson(data, doc.id);
            expenses.add(
              TransactionItem(
                id: expense.id,
                type: TransactionType.expense,
                category: expense.Expenstype,
                description: expense.description,
                value: expense.value,
                date: expense.date,
                time: expense.time,
              ),
            );
          } catch (e) {
            print('Error parsing expense document ${doc.id}: $e');
          }
        }

        // Remove old expenses and add new ones
        currentTransactions.removeWhere(
          (t) => t.type == TransactionType.expense,
        );
        currentTransactions.addAll(expenses);
        expensesLoaded = true;
        updateTransactions();
      } catch (e) {
        print('Error processing expenses: $e');
        controller.addError(e);
      }
    }

    void processIncomes(QuerySnapshot snapshot) {
      try {
        List<TransactionItem> incomes = [];
        for (var doc in snapshot.docs) {
          try {
            final data = doc.data() as Map<String, dynamic>;

            // Double-check user isolation
            if (data['userId'] != userId) {
              print(
                'Warning: Income document ${doc.id} has different userId: ${data['userId']}',
              );
              continue;
            }

            final income = Incomemodel.fromJson(data, doc.id);
            incomes.add(
              TransactionItem(
                id: income.id,
                type: TransactionType.income,
                category: income.Incometype,
                description: income.description,
                value: income.value,
                date: income.date,
                time: income.time,
              ),
            );
          } catch (e) {
            print('Error parsing income document ${doc.id}: $e');
          }
        }

        // Remove old incomes and add new ones
        currentTransactions.removeWhere(
          (t) => t.type == TransactionType.income,
        );
        currentTransactions.addAll(incomes);
        incomesLoaded = true;
        updateTransactions();
      } catch (e) {
        print('Error processing incomes: $e');
        controller.addError(e);
      }
    }

    // Set up real-time listeners with proper user isolation
    expenseSubscription = FirebaseFirestore.instance
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          processExpenses,
          onError: (error) {
            print('Error listening to expenses: $error');
            controller.addError(error);
          },
        );

    incomeSubscription = FirebaseFirestore.instance
        .collection('income')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          processIncomes,
          onError: (error) {
            print('Error listening to incomes: $error');
            controller.addError(error);
          },
        );

    // Clean up subscriptions when stream is cancelled
    controller.onCancel = () {
      expenseSubscription?.cancel();
      incomeSubscription?.cancel();
    };

    return controller.stream;
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionCard({Key? key, required this.transaction})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                    (isIncome
                            ? incomeTypeColor[transaction.category]
                            : expenseTypeColors[transaction.category])
                        ?.withAlpha(50) ??
                    (isIncome ? kMainColor : kExepenceColor).withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  isIncome
                      ? incomeTypeImages[transaction.category] ??
                            'assets/increase.png'
                      : expenseTypeImages[transaction.category] ??
                            'assets/decrease.png',
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      isIncome ? Icons.trending_up : Icons.trending_down,
                      color: isIncome ? kMainColor : kExepenceColor,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description.isNotEmpty
                        ? transaction.description
                        : transaction.category,
                    style: TextStyle(
                      color: kMainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.category,
                    style: TextStyle(
                      color: kMainTextColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(transaction.date),
                    style: TextStyle(
                      color: kMainTextColor.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${NumberFormatModel.toLKRFormatted(transaction.value)}',
                  style: TextStyle(
                    color: isIncome ? kMainColor : kExepenceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? kMainColor.withOpacity(0.1)
                        : kExepenceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isIncome ? 'Income' : 'Expense',
                    style: TextStyle(
                      color: isIncome ? kMainColor : kExepenceColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
