import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

class DependencyInjector {
  DependencyInjector._internal();

  static final DependencyInjector _instance = DependencyInjector._internal();

  /// Mengembalikan instance singleton.
  factory DependencyInjector() => _instance;

  /// Instance singleton (alternatif dari `DependencyInjector()`).
  static DependencyInjector get instance => _instance;

  /// Satu-satunya [ApiService] di aplikasi (dibuat saat pertama dipakai).
  late final ApiService apiService = ApiService();

  /// Service penyimpanan terenkripsi.
  late final SecureStorageService secureStorage = SecureStorageService();

  /// Repository pengguna, memakai [apiService] yang sama.
  late final UserRepository userRepository =
      UserRepositoryImpl(apiService: apiService);

  /// Repository post, memakai [apiService] yang sama.
  late final PostRepository postRepository =
      PostRepositoryImpl(apiService: apiService);

  /// Menutup resource yang dipegang injector.
  void dispose() {
    apiService.dispose();
  }
}

class DependencyProvider extends InheritedWidget {
  /// Injector yang disediakan ke widget di bawahnya.
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  static DependencyInjector of(BuildContext context) => read(context);

  /// Sama dengan [of]. Aman dipanggil di `initState`.
  static DependencyInjector read(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<DependencyProvider>() ??
            context.getInheritedWidgetOfExactType<DependencyScope>();
    return provider?.injector ?? DependencyInjector.instance;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}

class DependencyScope extends DependencyProvider {
  const DependencyScope({
    super.key,
    required super.injector,
    required super.child,
  });

  /// Mengambil [DependencyInjector] dari [context]. Aman di `initState`.
  static DependencyInjector of(BuildContext context) =>
      DependencyProvider.read(context);
}
