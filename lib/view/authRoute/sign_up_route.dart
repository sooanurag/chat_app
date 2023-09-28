import 'package:flutter/material.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({super.key});

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("signUp"),),
    );
  }
}