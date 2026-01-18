import 'package:flutter/material.dart';
import 'package:tiketfix/core/app_routes.dart';
import 'package:tiketfix/presentation/pages/widgets/controllers/login_page.dart';
void main() {
  runApp(const TicketFixApp());
}

class TicketFixApp extends StatelessWidget {
  const TicketFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicketFix',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const HomePage(),
      },
    );
  }
}
