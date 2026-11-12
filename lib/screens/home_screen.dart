import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/dependency_injector.dart';
import '../services/secure_storage_service.dart';
import '../utils/logger.dart';
import '../utils/validators.dart';
import 'post_list_screen.dart';
import 'register_screen.dart';
import 'user_list_screen.dart';
import 'validation_demo_screen.dart';

/// Halaman utama aplikasi.
///
/// Menampilkan status konfigurasi `.env`, form demo validasi & sanitasi
/// input, serta menu navigasi ke halaman lain.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late final SecureStorageService _storage;

  String? _sanitizedName;
  String? _savedUsername;

  @override
  void initState() {
    super.initState();
    _storage = DependencyProvider.read(context).secureStorage;
    _loadSavedUsername();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedUsername() async {
    final username = await _storage.getUsername();
    if (!mounted) return;
    setState(() => _savedUsername = username);
  }

  /// Memvalidasi form, menyanitasi input, lalu menyimpannya secara aman.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cleanName = Validators.sanitize(_nameController.text);
    await _storage.saveUsername(cleanName);
    Logger.info('Nama tersimpan di secure storage', tag: 'HomeScreen');
    if (!mounted) return;

    setState(() {
      _sanitizedName = cleanName;
      _savedUsername = cleanName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data valid dan tersimpan dengan aman')),
    );
  }

  Future<void> _clearData() async {
    await _storage.clearAll();
    if (!mounted) return;
    setState(() {
      _savedUsername = null;
      _sanitizedName = null;
    });
  }

  Future<void> _open(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    // Muat ulang nama tersimpan (bisa berubah dari halaman registrasi).
    _loadSavedUsername();
  }

  @override
  Widget build(BuildContext context) {
    final configured = AppConfig.isConfigured();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPL & Keamanan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status konfigurasi .env (nilai API key tidak pernah ditampilkan)
          Card(
            color: configured ? Colors.green.shade50 : Colors.red.shade50,
            child: ListTile(
              leading: Icon(
                configured ? Icons.check_circle : Icons.warning,
                color: configured ? Colors.green : Colors.red,
              ),
              title: Text(configured
                  ? 'Konfigurasi .env termuat'
                  : 'Konfigurasi .env tidak lengkap'),
              subtitle: Text(configured
                  ? 'Base URL: ${AppConfig.baseUrl}\nAPI key: ••••••••'
                  : 'Periksa file .env di root proyek'),
              isThreeLine: configured,
            ),
          ),
          const SizedBox(height: 16),

          // Menu navigasi
          _MenuTile(
            icon: Icons.people,
            title: 'Daftar Pengguna',
            subtitle: 'UserRepository',
            onTap: () => _open(const UserListScreen()),
          ),
          _MenuTile(
            icon: Icons.article,
            title: 'Daftar Post',
            subtitle: 'PostRepository',
            onTap: () => _open(const PostListScreen()),
          ),
          _MenuTile(
            icon: Icons.how_to_reg,
            title: 'Form Registrasi',
            subtitle: 'Validasi telepon, URL, password',
            onTap: () => _open(const RegisterScreen()),
          ),
          _MenuTile(
            icon: Icons.rule,
            title: 'Demo Validasi',
            subtitle: 'Uji cepat email, telepon, URL, password',
            onTap: () => _open(const ValidationDemoScreen()),
          ),
          const SizedBox(height: 16),

          if (_savedUsername != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Tersimpan di secure storage: $_savedUsername',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),

          // Form demo validasi sisi klien & sanitasi input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Demo Validasi & Sanitasi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => Validators.validateText(
                        value,
                        fieldName: 'Nama',
                        minLength: 3,
                        maxLength: 50,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save),
                      label: const Text('Validasi & Simpan'),
                    ),
                    TextButton(
                      onPressed: _clearData,
                      child: const Text('Hapus data tersimpan'),
                    ),
                    if (_sanitizedName != null) ...[
                      const Divider(),
                      const Text('Hasil sanitasi:'),
                      SelectableText(
                        _sanitizedName!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item menu navigasi di halaman utama.
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
