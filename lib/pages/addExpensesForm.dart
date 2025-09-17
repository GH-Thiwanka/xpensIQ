import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/service/incomeFormService.dart';

class Addexpensesform extends StatefulWidget {
  final bool isGreen;
  const Addexpensesform({super.key, required this.isGreen});

  @override
  State<Addexpensesform> createState() => _AddexpensesformState();
}

class _AddexpensesformState extends State<Addexpensesform> {
  final _formKey = GlobalKey<FormState>(); // Added a GlobalKey for the Form
  final TextEditingController _title =
      TextEditingController(); // Added Title Controller
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();

  // State variables to act as "controllers" for dropdown values
  IncomeType? _selectedIncomeCategory;
  ExpensType? _selectedExpenseCategory;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _value.dispose();
    super.dispose();
  }

  // Method to get the selected category as a string
  String getSelectedCategory() {
    if (widget.isGreen) {
      return _selectedIncomeCategory?.name ?? '';
    } else {
      return _selectedExpenseCategory?.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color kMainTextColor = widget.isGreen == true ? kMainColor : kExepenceColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefultPadding * 2.5),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: widget.isGreen == true ? kBgMaincolor : Color(0xFFE6C8C8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey, // Assigned the GlobalKey
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefultPadding * 1.5,
              vertical: kDefultPadding * 3,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Dropdown
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: kSecondaryTextColor.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefultPadding * 2,
                    ),
                    child: widget.isGreen
                        ? DropdownButtonFormField<IncomeType>(
                            value: _selectedIncomeCategory,
                            hint: Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 18,
                                color: kMainTextColor.withAlpha(100),
                              ),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: IncomeType.values.map((Type) {
                              return DropdownMenuItem<IncomeType>(
                                value: Type,
                                child: Text(
                                  Type.name,
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (IncomeType? value) {
                              setState(() {
                                _selectedIncomeCategory = value;
                              });
                            },
                            validator: (IncomeType? value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          )
                        : DropdownButtonFormField<ExpensType>(
                            value: _selectedExpenseCategory,
                            hint: Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 18,
                                color: kMainTextColor.withAlpha(100),
                              ),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: ExpensType.values.map((Type) {
                              return DropdownMenuItem<ExpensType>(
                                value: Type,
                                child: Text(
                                  Type.name,
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (ExpensType? value) {
                              setState(() {
                                _selectedExpenseCategory = value;
                              });
                            },
                            validator: (ExpensType? value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                  ),
                ),
                SizedBox(height: 10),

                // Description TextFormField
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: kSecondaryTextColor.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefultPadding * 2,
                    ),
                    child: TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(
                          color: kMainTextColor.withOpacity(0.7),
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Value TextFormField
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: kSecondaryTextColor.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefultPadding * 2,
                    ),
                    child: TextFormField(
                      controller: _value,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Value',
                        hintStyle: TextStyle(
                          color: kMainTextColor.withOpacity(0.7),
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),

                widget.isGreen
                    ? TextButton(
                        onPressed: () async {
                          // Validate that category is selected
                          if (getSelectedCategory().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a category'),
                              ),
                            );
                            return;
                          }

                          // Validate other fields
                          if (_description.text.isEmpty ||
                              _value.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          try {
                            await IncomeFormService().addIncome(
                              getSelectedCategory(), // Using the selected category
                              _description.text,
                              double.parse(_value.text),
                            );

                            // Clear form after successful submission
                            setState(() {
                              _selectedIncomeCategory = null;
                              _selectedExpenseCategory = null;
                            });
                            _title.clear();
                            _description.clear();
                            _value.clear();

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Successfully saved!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                        child: Text('Save', style: TextStyle(fontSize: 24)),
                      )
                    : TextButton(
                        onPressed: () async {
                          // Validate that category is selected
                          if (getSelectedCategory().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a category'),
                              ),
                            );
                            return;
                          }

                          // Validate other fields
                          if (_description.text.isEmpty ||
                              _value.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          try {
                            await IncomeFormService().addExpense(
                              getSelectedCategory(), // Using the selected category
                              _description.text,
                              double.parse(_value.text),
                            );

                            // Clear form after successful submission
                            setState(() {
                              _selectedIncomeCategory = null;
                              _selectedExpenseCategory = null;
                            });
                            _title.clear();
                            _description.clear();
                            _value.clear();

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Successfully saved!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 24,
                            //color: widget.isGreen ? kMainColor : kExepenceColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
