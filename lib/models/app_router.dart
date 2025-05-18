import 'package:consulationapp/views/admin_dashboard.dart';
import 'package:flutter/material.dart';
// ...other imports...

class RouteManager {
  static const String loginPage = '/login';
  static const String adminDashboard = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        // return MaterialPageRoute(...);
        break;
      case adminDashboard:
        return MaterialPageRoute(builder: (context) => const AdminDashboard());
      // ...other cases...
      default:
        // return MaterialPageRoute(...);
        break;
    }
    // Fallback route in case no case matches
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(child: Text('No route defined for ${settings.name}')),
      ),
    );
  }
}