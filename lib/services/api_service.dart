import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Exception khusus API dengan pesan yang aman ditampilkan ke pengguna.
class ApiException implements Exception {
  /// Pesan yang ramah pengguna (tidak membocorkan detail teknis).
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _tag = 'ApiService';

  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  Future<List<User>> getUsers() async {
    final body = await _get('/users');
    final data = body as List<dynamic>;
    return data
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<User> getUserById(int id) async {
    final body = await _get('/users/$id');
    return User.fromJson(body as Map<String, dynamic>);
  }

  Future<List<Post>> getPosts() async {
    final body = await _get('/posts');
    final data = body as List<dynamic>;
    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<dynamic> _get(String endpoint) async {
    try {
      Logger.info('GET $endpoint', tag: _tag);

      final response = await _client
          .get(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));

      Logger.debug('Response status: ${response.statusCode}', tag: _tag);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw const ApiException('Data tidak ditemukan.');
      } else {
        throw ApiException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on ApiException catch (e) {
      Logger.warning(e.message, tag: _tag);
      rethrow;
    } on TimeoutException catch (e) {
      Logger.error('Request timeout', error: e, tag: _tag);
      throw const ApiException(
          'Request timeout. Periksa koneksi internet Anda.');
    } on SocketException catch (e) {
      Logger.error('Tidak ada koneksi', error: e, tag: _tag);
      throw const ApiException(
          'Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException catch (e) {
      Logger.error('Format response tidak valid', error: e, tag: _tag);
      throw const ApiException('Format data tidak valid.');
    } catch (e) {
      // Detail error hanya dicatat (tipe saja), tidak ditampilkan ke pengguna.
      Logger.error('Error tidak terduga', error: e, tag: _tag);
      throw const ApiException('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-API-Key': AppConfig.apiKey,
    };
  }

  void dispose() {
    _client.close();
  }
}
