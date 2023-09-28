import 'package:chat_app/resources/app_fonts.dart';
import 'package:chat_app/resources/app_paths.dart';
import 'package:chat_app/resources/components/custom_buttons.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../resources/app_strings.dart';
import '../../view_model/theme/theme_manager.dart';

class WelcomeRoute extends StatefulWidget {
  const WelcomeRoute({super.key});

  @override
  State<WelcomeRoute> createState() => _WelcomeRouteState();
}

class _WelcomeRouteState extends State<WelcomeRoute> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: PageView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    SplashRouteStrings.headerList[index],
                    style: AppFonts.headerStyled(
                        color: (themeManager.themeMode == ThemeMode.light)
                            ? SplashRouteStrings.colors[index]
                            : Colors.white,
                        fontSize: 28),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Lottie.asset('${AnimationPath.welcomeBase}${index + 1}.json',
                      height: screenSize.height * 0.3),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    SplashRouteStrings.footerList[index],
                    style: GoogleFonts.markaziText(
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (index == 3)
                    CustomButton().roundedButton(
                      title: "Create account",
                      onPress: () {
                        // Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushNamed(
                            context, RouteName.authSignUp);
                      },
                    ),
                  if (index == 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have account?"),
                        TextButton(
                          onPressed: () {
                            // Navigator.popUntil(
                            //     context, (route) => route.isFirst);
                            Navigator.pushNamed(
                                context, RouteName.authSignIn);
                          },
                          child: const Text("Sign In."),
                        ),
                      ],
                    ),
                  if (index == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Swipe to explore",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 22),
                          ),
                          VerticalDivider(),
                          Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  if (index != 0 && index != 3)
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 40,
                    ),
                ]);
          }),
    );
  }
}
