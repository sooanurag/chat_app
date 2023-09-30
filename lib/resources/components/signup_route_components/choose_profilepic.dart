import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../animated_icons.dart';

chooseProfilePicture(
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
