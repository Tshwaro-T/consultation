import 'package:consulationapp/auth/auth_page.dart';
import 'package:consulationapp/views/admin_registration_page.dart';
import 'package:consulationapp/views/home_page.dart';
import 'package:consulationapp/views/profile_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:consulationapp/views/admin_dashboard.dart';
//import 'package:consulationapp/views/admin_register_page.dart'; // Create this if it doesn't exist

class RouteManager {
  static const String loginPage = '/';
  static const String registrationPage = '/register';
  static const String mainPage = '/main';
  static const String profilePage = '/profile';
  static const String adminRegisterPage = '/adminRegister';
   static const String adminDashboard = '/adminDashboard'; 
  static get adminRegister => null; 

   static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: true));
      case registrationPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: false));
      case mainPage:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HomePage(email: email),
        );
      case profilePage:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
        // ignore: constant_pattern_never_matches_value_type, type_literal_in_constant_pattern
        case AdminRegistrationPage:
        return MaterialPageRoute(builder: (_) => const AdminRegistrationPage());
        // ignore: dead_code
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case null:
        return MaterialPageRoute(builder: (_) => const AdminRegisterPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route for ${settings.name}')),
          ),
        );
    }
  }
}

class AdminRegisterPage extends StatelessWidget {
  const AdminRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Register')),
      body: const Center(child: Text('Admin Register Page')),
    );
  }
}