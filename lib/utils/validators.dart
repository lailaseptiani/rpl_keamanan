
class Validators {
  Validators._(); // Tidak perlu di-instansiasi.

  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool hasValidLength(String value, {int min = 1, int max = 100}) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  static String sanitize(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .trim();
  }

  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (!hasValidLength(value, min: minLength, max: maxLength)) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Latihan 3: Validasi yang lebih ketat
  static final RegExp _phoneRegex = RegExp(r'^\d{10,13}$');
  static final RegExp _urlRegex =
      RegExp(r'^https?://[^\s/$.?#][^\s]*$', caseSensitive: false);
  static final RegExp _upperCaseRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'\d');
  static final RegExp _symbolRegex = RegExp(r'[^A-Za-z0-9\s]');

  static const int minPasswordLength = 8;

  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone.trim());
  }

  static bool isValidUrl(String url) {
    final value = url.trim();
    if (!_urlRegex.hasMatch(value)) return false;
    final uri = Uri.tryParse(value);
    return uri != null && uri.host.isNotEmpty;
  }

  static bool isStrongPassword(String password) {
    return validatePassword(password) == null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!isValidPhone(value)) {
      return 'Nomor telepon harus 10-13 digit angka';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    final url = value.trim().toLowerCase();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'URL harus diawali http:// atau https://';
    }
    if (!isValidUrl(value)) {
      return 'Format URL tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < minPasswordLength) {
      return 'Password minimal $minPasswordLength karakter';
    }
    if (!_upperCaseRegex.hasMatch(value)) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!_digitRegex.hasMatch(value)) {
      return 'Password harus mengandung angka';
    }
    if (!_symbolRegex.hasMatch(value)) {
      return 'Password harus mengandung simbol';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Konfirmasi password tidak sama';
    }
    return null;
  }
}
