import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/view_model/home/search_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes/route_names.dart';
import '../../../view_model/home/chatspace_provider.dart';
import '../../../view_model/home/stream_provider.dart';

forwardBottomSheet({
  required BuildContext context,
}) {
  final themeManager = Provider.of<ThemeManager>(context, listen: false);
  return showModalBottomSheet(
    backgroundColor: themeManager.onprimaryLight,
    context: context,
    builder: (_) {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final chatSpaceProvider =
          Provider.of<ChatSpaceProvider>(context, listen: false);
      final messageStreamProvider = Provider.of<MessageStreamProvider>(context);
      return Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Utils.trasform(
                    icon: Icon(
                  Icons.reply,
                  color: themeManager.primary,
                )),
                Text(
                  "Forward to...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeManager.primary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: searchProvider.fetchUsersFromCollection(
                  userId: userProvider.userData.userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> usersList = snapshot.data!.docs;
                    if (usersList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                usersList[index].data() as Map<String, dynamic>;
                            UserModel targetUserData =
                                UserModel.fromMap(userMap);
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(targetUserData.fullName!),
                              subtitle: Text(targetUserData.emailId ??
                                  targetUserData.phoneNumber!),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: themeManager.onprimary,
                                backgroundImage:
                                    (targetUserData.profilePicture != null)
                                        ? NetworkImage(
                                            targetUserData.profilePicture!)
                                        : null,
                              ),
                              trailing: const Icon(
                                  Icons.keyboard_arrow_right_outlined),
                              onTap: () async {
                                ShowDialogModel.alertDialog(
                                    context,
                                    "Confrimation!",
                                    Text(
                                        "Forward to ${targetUserData.fullName}"),
                                    [
                                      TextButton(
                                          onPressed: () {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () async {
                                            //fetch chatSpceData
                                            ChatSpaceModel chatSpaceData =
                                                await searchProvider
                                                    .fetchChatSpace(
                                              userId:
                                                  userProvider.userData.userId!,
                                              targetUserId:
                                                  targetUserData.userId!,
                                            );
                                            // set ChatSpace Data
                                            chatSpaceProvider.setChatSpaceData(
                                                chatSpaceData: chatSpaceData);
                                            // set Target User
                                            userProvider.setTargetUserData(
                                                targetUserData: targetUserData);
                                            // forward
                                            await chatSpaceProvider
                                                .forwarMessages(
                                              chatSpaceData: chatSpaceData,
                                              forwardMessages: chatSpaceProvider
                                                  .getSelectedMessages,
                                              userId:
                                                  userProvider.userData.userId!,
                                              targetUserId:
                                                  targetUserData.userId!,
                                            );
                                            // navigate
                                            if (context.mounted) {
                                              messageStreamProvider
                                                  .initStreamAndStore(
                                                userId: userProvider
                                                    .userData.userId!,
                                                context: context,
                                                chatSpaceId: chatSpaceProvider
                                                    .chatSpaceData.chatSpaceId!,
                                              );
                                              chatSpaceProvider
                                                  .removeAllSelectedMessages();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                  context, RouteName.chatspace);
                                            }
                                          },
                                          child: const Text("Yes")),
                                    ]);
                              },
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Error occured!",
                            style: TextStyle(color: themeManager.onprimary),
                          ),
                        ),
                      );
                    }
                  }
                  return Expanded(
                    child: Center(
                      child: Text(
                        "No data found!",
                        style: TextStyle(color: themeManager.onprimary),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                      child: Center(
                    child: CircularProgressIndicator(
                      color: themeManager.onprimary,
                    ),
                  ));
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
