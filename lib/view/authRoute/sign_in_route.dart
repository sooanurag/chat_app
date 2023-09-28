import 'package:chat_app/resources/app_fonts.dart';
import 'package:chat_app/resources/app_paths.dart';
import 'package:chat_app/resources/app_strings.dart';
import 'package:chat_app/resources/components/app_components.dart';
import 'package:chat_app/resources/components/animated_icons.dart';
import 'package:chat_app/resources/components/custom_buttons.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({super.key});

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  ValueNotifier<String> buttonValue = ValueNotifier<String>("Sign In");
  ValueNotifier<bool> isSendOTP = ValueNotifier<bool>(false);
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Lottie.asset(AnimationPath.signIn,
                  height: screenSize.height * 0.4),
              Text(
                "Sign-In!",
                style: AppFonts.headerStyled(fontSize: 24),
              ),
              Utils.divider,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Utils.customTextFormField(
                      inputController: emailController,
                      invalidText: AppStrings.emailInvalid,
                      label: AppStrings.textFieldLabels[0],
                      prefixIcon: LottieIcons.email,
                    ),
                    Utils.divider,
                    SignUpRouteCompotents.passwordTextField(
                      obscureText: obscureText,
                      passwordController: passwordController,
                      invalidText: AppStrings.passwordInvalid,
                      label: AppStrings.textFieldLabels[1],
                    ),
                    SignUpRouteCompotents.orDivider,
                    ValueListenableBuilder(
                        valueListenable: isSendOTP,
                        builder: (context, value, child) {
                          return (!isSendOTP.value)
                              ? Utils.customTextFormField(
                                  inputController: phoneController,
                                  invalidText: "",
                                  label: "Phone",
                                  prefixIcon: LottieIcons.phone,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      buttonValue.value = "Send OTP";
                                    } else {
                                      buttonValue.value = "Sign In";
                                    }
                                  },
                                )
                              : Utils.customTextFormField(
                                  inputController: otpController,
                                  invalidText: "",
                                  label: "Enter OTP",
                                  hint: "Enter OTP",
                                  prefixIcon: LottieIcons.lock,
                                );
                        }),
                    Utils.divider,
                    ValueListenableBuilder(
                        valueListenable: buttonValue,
                        builder: (context, value, child) {
                          return CustomButton().roundedButton(
                              onPress: () {
                                if (buttonValue.value == "Sign in") {
                                } else if (buttonValue.value == "Send OTP") {
                                  isSendOTP.value = true;
                                  buttonValue.value = "Verify OTP";
                                } else if (buttonValue.value == "Verify OTP") {}
                              },
                              title: buttonValue.value);
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
