import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/data/onboarding_data.dart';
import 'package:xpensiq/pages/registerPage.dart';
import 'package:xpensiq/screens/front_page.dart';
import 'package:xpensiq/screens/shared_onboarding.dart';
import 'package:xpensiq/widget/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool showDetalsPage = false;
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kMainTextColor,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                showDetalsPage = index == 3;
              });
            },
            children: [
              FrontPage(),
              SharedOnboarding(
                title: OnboardingData.onboardingList[0].onTitle,
                image: OnboardingData.onboardingList[0].onImage,
                description: OnboardingData.onboardingList[0].onDescription,
              ),
              SharedOnboarding(
                title: OnboardingData.onboardingList[1].onTitle,
                image: OnboardingData.onboardingList[1].onImage,
                description: OnboardingData.onboardingList[1].onDescription,
              ),

              SharedOnboarding(
                title: OnboardingData.onboardingList[2].onTitle,
                image: OnboardingData.onboardingList[2].onImage,
                description: OnboardingData.onboardingList[2].onDescription,
              ),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.6),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: WormEffect(
                activeDotColor: kMainColor,
                dotColor: kBorDivColor,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: showDetalsPage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registerpage(),
                          ),
                        );
                      },
                      child: CustomButton(
                        btnName: showDetalsPage ? 'Get start' : 'Next',
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _controller.animateToPage(
                          _controller.page!.toInt() + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: CustomButton(
                        btnName: showDetalsPage ? 'Get start' : 'Next',
                      ),
                    ),
            ),
          ),
          if (!showDetalsPage)
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                onPressed: () {
                  _controller.animateToPage(
                    3,
                    duration: Duration(microseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Skip",
                        style: TextStyle(fontSize: 18, color: kSecondaryColor),
                      ),
                      Icon(Icons.arrow_forward, color: kSecondaryColor),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
