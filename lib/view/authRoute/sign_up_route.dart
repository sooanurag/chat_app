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
                              try {
                                await signUpProvider.onPressSignUpForm(
                                  signUpFormKey: signUpFormKey,
                                  value: value,
                                  context: context,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  cpasswordController: cPasswordController,
                                  phoneController: phoneController,
                                  otpController: otpController,
                                  signUpProvider: signUpProvider,
                                  timerFuction: timerFuction,
                                );
                              } catch (e) {
                                if(mounted){
                                ShowDialogModel.alertDialog(
                                    context, "Warning", Text(e.toString()), [
                                  TextButton(
                                    onPressed: () {
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("close"),
                                  )
                                ]);}
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
                                  await signUpProvider
                                      .onPressCompleteProfileForm(
                                    completeProfileKey: completeProfileKey,
                                    signUpProvider: signUpProvider,
                                    context: context,
                                    firstNameController: firstNameController,
                                    lastNameController: lastNameController,
                                    aboutController: aboutController,
                                  );
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
