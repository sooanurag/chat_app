import 'package:chat_app/resources/app_fonts.dart';
import 'package:chat_app/resources/app_paths.dart';
import 'package:chat_app/resources/app_strings.dart';
import 'package:chat_app/resources/components/app_comp.dart';
import 'package:chat_app/resources/components/animated_icons.dart';
import 'package:chat_app/resources/components/custom_buttons.dart';
import 'package:chat_app/resources/components/signup_route_components/custom_password_textformfield.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/view_model/auth/signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  final signInFormKey = GlobalKey<FormState>();

  ValueNotifier<String> buttonValue = ValueNotifier<String>("Sign In");
  ValueNotifier<bool> isSendOTP = ValueNotifier<bool>(false);
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final signInProvider = Provider.of<SignInProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Lottie.asset(AnimationPath.signIn,
                  height: screenSize.height * 0.4),
              Text(
                "Sign-In!",
                style: AppFonts.headerStyled(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Utils.divider,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: signInFormKey,
                  child: Column(
                    children: [
                      Utils.customTextFormField(
                          inputController: emailController,
                          invalidText: (signInProvider.isSignInWithEmail)
                              ? AppStrings.emailInvalid
                              : "",
                          label: AppStrings.textFieldLabels[0],
                          prefixIcon: LottieIcons.email,
                          isEnabled: signInProvider.isSignInWithEmail,
                          onChanged: (inputValue) {
                            if (inputValue.isNotEmpty) {
                              signInProvider.setSignInWithPhoneStatus(
                                  status: false);
                            } else if (inputValue.isEmpty) {
                              signInProvider.setSignInWithPhoneStatus(
                                  status: true);
                            }
                          }),
                      Utils.divider,
                      passwordTextFormField(
                        isEnabled: signInProvider.isSignInWithEmail,
                        obscureText: obscureText,
                        passwordController: passwordController,
                        invalidText: (signInProvider.isSignInWithEmail)
                            ? AppStrings.passwordInvalid
                            : "",
                        label: AppStrings.textFieldLabels[1],
                      ),
                      AppComponents.orDivider,
                      ValueListenableBuilder(
                          valueListenable: isSendOTP,
                          builder: (context, value, child) {
                            return (!isSendOTP.value)
                                ? Utils.customTextFormField(
                                    inputController: phoneController,
                                    invalidText:
                                        (signInProvider.isSignInWithPhone)
                                            ? AppStrings.phoneInvalid
                                            : "",
                                    label: "Phone",
                                    prefixIcon: LottieIcons.phone,
                                    isEnabled: signInProvider.isSignInWithPhone,
                                    onChanged: (inputValue) {
                                      if (inputValue.isNotEmpty) {
                                        signInProvider.setSignInWithEmailStatus(
                                            status: false);
                                        buttonValue.value = "Send OTP";
                                      } else if (inputValue.isEmpty) {
                                        signInProvider.setSignInWithEmailStatus(
                                            status: true);
                                        buttonValue.value = "Sign In";
                                      }
                                    },
                                  )
                                : Utils.customTextFormField(
                                    inputController: otpController,
                                    invalidText: (buttonValue.value == "Verify")
                                        ? "Enter recived OTP!"
                                        : "",
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
                                onPress: () async {
                                  if (signInFormKey.currentState!.validate()) {
                                    debugPrint("validate:true");
                                    await signInProvider.onPress(
                                      buttonValue: buttonValue,
                                      isSendOTP: isSendOTP,
                                      emailController: emailController,
                                      passwordController: passwordController,
                                      phoneController: phoneController,
                                      otpController: otpController,
                                      context: context,
                                    );
                                  }
                                },
                                title: buttonValue.value);
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
