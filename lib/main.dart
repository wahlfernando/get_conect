import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_conect_exemple/pages/home/home_controller.dart';
import 'package:get_conect_exemple/pages/home/home_page.dart';
import 'package:get_conect_exemple/repositories/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: '/',
          binding: BindingsBuilder(() {
            Get.lazyPut(() => UserRepository());
            Get.put(HomeController(repository: Get.find()));
          }),
          page: () => const HomePage(),
        )
      ],
    );
  }
}
