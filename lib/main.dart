import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Define a cor primária personalizada
  MaterialColor primaryColor = const MaterialColor(0xFF075E54, {
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF009688),
    600: Color(0xFF00897B),
    700: Color(0xFF00796B),
    800: Color(0xFF00695C),
    900: Color(0xFF004D40),
  });

  ColorScheme colorScheme = ColorScheme.fromSwatch(
    primarySwatch: primaryColor, // Cor primária
    accentColor: const Color(0xFF25D366), // Cor de destaque
    errorColor: const Color(0xFFFF0000), // Cor de erro
    brightness: Brightness.light, // Brilho (claro/escuro)

  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    theme: ThemeData(
      hintColor: const Color(0xFF6666666),
      colorScheme: colorScheme, // Aplica o esquema de cores personalizado
    ),
  ));
}
