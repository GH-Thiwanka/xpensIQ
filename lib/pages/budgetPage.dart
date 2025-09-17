import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/widget/pieChart.dart';

class Budgetpage extends StatefulWidget {
  const Budgetpage({super.key});

  @override
  State<Budgetpage> createState() => _BudgetpageState();
}

class _BudgetpageState extends State<Budgetpage> {
  bool _showIncome = true; // true for expenses, false for income

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgMaincolor.withOpacity(0.3),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefultPadding),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Financial Report',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kMainTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                // Toggle buttons
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: kBorDivColor,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 5),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Income button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showIncome = true;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: !_showIncome
                                  ? Colors.transparent
                                  : kMainColor,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: !_showIncome
                                  ? null
                                  : [
                                      BoxShadow(
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                        color: kMainColor.withOpacity(0.3),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: !_showIncome
                                      ? kSecondaryTextColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Expense button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showIncome = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _showIncome
                                  ? Colors.transparent
                                  : kExepenceColor,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: _showIncome
                                  ? null
                                  : [
                                      BoxShadow(
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                        color: kExepenceColor.withOpacity(0.3),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _showIncome
                                      ? kSecondaryTextColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Pie chart
                Cards(isIncome: _showIncome),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
