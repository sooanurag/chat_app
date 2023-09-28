import 'package:flutter/material.dart';

import '../app_strings.dart';

class CustomButton {
  roundedButton({required VoidCallback onPress, required String title, Color? color }) => InkWell(
        radius: 50,
        borderRadius: BorderRadius.circular(30),
        onTap: onPress,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: color ?? SplashRouteStrings.colors[3],
            borderRadius: BorderRadius.circular(30),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      );

      
}
