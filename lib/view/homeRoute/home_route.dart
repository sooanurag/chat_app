import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/resources/app_colors.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:chat_app/view_model/home/home_provider.dart';
import 'package:chat_app/view_model/home/search_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: themeManager.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Messages.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.profile);
                    },
                    child: const CircleAvatar(
                      radius: 20,
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                flex: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: themeManager.onprimaryLight,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                  child: StreamBuilder(
                    stream: homeProvider.initiatedUsersStream(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot =
                              snapshot.data as QuerySnapshot;
                          return ListView.builder(
                              itemCount: querySnapshot.docs.length,
                              itemBuilder: (context, index) {
                                ChatSpaceModel chatSpaceData =
                                    ChatSpaceModel.fromMap(
                                        querySnapshot.docs[index].data()
                                            as Map<String, dynamic>);
                                String targetUserId =
                                    homeProvider.fetchTargetUserIdFromChatSpace(
                                        chatSpaceData: chatSpaceData,
                                        userId:
                                            (userProvider.userData).userId!);
                                return FutureBuilder(
                                    future: FirebaseHelper.fetchUserData(
                                        userId: targetUserId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        UserModel targetUser =
                                            snapshot.data as UserModel;

                                        return ListTile(
                                          onTap: () {},
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: (targetUser
                                                    .profilePicture!.isNotEmpty)
                                                ? NetworkImage(
                                                    targetUser.profilePicture!)
                                                : null,
                                          ),
                                          title: Text(targetUser.fullName!),
                                          subtitle: Text(
                                            chatSpaceData.lastMessage!,
                                            maxLines: 1,
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: Text("something went wrong!"),
                                        );
                                      }
                                    });
                              });
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("Something went wrong, restart!"),
                          );
                        } else {
                          return const Center(
                            child: Text("No Users Found!"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("No Internet"),
                        );
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.search);
          final searchProvider =
              Provider.of<SearchProvider>(context, listen: false);
          searchProvider.setisSearchingStatus(status: false);
        },
        backgroundColor: AppColors.defaultGreenYellow[0],
        child: Icon(
          Icons.chat,
          color: AppColors.defaultGreenYellow[2],
        ),
      ),
    );
  }
}
