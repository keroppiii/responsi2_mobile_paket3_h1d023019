import 'package:flutter/material.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/screens/login_screen.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/screens/home_screen.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/theme/app_theme.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/utils/shared_prefs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventaris Buku fatiMart',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // SOLUSI: Batasi max width untuk mobile view
        final screenWidth = MediaQuery.of(context).size.width;
        
        return Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500, // Mobile-like width
            ),
            child: child,
          ),
        );
      },
      home: FutureBuilder<String?>(
        future: SharedPrefs.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          final token = snapshot.data;
          return token != null && token.isNotEmpty
              ? const HomeScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}