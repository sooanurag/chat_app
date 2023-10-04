import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

replyTextField({
  required TextEditingController messageController,
  required BuildContext context,
  required themeManager,
  required MessageModel replyMessageData,
}) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final chatSpaceProvider =
      Provider.of<ChatSpaceProvider>(context, listen: false);
  String replyOnName =
      (replyMessageData.senderId == userProvider.userData.userId!)
          ? "You"
          : userProvider.targetuserData.fullName!;
  // chatSpaceProvider.setReplidToName(name: replyOnName);

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: themeManager.primary,
    ),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: themeManager.onprimary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$replyOnName :",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      replyMessageData.text!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      chatSpaceProvider.setIsReplyMessageStatus(status: false);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.emoji_emotions,
                  color: themeManager.onprimaryLight,
                )),
            Expanded(
                child: TextField(
              controller: messageController,
              style: TextStyle(color: themeManager.onprimaryLight),
              cursorColor: themeManager.onprimary,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write your messages...",
                  hintStyle: TextStyle(color: themeManager.onprimaryLight)),
            )),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.attach_file,
                color: themeManager.onprimaryLight,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.camera_alt,
                color: themeManager.onprimaryLight,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
