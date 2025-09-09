import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

class Budgetpage extends StatefulWidget {
  const Budgetpage({super.key});

  @override
  State<Budgetpage> createState() => _BudgetpageState();
}

class _BudgetpageState extends State<Budgetpage> {
  bool _showPageState = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _showPageState == false ? kMainColor : kExepenceColor,

        body: Column(
          children: [
            Text(
              'Financial Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(kDefultPadding * 2),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: kBorDivColor,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 5),
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(kDefultPadding * 0.3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPageState = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.435,
                          decoration: BoxDecoration(
                            color: _showPageState == true
                                ? kBorDivColor
                                : kMainColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'Income',
                              style: TextStyle(
                                fontSize: 22,
                                color: _showPageState == true
                                    ? kMainTextColor
                                    : kBorDivColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kDefultPadding * 0.3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPageState = true;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.435,
                          decoration: BoxDecoration(
                            color: _showPageState == false
                                ? kBorDivColor
                                : kExepenceColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'Expense',
                              style: TextStyle(
                                fontSize: 22,
                                color: _showPageState == false
                                    ? kMainTextColor
                                    : kBorDivColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
