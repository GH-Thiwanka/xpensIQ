import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';

class Addform extends StatefulWidget {
  final bool isGreen;
  const Addform({super.key, required this.isGreen});

  @override
  State<Addform> createState() => _AddformState();
}

class _AddformState extends State<Addform> {
  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.isGreen == true ? kMainColor : kExepenceColor;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: kBorDivColor.withAlpha(150),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        //border: Border.all(width: 2, color: kBgMaincolor),
      ),
      child: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefultPadding * 1.5,
            vertical: kDefultPadding * 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: borderColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefultPadding * 2,
                  ),
                  child: widget.isGreen
                      ? DropdownButtonFormField(
                          hint: Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 18,
                              color: kMainTextColor.withAlpha(100),
                            ),
                          ),
                          decoration: InputDecoration(border: InputBorder.none),
                          items: IncomeType.values.map((Type) {
                            return DropdownMenuItem(
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
                          onChanged: (value) {},
                        )
                      : DropdownButtonFormField(
                          hint: Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 18,
                              color: kMainTextColor.withAlpha(100),
                            ),
                          ),
                          decoration: InputDecoration(border: InputBorder.none),
                          items: ExpensType.values.map((Type) {
                            return DropdownMenuItem(
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
                          onChanged: (value) {},
                        ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: borderColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefultPadding * 2,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hint: Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 18,
                          color: kMainTextColor.withAlpha(100),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      color: kMainTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: borderColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefultPadding * 2,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hint: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          color: kMainTextColor.withAlpha(100),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      color: kMainTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: borderColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefultPadding * 2,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hint: Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 18,
                          color: kMainTextColor.withAlpha(100),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      color: kMainTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
