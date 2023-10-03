import 'package:chat_app/resources/components/chatspace_components/reply_textfiled.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:chat_app/view_model/home/stream_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../model/message_model.dart';

class ChatSpaceRoute extends StatefulWidget {
  const ChatSpaceRoute({super.key});

  @override
  State<ChatSpaceRoute> createState() => _ChatSpaceRouteState();
}

class _ChatSpaceRouteState extends State<ChatSpaceRoute> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final chatSpaceProvider = Provider.of<ChatSpaceProvider>(context);
    return Scaffold(
      backgroundColor: themeManager.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: themeManager.onprimaryLight,
                        size: 22,
                      ),
                    ),
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0)),
                      splashColor: Colors.white.withOpacity(0),
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: themeManager.onprimaryLight,
                            backgroundImage: (userProvider
                                        .userData.profilePicture !=
                                    null)
                                ? NetworkImage(
                                    userProvider.targetuserData.profilePicture!)
                                : null,
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Text(
                            userProvider.targetuserData.fullName!,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: themeManager.onprimaryLight),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Consumer<ChatSpaceProvider>(
                        builder: (context, value, child) {
                      return (value.getSelectedMessages.isEmpty)
                          ? PopupMenuButton(
                              color: themeManager.onprimaryLight,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Text(
                                    "Clear chat",
                                  ),
                                  onTap: () {},
                                ),
                                PopupMenuItem(
                                  child: const Text("Report"),
                                  onTap: () {},
                                ),
                                PopupMenuItem(
                                  child: const Text("Block"),
                                  onTap: () {},
                                ),
                                PopupMenuItem(
                                  child: const Text("Pin"),
                                  onTap: () {},
                                ),
                              ],
                            )
                          : Container(
                              child: (value.getSelectedMessages.length == 1)
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.reply,
                                              color:
                                                  themeManager.onprimaryLight,
                                            )),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.forward,
                                              color:
                                                  themeManager.onprimaryLight,
                                            )),
                                        PopupMenuButton(
                                          color: themeManager.onprimaryLight,
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: const Text("Delete"),
                                              onTap: () {
                                                ShowDialogModel.alertDialog(
                                                  context,
                                                  "Delete chat",
                                                  const Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text("Delete for me"),
                                                        
                                                      ),
                                                    ],
                                                  ),
                                                  [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text("Close"),),
                                                  ],
                                                );
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: const Text("Copy"),
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: value
                                                        .getSelectedMessages[0]
                                                        .text!,
                                                  ),
                                                );
                                                value.updateMessageState(
                                                  messageData: value
                                                      .getSelectedMessages[0],
                                                  index: 0,
                                                  helperProvider: value,
                                                  isMessageSelected: false,
                                                );
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: const Text("Info"),
                                              onTap: () {},
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.forward,
                                              color:
                                                  themeManager.onprimaryLight,
                                            )),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.delete,
                                              color:
                                                  themeManager.onprimaryLight,
                                            )),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              String copyData = "";
                                              for (MessageModel data in value
                                                  .getSelectedMessages) {
                                                copyData =
                                                    "$copyData\n${data.text}";
                                              }
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text: copyData.trim(),
                                                ),
                                              );
                                              // debugPrint(value
                                              //     .getSelectedMessages.length
                                              //     .toString());
                                              int slectedLength = value
                                                  .getSelectedMessages.length;
                                              for (int i = 0;
                                                  i < slectedLength;
                                                  i++) {
                                                // debugPrint("index : $i");
                                                value.updateMessageState(
                                                  messageData: value
                                                      .getSelectedMessages[0],
                                                  index: i,
                                                  helperProvider: value,
                                                  isMessageSelected: false,
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              Icons.copy,
                                              color:
                                                  themeManager.onprimaryLight,
                                            )),
                                      ],
                                    ),
                            );
                    }),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 14,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeManager.onprimaryLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: Consumer<MessageStreamProvider>(
                            builder: (context, value, child) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            reverse: true,
                            itemCount:
                                chatSpaceProvider.messageStatesList.length,
                            itemBuilder: ((context, index) {
                              MessageModel currentMessage =
                                  chatSpaceProvider.messageStatesList[index];
                              return Consumer<ChatSpaceProvider>(
                                  builder: (context, value, child) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (value.isLongPressEnable)
                                          ? () {
                                              value.updateMessageState(
                                                messageData: currentMessage,
                                                index: index,
                                                helperProvider: value,
                                                isMessageSelected:
                                                    !currentMessage.isSelected,
                                              );
                                              if (value.getSelectedMessages
                                                  .isEmpty) {
                                                value
                                                    .setIsLongPressEnableStatus(
                                                        status: false);
                                              }
                                            }
                                          : () {
                                              value.updateMessageState(
                                                messageData: currentMessage,
                                                index: index,
                                                helperProvider: value,
                                                isMessageSelected: false,
                                              );
                                            },
                                      onLongPress: () {
                                        value.updateMessageState(
                                          messageData: currentMessage,
                                          index: index,
                                          helperProvider: value,
                                          isMessageSelected: true,
                                        );
                                        value.setIsLongPressEnableStatus(
                                            status: true);
                                      },
                                      child: Container(
                                        color: (currentMessage.isSelected)
                                            ? themeManager.selectionColor
                                            : null,
                                        child: Row(
                                          mainAxisAlignment: (currentMessage
                                                      .senderId ==
                                                  userProvider.userData.userId)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.6,
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color:
                                                        (currentMessage
                                                                    .senderId ==
                                                                userProvider
                                                                    .userData
                                                                    .userId)
                                                            ? themeManager
                                                                .primaryNegative
                                                            : themeManager
                                                                .onprimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    currentMessage.text!,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          (currentMessage.senderId ==
                                                  userProvider.userData.userId)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat("H:mm d/M/yy").format(
                                              currentMessage.createdOn!),
                                          style: const TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                );
                              });
                            }),
                          );
                        }),
                      )),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 12,
                        ),
                        color: themeManager.onprimaryLight,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (chatSpaceProvider.isReplyMessage)
                                  ? Expanded(
                                      child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: themeManager.primary,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.emoji_emotions,
                                                color:
                                                    themeManager.onprimaryLight,
                                              )),
                                          Expanded(
                                              child: TextField(
                                            controller: _messageController,
                                            cursorColor: themeManager.onprimary,
                                            style: TextStyle(
                                                color: themeManager
                                                    .onprimaryLight),
                                            decoration: InputDecoration(
                                                focusColor:
                                                    themeManager.onprimaryLight,
                                                border: InputBorder.none,
                                                hintText:
                                                    "Write your messages...",
                                                hintStyle: TextStyle(
                                                    color: themeManager
                                                        .onprimaryLight)),
                                          )),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.attach_file,
                                              color:
                                                  themeManager.onprimaryLight,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.camera_alt,
                                              color:
                                                  themeManager.onprimaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : Expanded(
                                      child: replyTextField(
                                          themeManager: themeManager)),
                              const SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                radius: 23,
                                backgroundColor: themeManager.primary,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: themeManager.onprimaryLight,
                                  ),
                                  onPressed: () {
                                    chatSpaceProvider.sendMessage(
                                      messageController: _messageController,
                                      senderId: userProvider.userData.userId!,
                                      chatSpaceData:
                                          chatSpaceProvider.chatSpaceData,
                                      context: context,
                                    );
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
