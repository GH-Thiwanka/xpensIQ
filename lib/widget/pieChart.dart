import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';

class Cards extends StatefulWidget {
  final bool isIncome;
  const Cards({super.key, required this.isIncome});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  Map<String, double> expensTypeTotal = {
    'Food': 0,
    'Health': 0,
    'Shopping': 0,
    'Subscriptions': 0,
    'Transport': 0,
  };

  Map<String, double> incomeTypeTotal = {
    'Freelance': 0,
    'Salary': 0,
    'Sales': 0,
  };

  bool isLoading = true;
  StreamSubscription? _expenseSubscription;
  StreamSubscription? _incomeSubscription;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _expenseSubscription?.cancel();
    _incomeSubscription?.cancel();
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      isLoading = true;
    });

    // Listen to expense changes in real-time
    _expenseSubscription = FirebaseFirestore.instance
        .collection('expenses')
        .snapshots()
        .listen(
          (QuerySnapshot snapshot) {
            Map<String, double> tempExpenseTotal = {
              'Food': 0,
              'Health': 0,
              'Shopping': 0,
              'Subscriptions': 0,
              'Transport': 0,
            };
            for (var doc in snapshot.docs) {
              try {
                Expensmodel expense = Expensmodel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
                if (tempExpenseTotal.containsKey(expense.Expenstype)) {
                  tempExpenseTotal[expense.Expenstype] =
                      (tempExpenseTotal[expense.Expenstype] ?? 0) +
                      expense.value;
                }
              } catch (e) {
                print('Error parsing expense document: $e');
              }
            }
            setState(() {
              expensTypeTotal = tempExpenseTotal;
              isLoading = false;
            });
          },
          onError: (error) {
            print('Error listening to expenses: $error');
            setState(() {
              isLoading = false;
            });
          },
        );

    // Listen to income changes in real-time
    _incomeSubscription = FirebaseFirestore.instance
        .collection('income') // Note: Assuming the collection name is 'income'
        .snapshots()
        .listen(
          (QuerySnapshot snapshot) {
            Map<String, double> tempIncomeTotal = {
              'Freelance': 0,
              'Salary': 0,
              'Sales': 0,
            };
            for (var doc in snapshot.docs) {
              try {
                Incomemodel income = Incomemodel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
                if (tempIncomeTotal.containsKey(income.Incometype)) {
                  tempIncomeTotal[income.Incometype] =
                      (tempIncomeTotal[income.Incometype] ?? 0) + income.value;
                }
              } catch (e) {
                print('Error parsing income document: $e');
              }
            }
            setState(() {
              incomeTypeTotal = tempIncomeTotal;
              isLoading = false;
            });
          },
          onError: (error) {
            print('Error listening to incomes: $error');
            setState(() {
              isLoading = false;
            });
          },
        );
  }

  // Get default income colors
  Map<String, Color> getIncomeColors() {
    try {
      return incomeTypeColor;
    } catch (e) {
      return {
        'Freelance': Color(0xFF4CAF50),
        'Salary': Color(0xFF2196F3),
        'Sales': Color(0xFFFF9800),
      };
    }
  }

  double getTotalValue() {
    if (widget.isIncome) {
      return incomeTypeTotal.values.fold(0, (sum, value) => sum + value);
    } else {
      return expensTypeTotal.values.fold(0, (sum, value) => sum + value);
    }
  }

  String getPercentage() {
    double total = getTotalValue();
    if (total == 0) return "0%";

    double maxValue = 0;
    if (widget.isIncome) {
      maxValue = incomeTypeTotal.values.reduce((a, b) => a > b ? a : b);
    } else {
      maxValue = expensTypeTotal.values.reduce((a, b) => a > b ? a : b);
    }

    return "${((maxValue / total) * 100).toInt()}%";
  }

  List<PieChartSectionData> getCharts() {
    if (widget.isIncome) {
      final colors = getIncomeColors();
      List<PieChartSectionData> sections = [];
      incomeTypeTotal.forEach((type, value) {
        if (value > 0) {
          sections.add(
            PieChartSectionData(
              color: colors[type]!,
              value: value,
              showTitle: false,
              radius: 60,
            ),
          );
        }
      });
      return sections;
    } else {
      List<PieChartSectionData> sections = [];
      expensTypeTotal.forEach((type, value) {
        if (value > 0) {
          sections.add(
            PieChartSectionData(
              color: expenseTypeColors[type]!,
              value: value,
              showTitle: false,
              radius: 60,
            ),
          );
        }
      });
      return sections;
    }
  }

  List<Widget> buildLegend() {
    List<Widget> legendItems = [];
    if (widget.isIncome) {
      final colors = getIncomeColors();
      incomeTypeTotal.forEach((type, value) {
        if (value > 0) {
          legendItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[type],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '$type: L\K\R ${NumberFormatModel.toCompact(value)}',
                    style: TextStyle(color: kMainTextColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }
      });
    } else {
      expensTypeTotal.forEach((type, value) {
        if (value > 0) {
          legendItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: expenseTypeColors[type],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '$type: L\K\R ${NumberFormatModel.toCompact(value)}',
                    style: TextStyle(color: kMainTextColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }
    return legendItems;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 400,
        padding: EdgeInsets.all(kDefultPadding),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: CircularProgressIndicator(color: kSecondaryColor)),
      );
    }
    double totalValue = getTotalValue();
    List<PieChartSectionData> chartSections = getCharts();

    if (totalValue == 0 || chartSections.isEmpty) {
      return Container(
        height: 400,
        padding: EdgeInsets.all(kDefultPadding),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isIncome
                    ? Icons.account_balance_wallet_outlined
                    : Icons.shopping_cart_outlined,
                size: 64,
                color: kSecondaryTextColor,
              ),
              SizedBox(height: 16),
              Text(
                widget.isIncome ? 'No income yet' : 'No expenses yet',
                style: TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add some ${widget.isIncome ? 'income records' : 'expense records'} to see the chart',
                style: TextStyle(color: kSecondaryTextColor, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final PieChartData pieChartData = PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 70,
      startDegreeOffset: -90,
      sections: chartSections,
      borderData: FlBorderData(show: false),
    );

    return Column(
      children: [
        Container(
          height: 300,
          padding: EdgeInsets.all(kDefultPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [kCardColor, kBorDivColor]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(pieChartData),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getPercentage(),
                    style: TextStyle(
                      color: kMainTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'of L\K\R ${NumberFormatModel.toCompact(totalValue)}',
                    style: TextStyle(
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(kDefultPadding),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isIncome ? 'Income Categories' : 'Expense Categories',
                style: TextStyle(
                  color: kMainTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              buildLegend().isEmpty
                  ? Text(
                      'No ${widget.isIncome ? 'income' : 'expense'} categories to display',
                      style: TextStyle(
                        color: kSecondaryTextColor,
                        fontSize: 12,
                      ),
                    )
                  : Wrap(children: buildLegend()),
            ],
          ),
        ),
      ],
    );
  }
}
