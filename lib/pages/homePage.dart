import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/dateFormatModel.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/pages/addIncomePage.dart';
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
    'total': 0,
  };

  Map<String, double> incomeTypeTotal = {
    'Freelance': 0,
    'Salary': 0,
    'Sales': 0,
    'total': 0,
  };

  // Listeners for real-time updates
  StreamSubscription? _expensesSubscription;
  StreamSubscription? _incomesSubscription;
  String? userId;
  String username = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserAndData();
  }

  Future<void> _initializeUserAndData() async {
    try {
      // Get current user ID first
      userId = Userservice.getCurrentUserId();

      if (userId == null) {
        print('User not logged in.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get user data with proper user isolation
      final userData = await Userservice.getUserData();
      if (userData['username'] != null) {
        setState(() {
          username = userData['username']!;
        });
      }

      // Set up real-time data listeners with user isolation
      await _setupDataListeners();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setupDataListeners() async {
    if (userId == null) return;

    try {
      // Cancel existing subscriptions if any
      await _expensesSubscription?.cancel();
      await _incomesSubscription?.cancel();

      // Initialize totals
      _resetTotals();

      // Real-time listener for expenses with user isolation
      _expensesSubscription = FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen(
            (expenseSnapshot) {
              _processExpenseData(expenseSnapshot);
            },
            onError: (error) {
              print('Error listening to expenses: $error');
            },
          );

      // Real-time listener for incomes with user isolation
      _incomesSubscription = FirebaseFirestore.instance
          .collection('income')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen(
            (incomeSnapshot) {
              _processIncomeData(incomeSnapshot);
            },
            onError: (error) {
              print('Error listening to income: $error');
            },
          );
    } catch (e) {
      print('Error setting up data listeners: $e');
    }
  }

  void _resetTotals() {
    expensTypeTotal = {
      'Food': 0,
      'Health': 0,
      'Shopping': 0,
      'Subscriptions': 0,
      'Transport': 0,
      'total': 0,
    };
    incomeTypeTotal = {'Freelance': 0, 'Salary': 0, 'Sales': 0, 'total': 0};
  }

  void _processExpenseData(QuerySnapshot expenseSnapshot) {
    if (!mounted) return;

    // Reset expense totals
    Map<String, double> newExpenseTotals = {
      'Food': 0,
      'Health': 0,
      'Shopping': 0,
      'Subscriptions': 0,
      'Transport': 0,
      'total': 0,
    };

    double totalExpenses = 0;

    for (var doc in expenseSnapshot.docs) {
      try {
        final data = doc.data() as Map<String, dynamic>;

        // Double-check user isolation at data processing level
        if (data['userId'] != userId) {
          print('Warning: Received expense data for different user');
          continue;
        }

        Expensmodel expense = Expensmodel.fromJson(data, doc.id);
        totalExpenses += expense.value;

        // Add to category total if category exists
        if (newExpenseTotals.containsKey(expense.Expenstype)) {
          newExpenseTotals[expense.Expenstype] =
              (newExpenseTotals[expense.Expenstype] ?? 0) + expense.value;
        }
      } catch (e) {
        print('Error processing expense document ${doc.id}: $e');
      }
    }

    newExpenseTotals['total'] = totalExpenses;

    setState(() {
      expensTypeTotal = newExpenseTotals;
    });
  }

  void _processIncomeData(QuerySnapshot incomeSnapshot) {
    if (!mounted) return;

    // Reset income totals
    Map<String, double> newIncomeTotals = {
      'Freelance': 0,
      'Salary': 0,
      'Sales': 0,
      'total': 0,
    };

    double totalIncome = 0;

    for (var doc in incomeSnapshot.docs) {
      try {
        final data = doc.data() as Map<String, dynamic>;

        // Double-check user isolation at data processing level
        if (data['userId'] != userId) {
          print('Warning: Received income data for different user');
          continue;
        }

        Incomemodel income = Incomemodel.fromJson(data, doc.id);
        totalIncome += income.value;

        // Add to category total if category exists
        if (newIncomeTotals.containsKey(income.Incometype)) {
          newIncomeTotals[income.Incometype] =
              (newIncomeTotals[income.Incometype] ?? 0) + income.value;
        }
      } catch (e) {
        print('Error processing income document ${doc.id}: $e');
      }
    }

    newIncomeTotals['total'] = totalIncome;

    setState(() {
      incomeTypeTotal = newIncomeTotals;
    });
  }

  double _calculateTotalIncome() {
    return incomeTypeTotal['total'] ?? 0.0;
  }

  double _calculateTotalExpenses() {
    return expensTypeTotal['total'] ?? 0.0;
  }

  double _calculateBalance() {
    return _calculateTotalIncome() - _calculateTotalExpenses();
  }

  // Method to refresh data manually if needed
  Future<void> _refreshData() async {
    if (userId != null) {
      await _setupDataListeners();
    }
  }

  String currentDate = DateFormatModel.toFullDate(DateTime.now());

  @override
  void dispose() {
    _expensesSubscription?.cancel();
    _incomesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while initializing
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show login prompt if user is not authenticated
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Please log in to view your expenses',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login page or trigger login
                  // You can implement this based on your app's navigation
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          padding: const EdgeInsets.all(kDefultPadding * 1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentDate,
                                    style: TextStyle(
                                      color: kSecondaryTextColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Text(
                                      'Hello, ${username.isNotEmpty ? username : 'User'}',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  // Implement notifications with user isolation
                                },
                                icon: const Icon(
                                  Icons.menu,
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
                              // Income Card
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.width * 0.27,
                                decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    kDefultPadding * 1.5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
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
                              // Expense Card
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.width * 0.27,
                                decoration: BoxDecoration(
                                  color: kExepenceColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    kDefultPadding * 1.5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: kAlertWarColor.withOpacity(
                                                0.5,
                                              ),
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
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
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
                // MAIN CHANGE: Pass userId to ensure user isolation in the recent transactions list
                RecentTransactionsList(userId: userId!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
