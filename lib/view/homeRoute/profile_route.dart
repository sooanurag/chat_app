
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileRoute extends StatefulWidget {
  const ProfileRoute({super.key});

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatSpaceProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.messageStatesList.length,
            itemBuilder: (context, index) {
              MessageModel currentMessage = value.messageStatesList[index];
              return ListTile(
                title: Text(currentMessage.text ?? "null"),
                leading: const CircleAvatar(),
                subtitle: Text(currentMessage.isSelected.toString()),
                trailing: IconButton(
                    onPressed: () {
                      value.updateMessageState(
                        messageData: currentMessage,
                        index: index,
                        helperProvider: value,
                        isMessageSelected: true,
                      );
                      // value.sendMessage(
                      //     msg: "new Message",
                      //     senderId: "senderId",
                      //     chatSpaceData: value.chatSpaceData);
                    },
                    icon: const Icon(Icons.ads_click)),
              );
            },
          );
        },
      ),
    );
  }
}
