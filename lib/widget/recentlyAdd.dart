import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';

class RecentTransactionsScreen extends StatelessWidget {
  const RecentTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Transactions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const RecentTransactionsList(),
    );
  }
}

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionItem>>(
      stream: _getRecentTransactionsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // The stream automatically updates, so we don't need to do anything
            return Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            shrinkWrap:
                true, // This makes ListView take only the space it needs
            physics:
                const NeverScrollableScrollPhysics(), // Disable ListView scroll since it's inside SingleChildScrollView
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
    return Stream.periodic(const Duration(seconds: 1), (i) => i).asyncMap((
      _,
    ) async {
      List<TransactionItem> transactions = [];

      try {
        // Get expenses
        final expensesSnapshot = await FirebaseFirestore.instance
            .collection('expenses')
            .orderBy('date', descending: true)
            .limit(50)
            .get();

        for (var doc in expensesSnapshot.docs) {
          try {
            final expense = Expensmodel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
            transactions.add(
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
            print('Error parsing expense: $e');
          }
        }

        // Get incomes
        final incomesSnapshot = await FirebaseFirestore.instance
            .collection('income')
            .orderBy('date', descending: true)
            .limit(50)
            .get();

        for (var doc in incomesSnapshot.docs) {
          try {
            final income = Incomemodel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
            transactions.add(
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
            print('Error parsing income: $e');
          }
        }

        // Sort by date (newest first)
        transactions.sort((a, b) => b.date.compareTo(a.date));

        // Limit to recent 20 transactions
        return transactions.take(10).toList();
      } catch (e) {
        print('Error fetching transactions: $e');
        return <TransactionItem>[];
      }
    });
  }
}

enum TransactionType { income, expense }

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

class TransactionCard extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionCard({Key? key, required this.transaction})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome
        ? (incomeTypeColor[transaction.category] ?? Colors.green)
        : (expenseTypeColors[transaction.category] ?? Colors.red);

    final imagePath = isIncome
        ? (incomeTypeImages[transaction.category] ?? 'assets/sale.png')
        : (expenseTypeImages[transaction.category] ?? 'assets/food.png');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  isIncome ? Icons.trending_up : Icons.trending_down,
                  color: color,
                  size: 24,
                );
              },
            ),
          ),
        ),
        title: Text(
          transaction.category,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                transaction.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatDate(transaction.date),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${NumberFormatModel.toLKRFormatted(transaction.value)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isIncome
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isIncome ? 'Income' : 'Expense',
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

// Alternative widget that can be embedded in other screens
class RecentTransactionsWidget extends StatelessWidget {
  final int limit;
  final bool showHeader;

  const RecentTransactionsWidget({
    Key? key,
    this.limit = 5,
    this.showHeader = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecentTransactionsScreen(),
                      ),
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
        ],
        StreamBuilder<List<TransactionItem>>(
          stream: _getRecentTransactionsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final transactions = snapshot.data?.take(limit).toList() ?? [];

            if (transactions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No recent transactions'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionCard(transaction: transactions[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Stream<List<TransactionItem>> _getRecentTransactionsStream() {
    return Stream.periodic(const Duration(seconds: 1), (i) => i).asyncMap((
      _,
    ) async {
      List<TransactionItem> transactions = [];

      try {
        // Get expenses
        final expensesSnapshot = await FirebaseFirestore.instance
            .collection('expenses')
            .orderBy('date', descending: true)
            .limit(limit * 2)
            .get();

        for (var doc in expensesSnapshot.docs) {
          try {
            final expense = Expensmodel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
            transactions.add(
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
            print('Error parsing expense: $e');
          }
        }

        // Get incomes
        final incomesSnapshot = await FirebaseFirestore.instance
            .collection('income')
            .orderBy('date', descending: true)
            .limit(limit * 2)
            .get();

        for (var doc in incomesSnapshot.docs) {
          try {
            final income = Incomemodel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
            transactions.add(
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
            print('Error parsing income: $e');
          }
        }

        transactions.sort((a, b) => b.date.compareTo(a.date));
        return transactions;
      } catch (e) {
        print('Error fetching transactions: $e');
        return <TransactionItem>[];
      }
    });
  }
}
