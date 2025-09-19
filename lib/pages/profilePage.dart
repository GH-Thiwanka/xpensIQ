import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/widget/profileWidgets.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/pages/loginPage.dart';

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

  // Complete logout functionality that properly clears navigation stack
  Future<void> _performLogout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    bool isDialogOpen = false;

    try {
      // Show loading dialog
      if (mounted) {
        isDialogOpen = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
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
              ),
            );
          },
        );
      }

      // Clear user data
      await _clearUserData();

      // Wait a bit for data clearing
      await Future.delayed(Duration(milliseconds: 800));

      // Close loading dialog
      if (isDialogOpen && mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        isDialogOpen = false;
      }

      // Reset state
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }

      // IMPORTANT: Navigate with complete stack clearing
      if (mounted) {
        // Method 1: Use pushAndRemoveUntil with rootNavigator
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
            settings: RouteSettings(name: '/login'),
          ),
          (Route<dynamic> route) => false, // This removes ALL routes
        );

        // Alternative method if the above doesn't work:
        // You can also try this approach
        /*
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Make sure you have this route defined in your MaterialApp
          (Route<dynamic> route) => false,
        );
        */
      }

      // Show success message after navigation
      Future.delayed(Duration(milliseconds: 1000), () {
        // Only show if we're still in a valid context
        try {
          if (mounted && Navigator.canPop(context)) {
            return; // Don't show if we can still navigate back
          }
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
        } catch (e) {
          // Ignore any context errors after navigation
          print('Context no longer valid after logout - this is expected');
        }
      });
    } catch (e) {
      // Handle logout error
      if (isDialogOpen && mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        isDialogOpen = false;
      }

      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });

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
    }
  }

  // Clear user data
  Future<void> _clearUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear all user-related keys
      await prefs.remove('user_token');
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('is_logged_in');

      // Clear UserService data if available
      try {
        if (Userservice.getCurrentUserId() != null) {
          // Add your UserService logout method here if available
          // await Userservice.logout();
        }
      } catch (e) {
        print('UserService logout error: $e');
      }

      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
      rethrow;
    }
  }

  // Handle profile menu item taps
  void _handleMenuTap(String title) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title tapped - Feature coming soon!'),
        backgroundColor: kMainColor,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Handle edit profile tap
  void _handleEditProfile() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit profile - Feature coming soon!'),
        backgroundColor: kMainColor,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
                        // Profile image
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

                        // Edit button
                        GestureDetector(
                          onTap: _handleEditProfile,
                          child: Container(
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
                        GestureDetector(
                          onTap: () => _handleMenuTap('My Wallet'),
                          child: Profilewidgets(
                            title: 'My Wallet',
                            icon: Icons.wallet,
                          ),
                        ),
                        Divider(
                          color: kBorDivColor.withOpacity(0.3),
                          height: 1,
                        ),
                        GestureDetector(
                          onTap: () => _handleMenuTap('Settings'),
                          child: Profilewidgets(
                            title: 'Settings',
                            icon: Icons.settings,
                          ),
                        ),
                        Divider(
                          color: kBorDivColor.withOpacity(0.3),
                          height: 1,
                        ),
                        GestureDetector(
                          onTap: () => _handleMenuTap('Export Data'),
                          child: Profilewidgets(
                            title: 'Export Data',
                            icon: Icons.file_download_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Logout button
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
