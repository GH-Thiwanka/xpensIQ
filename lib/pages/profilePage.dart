import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Uncomment if using Firebase
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/widget/profileWidgets.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  bool _isLoggingOut = false;

  // Enhanced logout confirmation dialog
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: kExepenceColor, size: 28),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: kMainTextColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              fontSize: 16,
              color: kSecondaryTextColor,
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kExepenceColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),

              onPressed: _isLoggingOut
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _performLogout();
                    },
              child: _isLoggingOut
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  // Complete logout functionality
  Future<void> _performLogout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
                ),
                SizedBox(height: 16),
                Text(
                  'Logging out...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kMainTextColor,
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Clear all user data
      await _clearUserData();

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to login screen and clear navigation stack
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Replace with your actual login route
          (Route<dynamic> route) => false,
        );
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Successfully logged out'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle logout error
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Logout failed. Please try again.')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  // Comprehensive data clearing
  Future<void> _clearUserData() async {
    try {
      // Clear SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Alternative: Clear specific keys only
      // await prefs.remove('user_token');
      // await prefs.remove('user_id');
      // await prefs.remove('user_email');
      // await prefs.remove('remember_me');

      // Clear Firebase Auth (if using Firebase)
      // await FirebaseAuth.instance.signOut();

      // Clear any other authentication services
      // await GoogleSignIn().signOut();
      // await FacebookAuth.instance.logOut();

      // Clear app-specific data
      // UserManager.instance.clearUser();
      // AppState.reset();
      // DatabaseHelper.instance.clearAllData();

      // Clear cached data
      // await DefaultCacheManager().emptyCache();

      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
      rethrow; // Re-throw to handle in _performLogout
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgMaincolor.withOpacity(0.3),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefultPadding * 1.5,
            vertical: kDefultPadding * 2,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            color: kBgMaincolor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // Header section with profile info
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile image with modern styling
                        Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.27,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3, color: kMainColor),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: kMainColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/clock.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(width: 16),

                        // User info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                  color: kSecondaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Iriana Saliha',
                                style: TextStyle(
                                  color: kMainTextColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Edit button with modern styling
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kMainColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: kMainColor.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            color: kMainColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Menu items
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Profilewidgets(title: 'My Wallet', icon: Icons.wallet),
                        Divider(
                          color: kBorDivColor.withOpacity(0.3),
                          height: 1,
                        ),
                        Profilewidgets(title: 'Settings', icon: Icons.settings),
                        Divider(
                          color: kBorDivColor.withOpacity(0.3),
                          height: 1,
                        ),
                        Profilewidgets(
                          title: 'Export Data',
                          icon: Icons.file_download_outlined,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Enhanced logout button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _isLoggingOut ? null : _showLogoutDialog,
                        child: Opacity(
                          opacity: _isLoggingOut ? 0.6 : 1.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: kExepenceColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: _isLoggingOut
                                      ? SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  kExepenceColor,
                                                ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.logout_rounded,
                                          size: 28,
                                          color: kExepenceColor,
                                        ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _isLoggingOut ? 'Logging out...' : 'Logout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: kMainTextColor,
                                    ),
                                  ),
                                ),
                                if (!_isLoggingOut)
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: kSecondaryTextColor,
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
