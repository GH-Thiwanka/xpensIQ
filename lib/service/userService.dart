import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userservice {
  static Future<void> storeUserDetails({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      //check password and confirm password are same
      if (password != confirmPassword) {
        //show massage to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password and Comfirm Password do not match')),
        );
        return;
      }
      //create an instance from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //store the user name and email as key value pairs
      await prefs.setString('username', userName);
      await prefs.setString('email', email);

      //show a massage to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User Details stored Successfully')),
      );
    } catch (err) {
      err.toString();
    }
  }

  //methord to cheack username is saved in the shared prefarances
  static Future<bool> checkUserName() async {
    //create an instence for shared prefareance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');
    return userName != null;
  }

  //get the username and the email
  static Future<Map<String, String>> getUserData() async {
    //create an instens for shared perfarances
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? userName = pref.getString('username');
    String? email = pref.getString('email');

    return {'username': userName!, 'email': email!};
  }
}
