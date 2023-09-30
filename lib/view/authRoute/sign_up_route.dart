import 'dart:async';

import 'package:chat_app/resources/app_fonts.dart';
import 'package:chat_app/resources/app_paths.dart';
import 'package:chat_app/resources/components/signup_route_components/choose_profilepic.dart';
import 'package:chat_app/resources/components/signup_route_components/complete_profile_form.dart';
import 'package:chat_app/resources/components/signup_route_components/signup_form.dart';
import 'package:chat_app/view_model/auth/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({super.key});

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final aboutController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  final completeProfileKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    aboutController.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: ListView(
          children: [
            Consumer<SignUpProvider>(builder: (context, value, child) {
              timerFuction() {
                Timer(
                  const Duration(seconds: 3),
                  () {
                    value.setLoadingStatus(true);
                  },
                );
              }

              return Column(
                children: [
                  (!value.isLoading)
                      ? Lottie.asset(AnimationPath.signUp,
                          height: screenSize.height * 0.35)
                      : chooseProfilePicture(
                          background: Container(
                            margin: const EdgeInsets.all(20),
                            height: screenSize.height * 0.2,
                            child: ValueListenableBuilder(
                                valueListenable: Utils.imageFile,
                                builder: (context, value, child) {
                                  return CircleAvatar(
                                    radius: 100,
                                    backgroundImage:
                                        (Utils.imageFile.value != null)
                                            ? FileImage(
                                                Utils.imageFile.value!,
                                              )
                                            : null,
                                    child: (Utils.imageFile.value == null)
                                        ? Utils.profileDefault
                                        : null,
                                  );
                                }),
                          ),
                          context: context,
                        ),
                  Utils.divider,
                  (!value.isLoading)
                      ? Text(
                          "Create Account!",
                          style: AppFonts.headerStyled(fontSize: 22),
                        )
                      : Text(
                          "Complete Profile!",
                          style: AppFonts.headerStyled(fontSize: 22),
                        ),
                  Utils.divider,
                  Consumer<SignUpProvider>(builder: (context, value, child) {
                    final signUpProvider =
                        Provider.of<SignUpProvider>(context, listen: false);
                    return (!value.isAccountCreated)
                        ? signUpForm(
                            context: context,
                            emailController: emailController,
                            passwordController: passwordController,
                            cPasswordController: cPasswordController,
                            phoneController: phoneController,
                            otpController: otpController,
                            formKey: signUpFormKey,
                            onPress: () async {
                              debugPrint("onPress call");
                              debugPrint(signUpFormKey.currentState!
                                  .validate()
                                  .toString());
                              if (value.buttonTitle == "Sign Up" ||
                                  value.buttonTitle == "Verify") {
                                if (signUpFormKey.currentState!.validate()) {
                                  debugPrint(value.buttonTitle);
                                  (value.buttonTitle == "Sign Up")
                                      ? await value
                                          .createAccountWithEmailPassowrd(
                                          context: context,
                                          email: emailController.text,
                                          password: passwordController.text,
                                        )
                                      : await value.createAccountWithPhone(
                                          context: context,
                                          phone: phoneController.text,
                                          otp: otpController.text,
                                        );
                                  if (!signUpProvider.isExceptionOccured) {
                                    value.setAccountCreateStatus(true);
                                    timerFuction();
                                  }
                                }
                              } else if (value.buttonTitle == "Send OTP") {
                                if (signUpFormKey.currentState!.validate()) {
                                  value.verifyPhone(
                                      phone: phoneController.text,context: context,);
                                }
                                signUpProvider.setPhoneStatus(false);
                                signUpProvider.setButtonValue(
                                    buttonTitle: "Verify");
                              }
                            },
                          )
                        : (!value.isLoading)
                            ? Lottie.asset(
                                AnimationPath.loadingTwo,
                                repeat: false,
                              )
                            : completeProfileForm(
                                formKey: completeProfileKey,
                                firstNameController: firstNameController,
                                lastNameController: lastNameController,
                                aboutController: aboutController,
                                onPress: () async {
                                  if (completeProfileKey.currentState!
                                      .validate()) {
                                    signUpProvider.updateUserData(
                                      context: context,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      info: aboutController.text,
                                      profilePicture: (Utils.imageFile.value !=
                                              null)
                                          ? await signUpProvider
                                              .uploadDataToStorage(
                                                  imageFile:
                                                      Utils.imageFile.value!,
                                                  context: context)
                                          : null,
                                    );
                                    debugPrint("saved user data");
                                  }
                                },
                              );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    ));
  }
}
