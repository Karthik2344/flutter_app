// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_app/data/local_string.dart';
import 'package:new_app/screens/dashboard_page.dart';
import 'package:new_app/screens/login.dart';
import 'package:new_app/screens/register.dart';
import 'package:new_app/screens/settings.dart';
import 'package:new_app/services/theme_service.dart';
import 'package:new_app/services/themes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  await GetStorage.init(); // Initialize caching
  setUrlStrategy(PathUrlStrategy()); // Configure URL strategy
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Localstring(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      title: 'PalmPower Textractor',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeService().getThemeMode(), // Persist theme mode
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set initial route
      getPages: [
        GetPage(name: '/', page: () => const DashboardPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
      ],
    );
  }
}

// main.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:new_app/data/local_string.dart';
// import 'package:new_app/screens/dashboard_page.dart';
// import 'package:new_app/screens/forms_page.dart';
// import 'package:new_app/screens/upload_page.dart';
// import 'package:new_app/services/theme_service.dart';
// import 'package:new_app/services/themes.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// class NavigationController extends GetxController {
//   static NavigationController get to => Get.find();
//   final _selectedIndex = 0.obs;
  
//   int get selectedIndex => _selectedIndex.value;
  
//   void changePage(int index) {
//     _selectedIndex.value = index;
//     switch (index) {
//       case 0:
//         Get.offNamed('/');
//         break;
//       case 1:
//         Get.offNamed('/forms');
//         break;
//       case 2:
//         Get.offNamed('/upload');
//         break;
//       case 3:
//         Get.offNamed('/export');
//         break;
//     }
//   }

//   void setInitialIndex(String currentPath) {
//     switch (currentPath) {
//       case '/forms':
//         _selectedIndex.value = 1;
//         break;
//       case '/upload':
//         _selectedIndex.value = 2;
//         break;
//       case '/export':
//         _selectedIndex.value = 3;
//         break;
//       default:
//         _selectedIndex.value = 0;
//     }
//   }
// }

// void main() async {
//   await GetStorage.init();
//   setUrlStrategy(PathUrlStrategy());
//   Get.put(NavigationController());
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   String _initialRoute() {
//     final String currentPath = Uri.base.path;
//     final validRoutes = ['/', '/forms', '/upload', '/export'];
    
//     if (validRoutes.contains(currentPath)) {
//       Get.find<NavigationController>().setInitialIndex(currentPath);
//       return currentPath;
//     }
//     return '/';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       translations: Localstring(),
//       locale: const Locale('en', 'US'),
//       fallbackLocale: const Locale('en', 'US'),
//       title: 'PalmPower Textractor',
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       themeMode: ThemeService().getThemeMode(),
//       debugShowCheckedModeBanner: false,
//       initialRoute: _initialRoute(),
//       getPages: [
//         GetPage(
//           name: '/',
//           page: () => const DashboardPage(),
//           transition: Transition.noTransition,
//         ),
//         GetPage(
//           name: '/forms',
//           page: () => const DashboardPage(),
//           transition: Transition.noTransition,
//         ),
//         GetPage(
//           name: '/upload',
//           page: () => const DashboardPage(),
//           transition: Transition.noTransition,
//         ),
//         GetPage(
//           name: '/export',
//           page: () => const DashboardPage(),
//           transition: Transition.noTransition,
//         ),
//       ],
//     );
//   }
// }