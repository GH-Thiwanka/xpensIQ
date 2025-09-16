/*import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/homePage.dart';
import 'package:xpensiq/pages/registerPage.dart';
import 'package:xpensiq/service/userService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Email validation function
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /* Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String email = _email.text.trim();
      String password = _password.text;

      bool success = await Userservice.signInUser(
        email: email,
        password: password,
        context: context,
      );

      if (success && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
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
*/
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
                  'Welcome',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Back to XpensIQ',
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!_isValidEmail(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: kBorDivColor),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: kSecondaryTextColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: kSecondaryTextColor.withAlpha(100),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: kBorDivColor),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: kSecondaryTextColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kSecondaryTextColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: kSecondaryTextColor.withAlpha(100),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  // onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: _isLoading ? Colors.grey : kSecondaryColor,
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: kSecondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registerpage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/homePage.dart';
import 'package:xpensiq/pages/registerPage.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/bottumNavBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Load remembered credentials if available
  Future<void> _loadRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberedEmail = prefs.getString('remembered_email');
      final shouldRemember = prefs.getBool('remember_me') ?? false;

      if (shouldRemember && rememberedEmail != null) {
        setState(() {
          _email.text = rememberedEmail;
          _rememberMe = true;
        });
      }
    } catch (e) {
      print('Error loading remembered credentials: $e');
    }
  }

  // Save credentials if remember me is checked
  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_rememberMe) {
        await prefs.setString('remembered_email', _email.text.trim());
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('remembered_email');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  // Email validation function
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Handle login process
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Show loading dialog
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
                  'Signing in...',
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

      String email = _email.text.trim();
      String password = _password.text;

      bool success = await Userservice.signInUser(
        email: email,
        password: password,
        context: context,
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (success) {
        // Save credentials if remember me is checked
        await _saveCredentials();

        // Navigate to home page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Welcome back!'),
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
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Login failed: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                // Welcome text
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Back to XpensIQ',
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),

                // Login form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email field
                      TextFormField(
                        controller: _email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!_isValidEmail(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: kBorDivColor),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: kSecondaryTextColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: kSecondaryTextColor.withAlpha(100),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),

                      const SizedBox(height: 20),

                      // Password field
                      TextFormField(
                        controller: _password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: kBorDivColor),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: kSecondaryTextColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kSecondaryTextColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: kSecondaryTextColor.withAlpha(100),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Remember me checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: kSecondaryColor,
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(
                        color: kSecondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Forgot password feature coming soon',
                            ),
                            backgroundColor: kMainColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Sign in button
                GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: _isLoading ? Colors.grey : kSecondaryColor,
                      boxShadow: _isLoading
                          ? null
                          : [
                              BoxShadow(
                                color: kSecondaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: kSecondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Registerpage(),
                                ),
                              );
                            },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: _isLoading ? Colors.grey : kMainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Optional: Social login buttons section
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Divider(color: kBorDivColor)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: kBorDivColor)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onTap: () {
                            // Handle Google login
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Google login coming soon'),
                                backgroundColor: kMainColor,
                              ),
                            );
                          },
                        ),
                        _buildSocialButton(
                          icon: Icons.facebook,
                          label: 'Facebook',
                          onTap: () {
                            // Handle Facebook login
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Facebook login coming soon'),
                                backgroundColor: kMainColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build social login buttons
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: kSecondaryTextColor.withAlpha(100)),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: kSecondaryTextColor),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: kSecondaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
