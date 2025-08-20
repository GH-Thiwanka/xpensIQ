import 'package:xpensiq/models/onboarding_model.dart';

class OnboardingData {
  static final List<Onboarding> onboardingList = [
    Onboarding(
      onImage: 'assets/stcon.png',
      onTitle: 'Stay in Control of\nYour Money',
      onDescription:
          'Log your daily expenses in seconds and see where your money goes without any hassle.',
    ),
    Onboarding(
      onImage: 'assets/un.png',
      onTitle: 'Understand Your\nSpending Habits',
      onDescription:
          'Get clear charts and reports to make better financial decisions and save more each month.',
    ),
    Onboarding(
      onImage: 'assets/sv.png',
      onTitle: 'Save Smarter,\nLive Better',
      onDescription:
          'Set budgets and track your progress toward your goals whether it\'s saving for travel, shopping, or bills.',
    ),
  ];
}
