import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/views/main_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      initialRoute: "/",
      // initialBinding: AuthBinding(),
      home: MainPage(),
    );
  }
}
