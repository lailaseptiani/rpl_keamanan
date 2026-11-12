import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/logger.dart';

void main() {
  group('Logger.mask', () {
    test('menyamarkan API key', () {
      expect(Logger.mask('API_KEY=dummy_api_key_12345'), 'API_KEY=***');
      expect(Logger.mask('X-API-Key: abc123'), 'X-API-Key: ***');
    });

    test('menyamarkan token dan password dalam JSON', () {
      expect(
        Logger.mask('{"token": "eyJhbGci", "password": "Rahasia1!"}'),
        '{"token": "***", "password": "***"}',
      );
    });

    test('tidak mengubah pesan tanpa data sensitif', () {
      expect(Logger.mask('GET /users'), 'GET /users');
      expect(Logger.mask('Response status: 200'), 'Response status: 200');
    });
  });
}
