import 'package:flutter/material.dart';

import '../app_strings.dart';

class CustomButton {
  roundedButton({required VoidCallback onPress}) => InkWell(
        radius: 50,
        borderRadius: BorderRadius.circular(30),
        onTap: onPress,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: SplashRouteStrings.colors[3],
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              "Create account",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      );
}
