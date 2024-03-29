import 'package:chat_app/resources/theme/theme_constants.dart';
import 'package:chat_app/services/firebase_options.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:chat_app/view_model/auth/signin_provider.dart';
import 'package:chat_app/view_model/auth/signup_provider.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:chat_app/view_model/home/home_provider.dart';
import 'package:chat_app/view_model/home/search_provider.dart';
import 'package:chat_app/view_model/home/stream_provider.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatSpaceProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_)=> MessageStreamProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeManager = Provider.of<ThemeManager>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeManager.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            onGenerateRoute: Routes.generateRoute,
            initialRoute: (FirebaseAuth.instance.currentUser != null)? RouteName.home : RouteName.splash,
          );
        },
      ),
    );
  }
}
