import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/dateFormatModel.dart';
import 'package:xpensiq/models/doubleValue.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/service/incomeFormService.dart';

class Transactionpage extends StatefulWidget {
  final String userId;
  const Transactionpage({required this.userId, super.key});

  @override
  State<Transactionpage> createState() => _TransactionpageState();
}

class _TransactionpageState extends State<Transactionpage> {
  final IncomeFormService _service = IncomeFormService();

  // Function to get the appropriate image based on income type
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

  // Method to show edit dialog for income
  void _showEditIncomeDialog(Incomemodel income) {
    final TextEditingController descriptionController = TextEditingController(
      text: income.description,
    );
    final TextEditingController valueController = TextEditingController(
      text: income.value.toString(),
    );
    String selectedIncomeType = income.Incometype;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Income'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Income Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedIncomeType,
                      decoration: InputDecoration(
                        labelText: 'Income Type',
                        border: OutlineInputBorder(),
                      ),
                      items: incomeTypeImages.keys.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedIncomeType = newValue;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    // Description Field
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Value Field
                    TextField(
                      controller: valueController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // A separate variable to hold a valid context.
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      double value = double.parse(valueController.text);
                      await _service.updateIncome(
                        income.id,
                        selectedIncomeType,
                        descriptionController.text,
                        value,
                      );
                      navigator.pop();
                      messenger.showSnackBar(
                        SnackBar(content: Text('Income updated successfully!')),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Error updating income: $e')),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to show edit dialog for expense
  void _showEditExpenseDialog(Expensmodel expense) {
    final TextEditingController descriptionController = TextEditingController(
      text: expense.description,
    );
    final TextEditingController valueController = TextEditingController(
      text: expense.value.toString(),
    );
    String selectedExpenseType = expense.Expenstype;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Expense Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedExpenseType,
                      decoration: InputDecoration(
                        labelText: 'Expense Type',
                        border: OutlineInputBorder(),
                      ),
                      items: expenseTypeImages.keys.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedExpenseType = newValue;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    // Description Field
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Value Field
                    TextField(
                      controller: valueController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      double value = double.parse(valueController.text);
                      await _service.updateExpense(
                        expense.id,
                        selectedExpenseType,
                        descriptionController.text,
                        value,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Expense updated successfully!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating expense: $e')),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to show delete confirmation dialog
  void _showDeleteDialog(String id, bool isIncome) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${isIncome ? 'Income' : 'Expense'}'),
          content: Text(
            'Are you sure you want to delete this ${isIncome ? 'income' : 'expense'}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                try {
                  if (isIncome) {
                    await _service.deleteIncome(id);
                  } else {
                    await _service.deleteExpense(id);
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${isIncome ? 'Income' : 'Expense'} deleted successfully!',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error deleting ${isIncome ? 'income' : 'expense'}: $e',
                      ),
                    ),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Build transaction card with edit/delete options
  Widget _buildTransactionCard({
    required dynamic transaction,
    required bool isIncome,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dynamic image based on transaction type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(kDefultPadding),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: getIncomeTypeColor(
                              isIncome
                                  ? transaction.Incometype
                                  : transaction.Expenstype,
                              !isIncome,
                            ).withAlpha(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefultPadding),
                            child: Image(
                              image: AssetImage(
                                getIncomeTypeImage(
                                  isIncome
                                      ? transaction.Incometype
                                      : transaction.Expenstype,
                                  !isIncome,
                                ),
                              ),
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.attach_money,
                                  size: 50,
                                  color: isIncome ? Colors.green : Colors.red,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Transaction details
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isIncome
                                  ? transaction.Incometype
                                  : transaction.Expenstype,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              transaction.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kMainTextColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Amount and date info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberFormatModel.toLKRFormatted(transaction.value),
                        style: TextStyle(
                          fontSize: 16,
                          color: isIncome ? kMainColor : kExepenceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        DateFormatModel.transactionFormat(transaction.date),
                        style: TextStyle(fontSize: 12, color: kMainTextColor),
                      ),
                      Text(
                        DateFormatModel.toTime12Hour(transaction.time),
                        style: TextStyle(
                          fontSize: 10,
                          color: kMainTextColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),

                  //SizedBox(width: 20),
                ],
              ),
            ),
            SizedBox(width: 15),
            // Edit and Delete buttons
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: () {
                    if (isIncome) {
                      _showEditIncomeDialog(transaction as Incomemodel);
                    } else {
                      _showEditExpenseDialog(transaction as Expensmodel);
                    }
                  },
                  constraints: BoxConstraints(
                    minWidth: kDefultPadding,
                    minHeight: kDefultPadding,
                  ),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    _showDeleteDialog(transaction.id, isIncome);
                  },
                  constraints: BoxConstraints(
                    minWidth: kDefultPadding,
                    minHeight: kDefultPadding,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgMaincolor.withOpacity(0.3),
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
                  stream: _service.getIncome(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading income: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('No income records available'),
                        ),
                      );
                    } else {
                      final List<Incomemodel> incomeList = snapshot.data!;

                      // Calculate dynamic height
                      double cardHeight =
                          MediaQuery.of(context).size.height *
                          0.15; // Approximate height of each card
                      double calculatedHeight = incomeList.length * cardHeight;
                      double maxHeight =
                          MediaQuery.of(context).size.height * 0.45;
                      double dynamicHeight = calculatedHeight > maxHeight
                          ? maxHeight
                          : calculatedHeight;
                      return SizedBox(
                        height: dynamicHeight,
                        child: ListView.builder(
                          itemCount: incomeList.length,
                          itemBuilder: (context, index) {
                            return _buildTransactionCard(
                              transaction: incomeList[index],
                              isIncome: true,
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
                StreamBuilder(
                  stream: _service.getExpens(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading expenses: ${snapshot.error}',
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('No expense records available'),
                        ),
                      );
                    } else {
                      final List<Expensmodel> expensesList = snapshot.data!;

                      // Calculate dynamic height
                      double cardHeight =
                          MediaQuery.of(context).size.height *
                          0.15; // Approximate height of each card
                      double calculatedHeight =
                          expensesList.length * cardHeight;
                      double maxHeight =
                          MediaQuery.of(context).size.height * 0.45;
                      double dynamicHeight = calculatedHeight > maxHeight
                          ? maxHeight
                          : calculatedHeight;
                      return SizedBox(
                        height: dynamicHeight,
                        child: ListView.builder(
                          itemCount: expensesList.length,
                          itemBuilder: (context, index) {
                            return _buildTransactionCard(
                              transaction: expensesList[index],
                              isIncome: false,
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
