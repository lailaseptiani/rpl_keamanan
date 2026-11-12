import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/app_config.dart';
import 'config/dependency_injector.dart';
import 'screens/home_screen.dart';
import 'utils/logger.dart';

/// Entry point aplikasi.
///
/// Memuat konfigurasi dari file `.env`, menyiapkan dependency,
/// lalu menjalankan aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env
  await dotenv.load(fileName: ".env");

  // Periksa konfigurasi
  if (AppConfig.isConfigured()) {
    Logger.info('Konfigurasi .env termuat', tag: 'main');
  } else {
    Logger.warning(
      'Konfigurasi .env tidak lengkap. Periksa file .env Anda.',
      tag: 'main',
    );
  }

  // Siapkan dependency (singleton)
  final injector = DependencyInjector.instance;

  runApp(
    DependencyProvider(
      injector: injector,
      child: const MyApp(),
    ),
  );
}

/// Widget root aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPL & Keamanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
