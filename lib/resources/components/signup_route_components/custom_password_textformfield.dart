import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../animated_icons.dart';

passwordTextFormField({
    required ValueNotifier<bool> obscureText,
    required passwordController,
    required String invalidText,
    required String label,
    required isEnabled,
  }) {
    return ValueListenableBuilder(
        valueListenable: obscureText,
        builder: (context, value, child) {
          return Utils.customTextFormField(
            isEnabled: isEnabled,
            inputController: passwordController,
            invalidText: invalidText,
            label: label,
            prefixIcon: LottieIcons.lock,
            obscure: obscureText.value,
            suffixIcon: (obscureText.value)
                ? IconButton(
                    onPressed: () {
                      obscureText.value = !obscureText.value;
                    },
                    icon: const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      obscureText.value = !obscureText.value;
                    },
                    icon: const Icon(
                      Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
          );
        });
  }
