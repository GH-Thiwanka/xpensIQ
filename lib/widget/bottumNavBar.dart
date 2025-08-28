import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/homePage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return const [Screen1(), Screen2(), Screen3(), Screen4(), Screen5()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: "Home",
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: kSecondaryTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.payments_rounded),
        title: "Transaction",
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: kSecondaryTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_rounded),
        title: 'add',
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: kSecondaryTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.pie_chart_rounded),
        title: "Budget",
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: kSecondaryTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_rounded),
        title: "Profile",
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: kSecondaryTextColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.all(8),
      backgroundColor: kBgMaincolor,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style9,
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Homepage();
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Screen 2', style: TextStyle(fontSize: 40))),
    );
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Screen 3', style: TextStyle(fontSize: 40))),
    );
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Screen 4', style: TextStyle(fontSize: 40))),
    );
  }
}

class Screen5 extends StatelessWidget {
  const Screen5({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Screen 5', style: TextStyle(fontSize: 40))),
    );
  }
}
