import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/addExpensesForm.dart';
import 'package:xpensiq/pages/addForm.dart';
import 'package:xpensiq/pages/addIncomePage.dart';
import 'package:xpensiq/pages/registerPage.dart';
import 'package:xpensiq/service/userService.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                            color: Color(0xff70FF00).withAlpha(100),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 1.5, color: kMainColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefultPadding * 1.5),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
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
                                    child: Image.asset(
                                      'assets/increase.png',
                                      width: 60,
                                      fit: BoxFit.cover,
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
                                        'Income',
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '\$5000',
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 26,
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
                            color: kExepenceColor.withAlpha(100),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 1.5,
                              color: kExepenceColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefultPadding * 1.5),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE56C6C).withAlpha(100),
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
                                    child: Image.asset(
                                      'assets/decrease.png',
                                      width: 60,
                                      fit: BoxFit.cover,
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '\$5000',
                                        style: TextStyle(
                                          color: kCardColor,
                                          fontSize: 26,
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
            ],
          ),
        ),
      ),
    );
  }
}
