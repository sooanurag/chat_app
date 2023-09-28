import 'package:chat_app/resources/theme/theme_constants.dart';
import 'package:chat_app/services/firebase_options.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:chat_app/view_model/theme/theme_manager.dart';
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
      ],
      child: Builder(
        builder: (context) {
          final themeManager = Provider.of<ThemeManager>(context);
          return  MaterialApp(
            themeMode: themeManager.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            onGenerateRoute: Routes.generateRoute,
            initialRoute: RouteName.splash,
          );
        },
      ),
    );
  }
}
