import 'package:flutter/material.dart';

replyTextField({
  required themeManager,
}) {
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "user :",
                    ),
                    Text("reply On Text"),
                  ],
                ),
                const Spacer(),
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
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
