import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/pages/addExpensesForm.dart';
import 'package:xpensiq/pages/addForm.dart';
import 'package:xpensiq/pages/addIncomePage.dart';
import 'package:xpensiq/pages/registerPage.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/recentlyAdd.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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

  Future<void> _fetchData() async {
    try {
      setState(() {
        CircularProgressIndicator();
      });

      // Fetch expenses
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .get();
      expensTypeTotal = {
        'Food': 0,
        'Health': 0,
        'Shopping': 0,
        'Subscriptions': 0,
        'Transport': 0,
      };
      for (var doc in expenseSnapshot.docs) {
        Expensmodel expense = Expensmodel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        expensTypeTotal[expense.Expenstype] =
            (expensTypeTotal[expense.Expenstype] ?? 0) + expense.value;
      }

      // Fetch incomes
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('income')
          .get();
      incomeTypeTotal = {'Freelance': 0, 'Salary': 0, 'Sales': 0};
      for (var doc in incomeSnapshot.docs) {
        Incomemodel income = Incomemodel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        incomeTypeTotal[income.Incometype] =
            (incomeTypeTotal[income.Incometype] ?? 0) + income.value;
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {});
    }
  }

  // New function to calculate total income
  double _calculateTotalIncome() {
    return incomeTypeTotal.values.fold(0.0, (sum, value) => sum + value);
  }

  // New function to calculate total expenses
  double _calculateTotalExpenses() {
    return expensTypeTotal.values.fold(0.0, (sum, value) => sum + value);
  }

  final TextEditingController _taskConraller = TextEditingController();
  //for store username
  String username = '';
  @override
  void dispose() {
    _taskConraller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Userservice.getUserData().then((value) {
      if (value['username'] != null) {
        setState(() {
          username = value['username']!;
        });
      }
    });
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Addincomepage()),
            );
          },
          backgroundColor: kBgMaincolor,
          child: Icon(Icons.add_rounded, size: 36, color: kSecondaryTextColor),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kBgMaincolor, Color(0xFFB2DFDB)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: kMainColor),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Image.asset(
                                'assets/increase.png',
                                width: 55,
                                height: 55,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            'Welcome $username',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_rounded,
                            color: kSecondaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefultPadding * 1.5,
                      vertical: kDefultPadding * 2.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 100,
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefultPadding * 1.5),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xff06FFA5).withAlpha(100),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black12,
                                        offset: Offset(4, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Icon(Icons.wallet, size: 45),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kDefultPadding,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _calculateTotalIncome().toStringAsFixed(
                                          2,
                                        ),
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 100,
                          decoration: BoxDecoration(
                            color: kExepenceColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefultPadding * 1.5),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: kAlertWarColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black12,
                                        offset: Offset(4, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Icon(
                                      Icons.money_off_rounded,
                                      size: 45,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kDefultPadding,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Expenses',
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _calculateTotalExpenses()
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Recentlyadd(),
            ],
          ),
        ),
      ),
    );
  }
}
