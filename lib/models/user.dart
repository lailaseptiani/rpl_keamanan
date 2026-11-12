/// Model data pengguna dari endpoint `/users` JSONPlaceholder.
class User {
  /// ID unik pengguna.
  final int id;

  /// Nama lengkap pengguna.
  final String name;

  /// Username pengguna.
  final String username;

  /// Alamat email pengguna.
  final String email;

  /// Nomor telepon pengguna.
  final String phone;

  /// Situs web pengguna.
  final String website;

  /// Nama perusahaan tempat pengguna bekerja.
  final String companyName;

  /// Kota tempat tinggal pengguna.
  final String city;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
    this.city = '',
  });

  /// Membuat [User] dari [json] hasil decode response API.
  ///
  /// Field yang tidak ada akan diisi string kosong agar aplikasi
  /// tidak crash ketika data dari server tidak lengkap.
  factory User.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>?;
    final address = json['address'] as Map<String, dynamic>?;

    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      companyName: company?['name'] as String? ?? '',
      city: address?['city'] as String? ?? '',
    );
  }

  /// Mengubah [User] menjadi map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'company': {'name': companyName},
      'address': {'city': city},
    };
  }

  /// Inisial nama untuk ditampilkan di avatar.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
