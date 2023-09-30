import 'package:chat_app/resources/components/signup_route_components/custom_password_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../../view_model/auth/signup_provider.dart';
import '../../app_strings.dart';
import '../animated_icons.dart';

import '../app_comp.dart';
import '../custom_buttons.dart';

 signUpForm({
    required emailController,
    required passwordController,
    required cPasswordController,
    required phoneController,
    required otpController,
    required VoidCallback onPress,
    required GlobalKey formKey,
    required BuildContext context,
  }) {
    ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
    ValueNotifier<bool> cObscureText = ValueNotifier<bool>(true);
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Utils.customTextFormField(
                inputController: emailController,
                invalidText: (signUpProvider.emailPasswordValidator)? AppStrings.emailInvalid:"",
                label: AppStrings.textFieldLabels[0],
                prefixIcon: LottieIcons.email,
                isEnabled: signUpProvider.isEnabled,
                onChanged: (inputValue) {
                  if (inputValue.isNotEmpty) {
                    signUpProvider.setPhoneEnableStatus(status: false);
                  } else {
                    signUpProvider.setPhoneEnableStatus(status: true);
                  }
                }),
            Utils.divider,
            passwordTextFormField(isEnabled: signUpProvider.isEnabled,
              obscureText: obscureText,
              passwordController: passwordController,
              invalidText: (signUpProvider.emailPasswordValidator)? AppStrings.passwordInvalid:"",
              label: AppStrings.textFieldLabels[1],),
            Utils.divider,
            passwordTextFormField(
              obscureText: cObscureText,
              passwordController: cPasswordController,
              invalidText:(signUpProvider.emailPasswordValidator)? AppStrings.cPasswordInvalid:"",
              label: AppStrings.textFieldLabels[2],
              isEnabled: signUpProvider.isEnabled,
            ),
            
            AppComponents.orDivider,
            Consumer<SignUpProvider>(builder: (context, value, child) {
              return Column(
                children: [
                  (value.isPhone)
                      ? Utils.customTextFormField(
                          isEnabled: signUpProvider.isPhoneEnabled,
                          inputController: phoneController,
                          invalidText: "",
                          label: AppStrings.textFieldLabels[3],
                          prefixIcon: LottieIcons.phone,
                          onChanged: (inputValue) {
                            if (inputValue.isNotEmpty) {
                              value.setButtonValue(buttonTitle: "Send OTP");
                              signUpProvider.setEnableStatus(status: false);
                              signUpProvider.setemailPasswordValidatorStatus(
                                  status: false);
                            } else {
                              value.setButtonValue(buttonTitle: "Sign Up");
                              signUpProvider.setEnableStatus(status: true);
                              signUpProvider.setemailPasswordValidatorStatus(
                                  status: true);
                            }
                          })
                      : Utils.customTextFormField(
                          inputController: otpController,
                          invalidText: "",
                          label: "Enter OTP",
                          prefixIcon: LottieIcons.lock,
                          hint: "Enter OTP"),
                  Utils.divider,
                  CustomButton().roundedButton(
                    onPress: onPress,
                    title: value.buttonTitle,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }