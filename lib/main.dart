import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_pages.dart';
import 'providers/user_provider.dart';

/// Titik permulaan (entry point) aplikasi E-Kehadiran.
void main() {
  runApp(
    // Menggunakan MultiProvider di peringkat akar aplikasi untuk mengurus state global.
    MultiProvider(
      providers: [
        // Menyediakan UserProvider untuk menyimpan maklumat pengguna dan pekerja.
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Kehadiran',
      theme: ThemeData(
        // Menetapkan warna tema utama aplikasi (Gaya ERPNext Merah).
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD32F2F)),
        useMaterial3: true,
      ),
      // Skrin pertama yang akan dipaparkan adalah halaman Log Masuk.
      home: const LoginPages(),
    );
  }
}
