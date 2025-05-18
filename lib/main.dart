import 'package:consulationapp/routes/app_router.dart';
import 'package:consulationapp/servicess/auth_service.dart';
import 'package:consulationapp/viewmodels/profile_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAXJlQG7TTURqwxbY6KSfVA40kVpfzGCKs",
        authDomain: "consultation-app-fbe96.firebaseapp.com",
        projectId: "consultation-app-fbe96",
        storageBucket: "consultation-app-fbe96.firebasestorage.app",
        messagingSenderId: "201426968716",
        appId: "1:201426968716:web:ab9a8b0a51a4e360b89ba9",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteManager.loginPage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
