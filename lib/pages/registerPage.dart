import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/homePage.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/button.dart';
import 'package:xpensiq/widget/txtField.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confrm = TextEditingController();
  bool _rememberMe = false;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confrm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefultPadding,
              vertical: 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'for XpensIQ',
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          controller: _name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                          },
                          obscureText: false,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: kBorDivColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: kSecondaryTextColor.withAlpha(100),
                                width: 1.5,
                              ), // default border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.green.withAlpha(150),
                                width: 2.0,
                              ), // focused border color
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                        ),

                        TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Email';
                            }
                          },
                          obscureText:
                              false, // usually email shouldn't be hidden
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: kBorDivColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: kBorDivColor,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.green.withAlpha(150),
                                width: 2.0,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                        ),

                        //SizedBox(height: 15), // spacing between fields
                        TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Password';
                            }
                          },
                          obscureText: true,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: kBorDivColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: kBorDivColor,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.green.withAlpha(150),
                                width: 2.0,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                        ),

                        //SizedBox(height: 15),
                        TextFormField(
                          controller: _confrm,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Confirm Password';
                            }
                          },
                          obscureText: true,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(color: kBorDivColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: kBorDivColor,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.green.withAlpha(150),
                                width: 2.0,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                    Text(
                      'Remember Me for the next time',
                      style: TextStyle(
                        color: kSecondaryTextColor.withAlpha(120),
                        fontSize: 20,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        activeColor: kSecondaryColor,
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  },
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        String userName = _name.text;
                        String email = _email.text;
                        String password = _password.text;
                        String conPassword = _confrm.text;

                        await Userservice.storeUserDetails(
                          userName: userName,
                          email: email,
                          password: password,
                          confirmPassword: conPassword,
                          context: context,
                        );

                        //navigate to the home page
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Homepage();
                              },
                            ),
                          );
                        }
                      }
                    },
                    child: CustomButton(btnName: 'Next'),
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
