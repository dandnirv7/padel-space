import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_space/screens/home_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PadelSpaceApp());
}

class PadelSpaceApp extends StatelessWidget {
  const PadelSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Padel Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF4F6FB)),
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => HomeView())],
    );
  }
}
