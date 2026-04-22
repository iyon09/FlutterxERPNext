import 'package:flutter/material.dart';

/// AppConfig menyimpan semua tetapan global aplikasi di satu tempat.
/// Ini memudahkan penukaran IP Server atau Token tanpa perlu mencari di merata-rata fail.
class AppConfig {
  // Alamat Server ERPNext
  static const String baseUrl = "http://192.168.0.7:8080";
  
  // Token API (Pastikan token ini sentiasa aktif di ERPNext)
  static const String apiToken = "token 19b504487909099:16f37f3941c6379";

  // Warna Tema (ERPNext Red)
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color bgColor = Color(0xFFF4F7F9);

  // Tetapan Peta
  static const String osmUserAgent = "com.zne.ekehadiran.app";
}
