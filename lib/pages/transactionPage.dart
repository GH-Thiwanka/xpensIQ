import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/dateFormatModel.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/service/incomeFormService.dart';

class Transactionpage extends StatefulWidget {
  const Transactionpage({super.key});

  @override
  State<Transactionpage> createState() => _TransactionpageState();
}

class _TransactionpageState extends State<Transactionpage> {
  // Function to get the appropriate image based on income type
  final bool isExpens = false;
  String getIncomeTypeImage(String incomeType, bool isExpens) {
    return isExpens
        ? expenseTypeImages[incomeType] ?? 'assets/decrease.png'
        : incomeTypeImages[incomeType] ?? 'assets/increase.png';
  }

  Color getIncomeTypeColor(String incomeType, bool isExpens) {
    return isExpens
        ? expenseTypeColors[incomeType] ?? kExepenceColor.withAlpha(100)
        : incomeTypeColor[incomeType] ?? kBgMaincolor;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kSavingColor,
                        kBorDivColor,
                        Color(0xFFB2DFDB),
                        kBgMaincolor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'See your financial report',

                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: kMainTextColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Income',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: kMainTextColor,
                  ),
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: IncomeFormService().getIncome(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error loding tasks');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No task available');
                    } else {
                      final List<Incomemodel> IncomeList = snapshot.data!;
                      return SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: IncomeList.length,
                          itemBuilder: (context, index) {
                            final Incomemodel incomeModelData =
                                IncomeList[index];
                            return Card(
                              child: ListTile(
                                subtitle: Row(
                                  children: [
                                    // Dynamic image based on income type
                                    Padding(
                                      padding: const EdgeInsets.all(
                                        kDefultPadding,
                                      ),
                                      child: Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          color: getIncomeTypeColor(
                                            incomeModelData.Incometype,
                                            false,
                                          ).withAlpha(50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            kDefultPadding,
                                          ),
                                          child: Image(
                                            image: AssetImage(
                                              getIncomeTypeImage(
                                                incomeModelData.Incometype,
                                                false,
                                              ),
                                            ),
                                            width: 50,
                                            height:
                                                50, // Added height for consistency
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  // Fallback if image fails to load
                                                  return Icon(
                                                    Icons.attach_money,
                                                    size: 50,
                                                    color: Colors.green,
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ),
                                    //SizedBox(width: 12),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            incomeModelData.Incometype,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            incomeModelData.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: kMainTextColor.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                NumberFormatModel.toLKRFormatted(
                                                  incomeModelData.value,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: kMainColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              // Output: LKR 1,500.00
                                              SizedBox(height: 10),

                                              Text(
                                                DateFormatModel.transactionFormat(
                                                  incomeModelData.date,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: kMainTextColor,
                                                ),
                                              ),
                                              // Optional: Show time as well
                                              Text(
                                                DateFormatModel.toTime12Hour(
                                                  incomeModelData.time,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: kMainTextColor
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefultPadding),
                  child: Text(
                    'Expenses',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: kMainTextColor,
                    ),
                  ),
                ),
                SizedBox(),
                StreamBuilder(
                  stream: IncomeFormService().getExpens(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error loding tasks');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No task available');
                    } else {
                      final List<Expensmodel> expensList = snapshot.data!;
                      return SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: expensList.length,
                          itemBuilder: (context, index) {
                            final Expensmodel incomeModelData =
                                expensList[index];
                            return Card(
                              child: ListTile(
                                subtitle: Row(
                                  children: [
                                    // Dynamic image based on income type
                                    Padding(
                                      padding: const EdgeInsets.all(
                                        kDefultPadding,
                                      ),
                                      child: Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          color: getIncomeTypeColor(
                                            incomeModelData.Expenstype,
                                            true,
                                          ).withAlpha(50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            kDefultPadding,
                                          ),
                                          child: Image(
                                            image: AssetImage(
                                              getIncomeTypeImage(
                                                incomeModelData.Expenstype,
                                                true,
                                              ),
                                            ),
                                            width: 50,
                                            height:
                                                50, // Added height for consistency
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  // Fallback if image fails to load
                                                  return Icon(
                                                    Icons.attach_money,
                                                    size: 50,
                                                    color: Colors.green,
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ),
                                    //SizedBox(width: 12),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            incomeModelData.Expenstype,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            incomeModelData.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: kMainTextColor.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                NumberFormatModel.toLKRFormatted(
                                                  incomeModelData.value,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: kExepenceColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              // Output: LKR 1,500.00
                                              SizedBox(height: 10),

                                              Text(
                                                DateFormatModel.transactionFormat(
                                                  incomeModelData.date,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: kMainTextColor,
                                                ),
                                              ),
                                              // Optional: Show time as well
                                              Text(
                                                DateFormatModel.toTime12Hour(
                                                  incomeModelData.time,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: kMainTextColor
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
