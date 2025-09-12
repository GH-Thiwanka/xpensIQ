/*import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/models/expensModel.dart';
import 'package:xpensiq/models/incomeModel.dart';
import 'package:xpensiq/pages/budgetPage.dart';
import 'package:xpensiq/pages/homePage.dart';
//import 'package:xpensiq/pages/homePage.dart';
import 'package:xpensiq/pages/profilePage.dart';
import 'package:xpensiq/pages/transactionPage.dart';

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
    return [Screen1(), Screen2(), Screen4(), Screen5()];
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
      //backgroundColor: kBgMaincolor,
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

// Move calculation logic to a separate service or provider class
class BudgetCalculations {
  static Map<String, double> calculateExpensTypes(
    List<Expensmodel> expensesList,
  ) {
    Map<String, double> typeTotal = {
      'Subscriptions': 0,
      'Food': 0,
      'Health': 0,
      'Shopping': 0,
      'Transport': 0,
    };

    for (Expensmodel expense in expensesList) {
      if (typeTotal.containsKey(expense.Expenstype)) {
        typeTotal[expense.Expenstype] =
            (typeTotal[expense.Expenstype]! + expense.value);
      }
    }
    return typeTotal;
  }

  static Map<String, double> calculateIncomeTypes(
    List<Incomemodel> incomesList,
  ) {
    Map<String, double> typeTotal = {'Freelance': 0, 'Salary': 0, 'Sales': 0};

    for (Incomemodel income in incomesList) {
      if (typeTotal.containsKey(income.Incometype)) {
        typeTotal[income.Incometype] =
            (typeTotal[income.Incometype]! + income.value);
      }
    }
    return typeTotal;
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You should get these lists from your data source (database, provider, etc.)
    // For now, using empty lists as placeholders
    List<Expensmodel> expensesList = [];
    List<Incomemodel> incomesList = [];
    //return const Homepage();
    return Budgetpage(
      expensTypeTotal: BudgetCalculations.calculateExpensTypes(expensesList),
      incomeTypeTotal: BudgetCalculations.calculateIncomeTypes(incomesList),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Transactionpage();
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    // You should get these lists from your data source (database, provider, etc.)
    // For now, using empty lists as placeholders
    List<Expensmodel> expensesList = [];
    List<Incomemodel> incomesList = [];
    return Budgetpage(
      expensTypeTotal: BudgetCalculations.calculateExpensTypes(expensesList),
      incomeTypeTotal: BudgetCalculations.calculateIncomeTypes(incomesList),
    );
  }
}

class Screen5 extends StatelessWidget {
  const Screen5({super.key});

  @override
  Widget build(BuildContext context) {
    return const Profilepage();
  }
}*/
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/pages/budgetPage.dart';
import 'package:xpensiq/pages/homePage.dart';
import 'package:xpensiq/pages/profilePage.dart';
import 'package:xpensiq/pages/transactionPage.dart';

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
    return [
      Screen1(), // Homepage
      Screen2(), // Transactions
      Screen3(), // Budget
      Screen4(), // Profile
    ];
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
  @override
  Widget build(BuildContext context) {
    // Uncomment this line when you have your Homepage implemented
    return const Homepage();

    // For now, returning budget page as placeholder
    // return const Budgetpage();
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Transactionpage();
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Budgetpage();
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return const Profilepage();
  }
}
