// import 'package:chat_app/model/chatspace_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class PresenceDetector extends StatefulWidget {
//   final String userId;
//   final ChatSpaceModel chatSpaceData;

//   const PresenceDetector(
//       {super.key, required this.userId, required this.chatSpaceData});

//   @override
//   State<PresenceDetector> createState() => _PresenceDetectorState();
// }

// class _PresenceDetectorState extends State<PresenceDetector>
//     with WidgetsBindingObserver {
//   final firestoreInstance = FirebaseFirestore.instance.collection("chatspace");
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _updateUserStatus(true);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _updateUserStatus(true);
//     } else {
//       _updateUserStatus(false);
//     }
//   }

//   void _updateUserStatus(bool status) async {
//     widget.chatSpaceData.activeStatus![widget.userId] = status;
//     debugPrint(widget.chatSpaceData.activeStatus![widget.userId].toString());
//     debugPrint(status.toString());
//     await firestoreInstance
//         .doc(widget.chatSpaceData.chatSpaceId)
//         .set(widget.chatSpaceData.toMap());
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _updateUserStatus(false);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
