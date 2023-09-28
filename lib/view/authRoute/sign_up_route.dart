import 'dart:async';

import 'package:chat_app/resources/app_fonts.dart';
import 'package:chat_app/resources/app_paths.dart';
import 'package:chat_app/resources/components/app_components.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final aboutController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    ValueNotifier<bool> isAccountCreated = ValueNotifier<bool>(false);
    ValueNotifier<bool> isSuccess = ValueNotifier<bool>(false);

    timerFuction() {
      Timer(const Duration(seconds: 3), () {
        isSuccess.value = true;
      });
    }

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: isSuccess,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      (!isSuccess.value)
                          ? Lottie.asset(AnimationPath.signUp,
                              height: screenSize.height * 0.35)
                          : SignUpRouteCompotents.profilePicure(
                              context: context,
                              background: Container(
                                margin: const EdgeInsets.all(20),
                                height: screenSize.height * 0.2,
                                child: ValueListenableBuilder(
                                    valueListenable: Utils.imageFile,
                                    builder: (context, value, child) {
                                      return CircleAvatar(
                                        radius: 300,
                                        backgroundImage:(Utils.imageFile.value != null) ?FileImage(
                                          Utils.imageFile.value!,
                                        ): null,
                                        child:(Utils.imageFile.value == null)? Utils.profileDefault: null,
                                      );
                                    }),
                              ),
                            ),
                      Utils.divider,
                      (!isSuccess.value)
                          ? Text(
                              "Create Account!",
                              style: AppFonts.headerStyled(fontSize: 22),
                            )
                          : Text(
                              "Complete Profile!",
                              style: AppFonts.headerStyled(fontSize: 22),
                            ),
                      Utils.divider,
                    ],
                  );
                }),
            ValueListenableBuilder(
                valueListenable: isAccountCreated,
                builder: (context, value, child) {
                  return (!isAccountCreated.value)
                      ? SignUpRouteCompotents.signUpContainer(
                          emailController: emailController,
                          passwordController: passwordController,
                          cPasswordController: cPasswordController,
                          phoneController: phoneController,
                          onPress: () {
                            isAccountCreated.value = true;
                            timerFuction();
                          },
                        )
                      : ValueListenableBuilder(
                          valueListenable: isSuccess,
                          builder: (context, value, child) {
                            return (!isSuccess.value)
                                ? Lottie.asset(
                                    AnimationPath.loadingTwo,
                                    repeat: false,
                                  )
                                : SignUpRouteCompotents
                                    .completeProfileContainer(
                                    firstNameController: firstNameController,
                                    lastNameController: lastNameController,
                                    aboutController: aboutController,
                                    onPress: () {},
                                  );
                          });
                }),
          ],
        ),
      ),
    ));
  }
}
