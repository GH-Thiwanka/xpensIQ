// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:xpensiq/constants/color.dart';
// import 'package:xpensiq/models/expensModel.dart';
// import 'package:xpensiq/models/incomeModel.dart';
// import 'package:xpensiq/pages/addExpensesForm.dart';
// import 'package:xpensiq/pages/addIncomePage.dart';
// import 'package:xpensiq/pages/registerPage.dart';
// import 'package:xpensiq/service/userService.dart';
// import 'package:xpensiq/widget/recentlyAdd.dart';
// import 'dart:async';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   Map<String, double> expensTypeTotal = {
//     'Food': 0,
//     'Health': 0,
//     'Shopping': 0,
//     'Subscriptions': 0,
//     'Transport': 0,
//   };

//   Map<String, double> incomeTypeTotal = {
//     'Freelance': 0,
//     'Salary': 0,
//     'Sales': 0,
//   };

//   Future<void> _fetchData() async {
//     try {
//       setState(() {
//         CircularProgressIndicator();
//       });

//       // Fetch expenses
//       QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
//           .collection('expenses')
//           .get();
//       expensTypeTotal = {
//         'Food': 0,
//         'Health': 0,
//         'Shopping': 0,
//         'Subscriptions': 0,
//         'Transport': 0,
//       };
//       for (var doc in expenseSnapshot.docs) {
//         Expensmodel expense = Expensmodel.fromJson(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         );
//         expensTypeTotal[expense.Expenstype] =
//             (expensTypeTotal[expense.Expenstype] ?? 0) + expense.value;
//       }

//       // Fetch incomes
//       QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
//           .collection('income')
//           .get();
//       incomeTypeTotal = {'Freelance': 0, 'Salary': 0, 'Sales': 0};
//       for (var doc in incomeSnapshot.docs) {
//         Incomemodel income = Incomemodel.fromJson(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         );
//         incomeTypeTotal[income.Incometype] =
//             (incomeTypeTotal[income.Incometype] ?? 0) + income.value;
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     } finally {
//       setState(() {});
//     }
//   }

//   // New function to calculate total income
//   double _calculateTotalIncome() {
//     return incomeTypeTotal.values.fold(0.0, (sum, value) => sum + value);
//   }

//   // New function to calculate total expenses
//   double _calculateTotalExpenses() {
//     return expensTypeTotal.values.fold(0.0, (sum, value) => sum + value);
//   }

//   final TextEditingController _taskConraller = TextEditingController();
//   //for store username
//   String username = '';
//   @override
//   void dispose() {
//     _taskConraller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     Userservice.getUserData().then((value) {
//       if (value['username'] != null) {
//         setState(() {
//           username = value['username']!;
//         });
//       }
//     });
//     _fetchData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: kBgMaincolor,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Addincomepage()),
//             );
//           },
//           child: Icon(Icons.add_rounded, size: 36, color: kSecondaryTextColor),
//         ),
//         backgroundColor: kBgMaincolor.withOpacity(0.35),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.height * 0.3,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [kBgMaincolor, Color(0xFFB2DFDB)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.vertical(
//                         bottom: Radius.circular(50),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 0),
//                               child: Container(
//                                 width: 55,
//                                 height: 55,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 3,
//                                     color: kMainColor,
//                                   ),
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(55),
//                                   child: Image.asset(
//                                     'assets/increase.png',
//                                     width: 55,
//                                     height: 55,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.65,
//                               child: Text(
//                                 'Welcome $username',
//                                 style: TextStyle(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.notifications_rounded,
//                                 color: kSecondaryColor,
//                                 size: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: kDefultPadding * 1.5,
//                           vertical: kDefultPadding * 2.5,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.45,
//                               height: MediaQuery.of(context).size.width * 0.27,
//                               decoration: BoxDecoration(
//                                 color: kMainColor,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(
//                                   kDefultPadding * 1.5,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Stack(
//                                           children: [
//                                             Container(
//                                               width: 50,
//                                               decoration: BoxDecoration(
//                                                 color: Color(
//                                                   0xff06FFA5,
//                                                 ).withAlpha(100),
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     blurRadius: 10,
//                                                     color: Colors.black12,
//                                                     offset: Offset(4, 2),
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 child: Icon(
//                                                   Icons.trending_up_rounded,
//                                                   size: 45,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           width:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width *
//                                               0.015,
//                                         ),
//                                         Text(
//                                           'Income',
//                                           style: TextStyle(
//                                             color: kCardColor,
//                                             fontSize: 26,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.width *
//                                           0.025,
//                                     ),
//                                     Text(
//                                       'LKR ${_calculateTotalIncome().toStringAsFixed(2)}',
//                                       style: TextStyle(
//                                         color: kCardColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.45,
//                               height: MediaQuery.of(context).size.width * 0.27,
//                               decoration: BoxDecoration(
//                                 color: kExepenceColor,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(
//                                   kDefultPadding * 1.5,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 50,
//                                           decoration: BoxDecoration(
//                                             color: kAlertWarColor.withOpacity(
//                                               0.5,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               20,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 blurRadius: 10,
//                                                 color: Colors.black12,
//                                                 offset: Offset(4, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                               20,
//                                             ),
//                                             child: Icon(
//                                               Icons.trending_down_rounded,
//                                               size: 45,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width *
//                                               0.015,
//                                         ),
//                                         Text(
//                                           'Expense',
//                                           style: TextStyle(
//                                             color: kCardColor,
//                                             fontSize: 26,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.width *
//                                           0.025,
//                                     ),
//                                     Text(
//                                       'LKR ${_calculateTotalExpenses().toStringAsFixed(2)}',
//                                       style: TextStyle(
//                                         color: kCardColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: kDefultPadding * 1.5,
//                   left: kDefultPadding * 1.5,
//                   right: kDefultPadding * 1.5,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Recently Added Expenses',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 22,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Information'),
//                               content: Text(
//                                 'This section displays your 10 most recently added expense entries, sorted by date to help you quickly review your latest spending activity.',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       icon: Icon(
//                         Icons.info_outline_rounded,
//                         color: kBlueColor,
//                         size: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               RecentTransactionsList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/pages/addExpensesForm.dart';
import 'package:xpensiq/pages/addIncomePage.dart';
import 'package:xpensiq/pages/registerPage.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/recentlyAdd.dart';
import 'dart:async';

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

  // Listeners for real-time updates
  StreamSubscription? _expensesSubscription;
  StreamSubscription? _incomesSubscription;

  Future<void> _fetchData() async {
    try {
      // Clear previous totals before fetching new data
      expensTypeTotal = {
        'Food': 0,
        'Health': 0,
        'Shopping': 0,
        'Subscriptions': 0,
        'Transport': 0,
      };
      incomeTypeTotal = {'Freelance': 0, 'Salary': 0, 'Sales': 0};

      // Real-time listener for expenses
      _expensesSubscription = FirebaseFirestore.instance
          .collection('expenses')
          .snapshots()
          .listen((expenseSnapshot) {
            double totalExpenses = 0;
            for (var doc in expenseSnapshot.docs) {
              Expensmodel expense = Expensmodel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
              totalExpenses += expense.value;
            }
            setState(() {
              expensTypeTotal['total'] = totalExpenses;
            });
          });

      // Real-time listener for incomes
      _incomesSubscription = FirebaseFirestore.instance
          .collection('income')
          .snapshots()
          .listen((incomeSnapshot) {
            double totalIncome = 0;
            for (var doc in incomeSnapshot.docs) {
              Incomemodel income = Incomemodel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
              totalIncome += income.value;
            }
            setState(() {
              incomeTypeTotal['total'] = totalIncome;
            });
          });
    } catch (e) {
      print('Error setting up data listeners: $e');
    }
  }

  double _calculateTotalIncome() {
    return incomeTypeTotal['total'] ?? 0.0;
  }

  double _calculateTotalExpenses() {
    return expensTypeTotal['total'] ?? 0.0;
  }

  final TextEditingController _taskConraller = TextEditingController();
  String username = '';

  @override
  void dispose() {
    _taskConraller.dispose();
    _expensesSubscription?.cancel();
    _incomesSubscription?.cancel();
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
          backgroundColor: kBgMaincolor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Addincomepage()),
            );
          },
          child: const Icon(
            Icons.add_rounded,
            size: 36,
            color: kSecondaryTextColor,
          ),
        ),
        backgroundColor: kBgMaincolor.withOpacity(0.35),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: const BoxDecoration(
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
                                  border: Border.all(
                                    width: 3,
                                    color: kMainColor,
                                  ),
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
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
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
                              height: MediaQuery.of(context).size.width * 0.27,
                              decoration: BoxDecoration(
                                color: kMainColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  kDefultPadding * 1.5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xff06FFA5,
                                                ).withAlpha(100),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    color: Colors.black12,
                                                    offset: Offset(4, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: const Icon(
                                                  Icons.trending_up_rounded,
                                                  size: 45,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.015,
                                        ),
                                        const Text(
                                          'Income',
                                          style: TextStyle(
                                            color: kCardColor,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.025,
                                    ),
                                    Text(
                                      NumberFormatModel.toLKRFormatted(
                                        _calculateTotalIncome(),
                                      ),
                                      style: const TextStyle(
                                        color: kCardColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.width * 0.27,
                              decoration: BoxDecoration(
                                color: kExepenceColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  kDefultPadding * 1.5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: kAlertWarColor.withOpacity(
                                              0.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 10,
                                                color: Colors.black12,
                                                offset: Offset(4, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: const Icon(
                                              Icons.trending_down_rounded,
                                              size: 45,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.015,
                                        ),
                                        const Text(
                                          'Expense',
                                          style: TextStyle(
                                            color: kCardColor,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.025,
                                    ),
                                    Text(
                                      NumberFormatModel.toLKRFormatted(
                                        _calculateTotalExpenses(),
                                      ),
                                      style: const TextStyle(
                                        color: kCardColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: kDefultPadding * 1.5,
                  left: kDefultPadding * 1.5,
                  right: kDefultPadding * 1.5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Recently Added Expenses',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Information'),
                              content: const Text(
                                'This section displays your 10 most recently added expense entries, sorted by date to help you quickly review your latest spending activity.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        color: kBlueColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              RecentTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }
}
