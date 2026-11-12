import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpl_keamanan/config/dependency_injector.dart';
import 'package:rpl_keamanan/main.dart';

void main() {
  setUpAll(() async {
    // Muat .env sebelum test berjalan agar AppConfig tidak
    // melempar NotInitializedError.
    await dotenv.load(fileName: '.env');
  });

  testWidgets('HomeScreen menampilkan judul aplikasi', (WidgetTester tester) async {
    await tester.pumpWidget(
      DependencyProvider(
        injector: DependencyInjector.instance,
        child: const MyApp(),
      ),
    );

    // AppBar harus menampilkan judul aplikasi.
    expect(find.text('RPL & Keamanan'), findsOneWidget);
  });

  testWidgets('HomeScreen menampilkan menu navigasi', (WidgetTester tester) async {
    await tester.pumpWidget(
      DependencyProvider(
        injector: DependencyInjector.instance,
        child: const MyApp(),
      ),
    );

    // Empat menu navigasi harus muncul.
    expect(find.text('Daftar Pengguna'), findsOneWidget);
    expect(find.text('Daftar Post'), findsOneWidget);
    expect(find.text('Form Registrasi'), findsOneWidget);
    expect(find.text('Demo Validasi'), findsOneWidget);
  });
}
