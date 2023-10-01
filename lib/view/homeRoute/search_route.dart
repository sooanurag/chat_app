import 'package:chat_app/view_model/home/home_provider.dart';
import 'package:chat_app/view_model/home/search_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../utils/utils.dart';

class SearchRoute extends StatefulWidget {
  const SearchRoute({super.key});

  @override
  State<SearchRoute> createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  final nameController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      backgroundColor: themeManager.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    searchProvider.setisSearchingStatus(status: false);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: themeManager.onprimaryLight,
                    size: 28,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 10,
                  ),
                  child: Utils.customTextFormField(
                    inputController: nameController,
                    invalidText: "",
                    hint: "Search",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    isFilled: true,
                    fillColor: themeManager.onprimaryLight,
                    cursorColor: themeManager.onprimary,
                    prefixIconColor: themeManager.primary,
                    onChanged: (input) {
                      if (input.isNotEmpty) {
                        searchProvider.setisSearchingStatus(status: true);
                      } else {
                        searchProvider.setisSearchingStatus(status: false);
                      }
                    },
                  ),
                )),
              ],
            )),
            Expanded(
              flex: 12,
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
                    if (searchProvider.isSearching)
                      StreamBuilder(
                        stream: searchProvider
                            .fetchUsersFromCollectionUsingFullName(
                                inputString: nameController.text),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              List<QueryDocumentSnapshot> usersList =
                                  snapshot.data!.docs;
                              if (usersList.isNotEmpty) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: usersList.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> userMap =
                                          usersList[index].data()
                                              as Map<String, dynamic>;
                                      UserModel targetUserData =
                                          UserModel.fromMap(userMap);
                                      return ListTile(
                                        title: Text(targetUserData.fullName!),
                                        subtitle: Text(targetUserData.emailId ??
                                            targetUserData.phoneNumber!),
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              themeManager.onprimary,
                                          backgroundImage: (targetUserData
                                                  .profilePicture!.isNotEmpty)
                                              ? NetworkImage(targetUserData
                                                  .profilePicture!)
                                              : null,
                                        ),
                                        trailing: const Icon(Icons
                                            .keyboard_arrow_right_outlined),
                                        onTap: () async {},
                                      );
                                    },
                                  ),
                                );
                              }
                            }
                            if (snapshot.hasError) {
                              return const Expanded(
                                child: Center(
                                    child: Text("Something went wrong!")),
                              );
                            } else {
                              return const Expanded(
                                child: Center(child: Text("No data found!")),
                              );
                            }
                          } else {
                            return  Expanded(
                              child: Center(child: CircularProgressIndicator(color: themeManager.primary)),
                            );
                          }
                        },
                      ),
                    if (!searchProvider.isSearching)
                      StreamBuilder(
                        stream: searchProvider.fetchUsersFromCollection(
                            userId: userProvider.userData.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              List<QueryDocumentSnapshot> usersList =
                                  snapshot.data!.docs;
                              if (usersList.isNotEmpty) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: usersList.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> userMap =
                                          usersList[index].data()
                                              as Map<String, dynamic>;
                                      UserModel targetUserData =
                                          UserModel.fromMap(userMap);
                                      return ListTile(
                                        title: Text(targetUserData.fullName!),
                                        subtitle: Text(targetUserData.emailId ??
                                            targetUserData.phoneNumber!),
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              themeManager.onprimary,
                                          backgroundImage: (targetUserData
                                                  .profilePicture!.isNotEmpty)
                                              ? NetworkImage(targetUserData
                                                  .profilePicture!)
                                              : null,
                                        ),
                                        trailing: const Icon(Icons
                                            .keyboard_arrow_right_outlined),
                                        onTap: () async {},
                                      );
                                    },
                                  ),
                                );
                              }
                            }
                            if (snapshot.hasError) {
                              return const Expanded(
                                child: Center(
                                    child: Text("Something went wrong!")),
                              );
                            } else {
                              return const Expanded(
                                child: Center(child: Text("No data found!")),
                              );
                            }
                          } else {
                            return  Expanded(
                              child: Center(child: CircularProgressIndicator(color: themeManager.primary,)),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
