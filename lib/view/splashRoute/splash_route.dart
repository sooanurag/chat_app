import 'dart:async';

import 'package:chat_app/resources/app_paths.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashRoute extends StatefulWidget {
  const SplashRoute({super.key});

  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, RouteName.welcome);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(AnimationPath.splash),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "by Anurag Gupta",
            ),
          ],
        ),
      ),
    );
  }
}
