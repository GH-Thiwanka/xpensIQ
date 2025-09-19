import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/service/incomeFormService.dart';

class Addexpensesform extends StatefulWidget {
  final bool isGreen;
  final String userId;

  const Addexpensesform({
    super.key,
    required this.isGreen,
    required this.userId,
  });

  @override
  State<Addexpensesform> createState() => _AddexpensesformState();
}

class _AddexpensesformState extends State<Addexpensesform> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();

  // State variables for dropdown values
  IncomeType? _selectedIncomeCategory;
  ExpensType? _selectedExpenseCategory;
  bool _isLoading = false;

  @override
  void dispose() {
    _description.dispose();
    _value.dispose();
    super.dispose();
  }

  // Helper method to convert enum to string
  String _getEnumString(dynamic enumValue) {
    if (enumValue == null) return '';
    return enumValue.toString().split('.').last;
  }

  // Method to validate form and submit
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if category is selected
    if ((widget.isGreen && _selectedIncomeCategory == null) ||
        (!widget.isGreen && _selectedExpenseCategory == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.isGreen) {
        // Add income - convert enum to string for your service
        await IncomeFormService().addIncome(
          widget.userId,
          _getEnumString(_selectedIncomeCategory),
          _description.text.trim(),
          double.parse(_value.text.trim()),
        );
      } else {
        // Add expense - convert enum to string for your service
        await IncomeFormService().addExpense(
          widget.userId,
          _getEnumString(_selectedExpenseCategory),
          _description.text.trim(),
          double.parse(_value.text.trim()),
        );
      }

      // Clear form after successful submission
      _clearForm();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isGreen
                  ? 'Income added successfully!'
                  : 'Expense added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Method to clear form
  void _clearForm() {
    setState(() {
      _selectedIncomeCategory = null;
      _selectedExpenseCategory = null;
    });
    _description.clear();
    _value.clear();
  }

  @override
  Widget build(BuildContext context) {
    Color kMainTextColor = widget.isGreen ? kMainColor : kExepenceColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefultPadding * 2.5),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: widget.isGreen ? kBgMaincolor : const Color(0xFFE6C8C8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
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
                              'Select Income Category',
                              style: TextStyle(
                                fontSize: 18,
                                color: kMainTextColor.withAlpha(100),
                              ),
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: IncomeType.values.map((type) {
                              return DropdownMenuItem<IncomeType>(
                                value: type,
                                child: Text(
                                  type.toString().split('.').last,
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
                                return 'Please select an income category';
                              }
                              return null;
                            },
                          )
                        : DropdownButtonFormField<ExpensType>(
                            value: _selectedExpenseCategory,
                            hint: Text(
                              'Select Expense Category',
                              style: TextStyle(
                                fontSize: 18,
                                color: kMainTextColor.withAlpha(100),
                              ),
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: ExpensType.values.map((type) {
                              return DropdownMenuItem<ExpensType>(
                                value: type,
                                child: Text(
                                  type.toString().split('.').last,
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
                                return 'Please select an expense category';
                              }
                              return null;
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 10),

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
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Enter description',
                        hintStyle: TextStyle(
                          color: kMainTextColor.withOpacity(0.7),
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.trim().length < 3) {
                          return 'Description must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

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
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(
                          color: kMainTextColor.withOpacity(0.7),
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an amount';
                        }

                        final parsedValue = double.tryParse(value.trim());
                        if (parsedValue == null) {
                          return 'Please enter a valid number';
                        }

                        if (parsedValue <= 0) {
                          return 'Amount must be greater than 0';
                        }

                        if (parsedValue > 999999999) {
                          return 'Amount is too large';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isGreen
                          ? kMainColor
                          : kExepenceColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Save ${widget.isGreen ? "Income" : "Expense"}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
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
