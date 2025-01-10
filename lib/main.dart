import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sample/controller/homescreen_controller.dart';
import 'package:firebase_sample/controller/loginscreen_controller.dart';
import 'package:firebase_sample/controller/registerscreen_controller.dart';
import 'package:firebase_sample/firebase_options.dart';
import 'package:firebase_sample/services/notification_services.dart';
import 'package:firebase_sample/view/Splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Myapp());
  NotificationService().registerPushNotificationHandler();
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RegisterscreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginscreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomescreenController(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

String email = "";
String password = "";
