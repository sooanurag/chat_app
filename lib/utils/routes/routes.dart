
import 'package:chat_app/view/authRoute/sign_in_route.dart';
import 'package:chat_app/view/authRoute/sign_up_route.dart';
import 'package:chat_app/view/homeRoute/chatspace_route.dart';
import 'package:chat_app/view/homeRoute/home_route.dart';
import 'package:chat_app/view/homeRoute/profile_route.dart';
import 'package:chat_app/view/homeRoute/search_route.dart';
import 'package:chat_app/view/splashRoute/splash_route.dart';
import 'package:chat_app/view/splashRoute/wlcome_route.dart';
import 'package:flutter/material.dart';

import 'route_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (context) => const SplashRoute());
      case RouteName.welcome:
        return MaterialPageRoute(builder: (context) => const WelcomeRoute());
      case RouteName.authSignIn:
        return MaterialPageRoute(builder: (context) => const SignInRoute());
      case RouteName.authSignUp:
        return MaterialPageRoute(builder: (context) => const SignUpRoute());
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const HomeRoute());
      case RouteName.profile:
        return MaterialPageRoute(builder: (context) => const ProfileRoute());
      case RouteName.search:
        return MaterialPageRoute(builder: (context) => const SearchRoute());
      case RouteName.chats:
        return MaterialPageRoute(builder: (context) => const ChatSpaceRoute());
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text("Invaid Route"),
                  ),
                ));
    }
  }
}
