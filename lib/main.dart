import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_app/pdf_app/screen/home_screen.dart';
import 'package:pdf_app/pdf_app/store/objectbox_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await ObjectBox.create();
  runApp(const MyApp());
}

final kPrimaryColor = Colors.red[600];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pdf Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF222f3e),
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            backgroundColor: kPrimaryColor,
            shape: const CircleBorder(),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
