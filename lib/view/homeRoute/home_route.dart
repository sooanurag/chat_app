import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/resources/app_colors.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:chat_app/view_model/home/home_provider.dart';
import 'package:chat_app/view_model/home/search_provider.dart';
import 'package:chat_app/view_model/home/stream_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with WidgetsBindingObserver {
  HomeProvider? homeProvider;
  UserProvider? userProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if (FirebaseAuth.instance.currentUser != null) {
      _initUserData(
        userId: FirebaseAuth.instance.currentUser!.uid,
        userProvider: userProvider!,
      );
    }

    super.initState();
  }

  Future<void> _initUserData({
    required String userId,
    required UserProvider userProvider,
  }) async {
    UserModel? userData = await FirebaseHelper.fetchUserData(userId: userId);
    userData!.firebaseUser = FirebaseAuth.instance.currentUser!;
    userProvider.setUserData(userData: userData);
  }

  @override
  void dispose() {
    //  homeProvider = Provider.of<HomeProvider>(context, listen: false);
    //  userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider!.userData.userId != null) {
      homeProvider!.statusUpdate(userData: userProvider!.userData, status: false);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
     homeProvider = Provider.of<HomeProvider>(context, listen: false);
     userProvider = Provider.of<UserProvider>(context, listen: false);
    if (state == AppLifecycleState.resumed &&
        userProvider?.userData.userId != null) {
      homeProvider?.statusUpdate(userData: userProvider!.userData, status: true);
    } else {
      if (userProvider?.userData.userId != null) {
        homeProvider?.statusUpdate(
            userData: userProvider!.userData, status: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final chatSpaceProvider = Provider.of<ChatSpaceProvider>(context);
    final messageStreamProvider = Provider.of<MessageStreamProvider>(context);

    // init userStatus
    userProvider.userData.activeStatus = true;
    homeProvider.statusUpdate(
      status: true,
      userData: userProvider.userData,
    );

    return Scaffold(
      backgroundColor: themeManager.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeManager.onprimaryLight,
                        fontSize: 28),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      homeProvider.statusUpdate(userData: userProvider.userData, status: false);
                      Navigator.pushNamed(context, RouteName.welcome);
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: themeManager.onprimary,
                      backgroundImage: (userProvider.userData.profilePicture !=
                              null)
                          ? NetworkImage(userProvider.userData.profilePicture!)
                          : null,
                      child: (userProvider.userData.profilePicture ==
                              null)? Icon(
                        Icons.logout_outlined,
                        color: themeManager.onprimaryLight,
                      ):null,
                    ),
                  ),
                  // PopupMenuButton(itemBuilder: itemBuilder)
                ],
              ),
            ),
            Expanded(
                flex: 12,
                child: Container(
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
                                debugPrint(chatSpaceData.toMap().toString());
                                debugPrint(
                                    chatSpaceData.participants.toString());
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
                                          onTap: () {
                                            // set TargetUser
                                            userProvider.setTargetUserData(
                                                targetUserData: targetUser);
                                            // set chatSpace data
                                            chatSpaceProvider.setChatSpaceData(
                                                chatSpaceData: chatSpaceData);
                                            // init stream
                                            messageStreamProvider
                                                .initStreamAndStore(
                                              userId:
                                                  userProvider.userData.userId!,
                                              context: context,
                                              chatSpaceId: chatSpaceProvider
                                                  .chatSpaceData.chatSpaceId!,
                                            );
                                            chatSpaceProvider
                                                .removeAllSelectedMessages();
                                            // init isuseractive-Stream
                                            userProvider.listenToUserStatus(
                                                context: context);
                                            // chatroom active

                                            // push to route
                                            Navigator.pushNamed(
                                                context, RouteName.chatspace);
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                themeManager.onprimary,
                                            backgroundImage: (targetUser
                                                    .profilePicture!=null)
                                                ? NetworkImage(
                                                    targetUser.profilePicture!)
                                                : null,
                                            child: Icon(Icons.person, color: themeManager.primary,),
                                          ),
                                          title: Text(targetUser.fullName!),
                                          subtitle: Text(
                                            chatSpaceData.lastMessage!,
                                            maxLines: 1,
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // is pinned
                                              // is pinned
                                              if (chatSpaceData
                                                      .lastMessageTimeStamp !=
                                                  null)
                                                Text(
                                                  DateFormat("H:mm").format(
                                                      chatSpaceData
                                                          .lastMessageTimeStamp!),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              if (chatSpaceData.unseenCounter![
                                                      userProvider
                                                          .userData.userId] !=
                                                  0)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        themeManager.onprimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: (chatSpaceData
                                                                  .unseenCounter![
                                                              userProvider
                                                                  .userData
                                                                  .userId] <=
                                                          10)
                                                      ? Text(
                                                          chatSpaceData
                                                              .unseenCounter![
                                                                  userProvider
                                                                      .userData
                                                                      .userId]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  themeManager
                                                                      .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12),
                                                        )
                                                      : Text(
                                                          "10+",
                                                          style: TextStyle(
                                                              color:
                                                                  themeManager
                                                                      .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12),
                                                        ),
                                                )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
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
                        return Center(
                          child: CircularProgressIndicator(
                            color: themeManager.primary,
                          ),
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
