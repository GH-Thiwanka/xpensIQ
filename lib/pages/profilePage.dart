import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/widget/profileWidgets.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                              bottomRight: Radius.circular(60),
                              bottomLeft: Radius.circular(60),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width * 0.27,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: kMainColor),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset('assets/clock.png'),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Iriana Saliha',
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  offset: Offset(2, 4),
                                  color: Colors.black12,
                                ),
                              ],
                              color: kMainTextColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kDefultPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.edit_rounded, size: 40),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Profilewidgets(title: 'My Wallet', icon: Icons.wallet),
                  Divider(color: kBorDivColor, height: 5),
                  Profilewidgets(title: 'Settings', icon: Icons.settings),
                  Divider(color: kBorDivColor, height: 5),
                  Profilewidgets(
                    title: 'Export Data',
                    icon: Icons.file_download_outlined,
                  ),
                  Divider(color: kBorDivColor, height: 5),
                  Padding(
                    padding: const EdgeInsets.all(kDefultPadding * 2),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: kExepenceColor.withAlpha(40),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            size: 38,
                            color: kExepenceColor,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: kMainTextColor,
                          ),
                        ),
                      ],
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
