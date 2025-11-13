// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AgriLink App',
//
//       // theme: ThemeData(
//
//       //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//       //   useMaterial3: true,
//       // ),
//       // home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AgriLink Home'),
//       ),
//       body: const Center(
//         child: Text(
//           'Welcome to AgriLink!',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_themes.dart';
import 'views/farmer/farmer_home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriLink',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      home: const FarmerHomeView(),
    );
  }
}
