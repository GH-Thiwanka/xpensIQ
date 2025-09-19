import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/addExpensesForm.dart';

class Addincomepage extends StatefulWidget {
  const Addincomepage({super.key});

  @override
  State<Addincomepage> createState() => _AddincomepageState();
}

class _AddincomepageState extends State<Addincomepage> {
  int _showPageState = 0;
  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      // You can return a different widget here, like a login screen or a loading indicator
      return Center(child: Text('Please log in to add transactions.'));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                              _showPageState = 0;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.435,
                            decoration: BoxDecoration(
                              color: _showPageState == 1
                                  ? kBorDivColor
                                  : kMainColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: _showPageState == 1
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
                              _showPageState = 1;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.435,
                            decoration: BoxDecoration(
                              color: _showPageState == 0
                                  ? kBorDivColor
                                  : kExepenceColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: _showPageState == 0
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Image.asset(
                _showPageState == 0
                    ? 'assets/income.png'
                    : 'assets/expenses.png',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Pass the user ID to the Addexpensesform widget
              Addexpensesform(isGreen: _showPageState == 0, userId: user.uid),
            ],
          ),
        ),
      ),
    );
  }
}
