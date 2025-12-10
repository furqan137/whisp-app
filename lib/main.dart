import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'Screens/splash/splash.dart';
import 'Service/notification.dart';
import 'firebase_options.dart';
import 'theme/theme_provider.dart';
import 'Screens/vpn/global_vpn.dart';   // Global Fake VPN Manager

Future<void> saveDeviceToken(String userId) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'deviceToken': token}, SetOptions(merge: true));

    print("📱 Device token saved for $userId: $token");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Push Notifications
  final NotificationService notificationService = NotificationService();
  await notificationService.initNotifications();

  // Initialize Global Fake VPN System
  GlobalVPN.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',

      themeMode: themeProvider.themeMode,

      // Light Theme
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff090F21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff090F21),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
