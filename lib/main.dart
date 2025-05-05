// import 'package:budget_tracker/ip_address.dart';
import 'package:budget_tracker/ip_address.dart';
// import 'package:budget_tracker/main_screen.dart';
// import 'package:budget_tracker/main_screen.dart';
import 'package:budget_tracker/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: BudgetTheme.lightTheme,
      home: IpAddressScreen(),
    );
  }
}

