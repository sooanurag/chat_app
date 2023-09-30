import 'dart:io';

import 'package:chat_app/resources/app_paths.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class Utils {
  static const divider = SizedBox(
    height: 20,
  );
// customTextFormField
  static TextFormField customTextFormField({
    required TextEditingController inputController,
    required String invalidText,
    required String label,
    String? hint,
    required Widget prefixIcon,
    FocusNode? currentFocusNode,
    BuildContext? context,
    FocusNode? nextNode,
    bool obscure = false,
    Widget? suffixIcon,
    void Function(String)? onChanged,
    bool? isEnabled,
  }) {
    return TextFormField(
      enabled: isEnabled,
      onChanged: onChanged,
      controller: inputController,
      obscureText: obscure,
      focusNode: currentFocusNode,
      onFieldSubmitted: (context != null)
          ? (value) => changeFieldFocus(
              context: context,
              currentNode: currentFocusNode!,
              nextNode: nextNode!)
          : null,
      validator:(invalidText!="") ?(value) {
        if (value!.isEmpty) {
          return invalidText;
        }
        else{
          return null;
        }
        
      }:null,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: prefixIcon,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

// changeField Focus
  static void changeFieldFocus({
    required BuildContext context,
    required FocusNode currentNode,
    required FocusNode nextNode,
  }) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

// showProfilePicturesOptionsDialog
  static ValueNotifier<File?> imageFile = ValueNotifier<File?>(null);


  static showProfilePicturesOptionsDialog({
    required BuildContext context,
  }) {
    ShowDialogModel.alertDialog(
      context,
      "Profile picture!",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Utils.selectImage(ImageSource.gallery);
            },
            title: const Text("Select from Gallery"),
            leading: const Icon(Icons.photo_album_rounded),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              selectImage(ImageSource.camera);
            },
            title: const Text("Pick from Camera"),
            leading: const Icon(Icons.camera_alt_rounded),
          )
        ],
      ),
      [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("close"),
        ),
      ],
    );
  }

// select Image
  static selectImage(ImageSource source) async {
    XFile? pickedImageFile = await ImagePicker().pickImage(source: source);
    if (pickedImageFile != null) {
      // cropImage(pickedImageFile);
      imageFile.value = File(pickedImageFile.path);
    }
  }

// crop Image
  // static cropImage(XFile pickedImageFile) async {
  //   CroppedFile? croppedIMageFile =
  //       await ImageCropper().cropImage(sourcePath: pickedImageFile.path);
  //   if (croppedIMageFile != null) {
  //     imageFile.value = File(croppedIMageFile.path);
  //   }
  // }

  static get profileDefault => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Lottie.asset(AnimationPath.person,
                height: 300, fit: BoxFit.fill)),
      );
}

class ShowDialogModel {
  static alertDialog(
    BuildContext context,
    String inputTitle,
    Widget inputContent,
    List<Widget> inputActions,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(inputTitle),
            content: inputContent,
            actions: inputActions,
          );
        });
  }
}
