import 'package:flutter/material.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({super.key});

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("signIN"),),);
  }
}