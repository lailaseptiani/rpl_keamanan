import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('mengembalikan true untuk email valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('nama.mahasiswa@students.amikom.ac.id'),
          isTrue);
      expect(Validators.isValidEmail('a@b.c'), isTrue);
    });

    test('mengembalikan false jika tanpa @', () {
      expect(Validators.isValidEmail('userexample.com'), isFalse);
    });

    test('mengembalikan false jika bagian lokal atau domain kosong', () {
      expect(Validators.isValidEmail('@example.com'), isFalse);
      expect(Validators.isValidEmail('user@'), isFalse);
    });

    test('mengembalikan false jika domain tanpa titik', () {
      expect(Validators.isValidEmail('user@example'), isFalse);
    });

    test('mengembalikan false jika ada spasi atau @ ganda', () {
      expect(Validators.isValidEmail('us er@example.com'), isFalse);
      expect(Validators.isValidEmail('user@@example.com'), isFalse);
    });

    test('mengembalikan false untuk string kosong', () {
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators.sanitize', () {
    test('meng-escape tag script (XSS)', () {
      expect(
        Validators.sanitize('<script>alert("xss")</script>'),
        '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;',
      );
    });

    test('meng-escape tanda kutip tunggal', () {
      expect(Validators.sanitize("O'Brien"), 'O&#x27;Brien');
    });

    test('meng-escape & terlebih dahulu tanpa double escape', () {
      expect(Validators.sanitize('Tom & Jerry'), 'Tom &amp; Jerry');
      expect(Validators.sanitize('<b>'), '&lt;b&gt;');
    });

    test('meng-escape payload atribut HTML', () {
      expect(
        Validators.sanitize('<img src=x onerror="alert(1)">'),
        '&lt;img src=x onerror=&quot;alert(1)&quot;&gt;',
      );
    });

    test('menghapus spasi di awal dan akhir', () {
      expect(Validators.sanitize('   Budi   '), 'Budi');
    });

    test('tidak mengubah teks yang aman', () {
      expect(Validators.sanitize('Halo Dunia 123'), 'Halo Dunia 123');
    });
  });

  group('Validators.validateText', () {
    test('error jika null', () {
      expect(Validators.validateText(null), 'Field tidak boleh kosong');
    });

    test('error jika kosong atau hanya spasi', () {
      expect(Validators.validateText(''), 'Field tidak boleh kosong');
      expect(Validators.validateText('    '), 'Field tidak boleh kosong');
    });

    test('memakai fieldName pada pesan error', () {
      expect(
        Validators.validateText('', fieldName: 'Nama'),
        'Nama tidak boleh kosong',
      );
    });

    test('valid untuk panjang 1 dan 100 (batas default)', () {
      expect(Validators.validateText('a'), isNull);
      expect(Validators.validateText('a' * 100), isNull);
    });

    test('error untuk panjang 101 (melebihi batas default)', () {
      expect(
        Validators.validateText('a' * 101),
        'Field harus antara 1-100 karakter',
      );
    });

    test('menghormati minLength dan maxLength kustom', () {
      expect(
        Validators.validateText('ab',
            fieldName: 'Nama', minLength: 3, maxLength: 50),
        'Nama harus antara 3-50 karakter',
      );
      expect(
        Validators.validateText('abc',
            fieldName: 'Nama', minLength: 3, maxLength: 50),
        isNull,
      );
      expect(
        Validators.validateText('a' * 51,
            fieldName: 'Nama', minLength: 3, maxLength: 50),
        'Nama harus antara 3-50 karakter',
      );
    });

    test('panjang dihitung setelah trim', () {
      expect(
        Validators.validateText('  ab  ', minLength: 3),
        'Field harus antara 3-100 karakter',
      );
    });
  });

  group('Validators.validateEmail', () {
    test('error jika kosong', () {
      expect(Validators.validateEmail(''), 'Email tidak boleh kosong');
      expect(Validators.validateEmail(null), 'Email tidak boleh kosong');
    });

    test('error jika format salah', () {
      expect(Validators.validateEmail('bukan-email'), 'Format email tidak valid');
    });

    test('valid dan mengabaikan spasi di tepi', () {
      expect(Validators.validateEmail('  user@example.com  '), isNull);
    });
  });

  // -------------------------------------------------------------------
  // Pengujian tambahan untuk validasi Latihan 3
  // -------------------------------------------------------------------

  group('Validators.validatePhone', () {
    test('valid untuk 10, 12, dan 13 digit', () {
      expect(Validators.validatePhone('0812345678'), isNull);
      expect(Validators.validatePhone('081234567890'), isNull);
      expect(Validators.validatePhone('0812345678901'), isNull);
    });

    test('error jika kurang dari 10 atau lebih dari 13 digit', () {
      const msg = 'Nomor telepon harus 10-13 digit angka';
      expect(Validators.validatePhone('081234567'), msg);
      expect(Validators.validatePhone('08123456789012'), msg);
    });

    test('error jika mengandung selain angka', () {
      const msg = 'Nomor telepon harus 10-13 digit angka';
      expect(Validators.validatePhone('+6281234567890'), msg);
      expect(Validators.validatePhone('0812-3456-7890'), msg);
      expect(Validators.validatePhone('08abc4567890'), msg);
    });

    test('error jika kosong', () {
      expect(Validators.validatePhone(''), 'Nomor telepon tidak boleh kosong');
    });
  });

  group('Validators.validateUrl', () {
    test('valid untuk http dan https', () {
      expect(Validators.validateUrl('https://amikom.ac.id'), isNull);
      expect(Validators.validateUrl('http://localhost:8080/api'), isNull);
      expect(Validators.validateUrl('HTTPS://Example.com'), isNull);
    });

    test('error jika tanpa skema http/https', () {
      const msg = 'URL harus diawali http:// atau https://';
      expect(Validators.validateUrl('amikom.ac.id'), msg);
      expect(Validators.validateUrl('ftp://files.example.com'), msg);
      expect(Validators.validateUrl('javascript:alert(1)'), msg);
    });

    test('error jika host kosong atau ada spasi', () {
      expect(Validators.validateUrl('https://'), 'Format URL tidak valid');
      expect(Validators.validateUrl('https://contoh .com'),
          'Format URL tidak valid');
    });
  });

  group('Validators.validatePassword', () {
    test('valid jika memenuhi semua syarat', () {
      expect(Validators.validatePassword('Rahasia1!'), isNull);
      expect(Validators.isStrongPassword('P@ssw0rdKuat'), isTrue);
    });

    test('error jika kurang dari 8 karakter', () {
      expect(Validators.validatePassword('Ra1!'),
          'Password minimal 8 karakter');
    });

    test('error jika tanpa huruf kapital', () {
      expect(Validators.validatePassword('rahasia1!'),
          'Password harus mengandung huruf kapital');
    });

    test('error jika tanpa angka', () {
      expect(Validators.validatePassword('Rahasia!!'),
          'Password harus mengandung angka');
    });

    test('error jika tanpa simbol', () {
      expect(Validators.validatePassword('Rahasia12'),
          'Password harus mengandung simbol');
    });

    test('konfirmasi password harus sama', () {
      expect(Validators.validateConfirmPassword('Rahasia1!', 'Rahasia1!'),
          isNull);
      expect(Validators.validateConfirmPassword('Rahasia1?', 'Rahasia1!'),
          'Konfirmasi password tidak sama');
    });
  });
}
