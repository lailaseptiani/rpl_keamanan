import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk menyimpan data sensitif secara terenkripsi (dari Pertemuan 5).
///
/// Menggunakan Keychain (iOS) dan EncryptedSharedPreferences (Android)
/// melalui package `flutter_secure_storage`. Data sensitif seperti token
/// disimpan di sini, bukan di SharedPreferences atau di kode sumber.
///
/// Class ini menyediakan dua gaya API:
/// * API umum: [write], [read], [delete], [clear].
/// * API khusus: [saveToken], [getToken], [saveUsername], [getUsername],
///   [hasToken], [clearAll].
class SecureStorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUsername = 'username';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  // ------------------------------------------------------------------
  // API umum
  // ------------------------------------------------------------------

  /// Menyimpan [value] dengan kunci [key].
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// Membaca nilai berdasarkan [key]. Mengembalikan `null` jika tidak ada.
  Future<String?> read(String key) => _storage.read(key: key);

  /// Menghapus nilai berdasarkan [key].
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Menghapus seluruh data.
  Future<void> clear() => _storage.deleteAll();

  // ------------------------------------------------------------------
  // API khusus
  // ------------------------------------------------------------------

  /// Menyimpan [token] autentikasi.
  Future<void> saveToken(String token) => write(_keyToken, token);

  /// Membaca token autentikasi, atau `null` jika belum ada.
  Future<String?> getToken() => read(_keyToken);

  /// Menyimpan [username] pengguna.
  Future<void> saveUsername(String username) => write(_keyUsername, username);

  /// Membaca username, atau `null` jika belum ada.
  Future<String?> getUsername() => read(_keyUsername);

  /// Memeriksa apakah token sudah tersimpan.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Menghapus seluruh data sesi (logout). Sama dengan [clear].
  Future<void> clearAll() => clear();
}
