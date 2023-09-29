import 'package:chat_app/resources/app_strings.dart';
import 'package:chat_app/resources/components/animated_icons.dart';
import 'package:chat_app/resources/components/custom_buttons.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/view_model/auth/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpRouteCompotents {
  static profilePicure(
      {required Widget background, required BuildContext context}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        background,
        InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () async {
            Utils.showProfilePicturesOptionsDialog(context: context);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 2, color: Colors.black)),
            child: LottieIcons.add,
          ),
        ),
      ],
    );
  }

  static signUpContainer({
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
            SignUpRouteCompotents.passwordTextField(
              isEnabled: signUpProvider.isEnabled,
              obscureText: obscureText,
              passwordController: passwordController,
              invalidText: (signUpProvider.emailPasswordValidator)? AppStrings.passwordInvalid:"",
              label: AppStrings.textFieldLabels[1],
            ),
            Utils.divider,
            SignUpRouteCompotents.passwordTextField(
              obscureText: cObscureText,
              passwordController: cPasswordController,
              invalidText:(signUpProvider.emailPasswordValidator)? AppStrings.cPasswordInvalid:"",
              label: AppStrings.textFieldLabels[2],
              isEnabled: signUpProvider.isEnabled,
            ),
            SignUpRouteCompotents.orDivider,
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

  static completeProfileContainer({
    required firstNameController,
    required lastNameController,
    required aboutController,
    required VoidCallback onPress,
    required GlobalKey formKey,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Utils.customTextFormField(
              inputController: firstNameController,
              invalidText: AppStrings.firstNameInvalid,
              label: AppStrings.textFieldLabels[4],
              prefixIcon: LottieIcons.persontwo,
            ),
            Utils.divider,
            Utils.customTextFormField(
              inputController: lastNameController,
              invalidText: AppStrings.lastNameInvalid,
              label: AppStrings.textFieldLabels[5],
              prefixIcon: LottieIcons.persontwo,
            ),
            Utils.divider,
            Utils.customTextFormField(
              inputController: aboutController,
              invalidText: AppStrings.infoInvalid,
              label: AppStrings.textFieldLabels[6],
              prefixIcon: LottieIcons.info,
              hint: "Available",
            ),
            Utils.divider,
            CustomButton().roundedButton(
              onPress: onPress,
              title: "Complete",
            ),
          ],
        ),
      ),
    );
  }

  static passwordTextField({
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

  static get orDivider => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: 1,
              color: Colors.black54,
            )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "OR",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Expanded(
                child: Container(
              height: 1,
              color: Colors.black54,
            )),
          ],
        ),
      );
}
