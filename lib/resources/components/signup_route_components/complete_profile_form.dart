import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../../app_strings.dart';
import '../animated_icons.dart';
import '../custom_buttons.dart';

 completeProfileForm({
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