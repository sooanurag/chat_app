import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:flutter/material.dart';

replyContainer(
    {required ThemeManager themeManager,
    required String replyOnName,
    required MessageModel replyMessageData,
    required ChatSpaceProvider chatSpaceProvider,
    required String userId,
    required String senderId}) {
  return Container(
    constraints: const BoxConstraints(
      minWidth: 80,
    ),
    margin: const EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: (userId == senderId)
          ? themeManager.primaryNegativeDark
          : themeManager.primary,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$replyOnName :",
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.white, fontSize: 12),
          ),
          const SizedBox(
            height: 6,
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
    ),
  );
}
