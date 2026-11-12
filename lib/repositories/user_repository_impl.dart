import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<User>> getUsers() async {
    return await _apiService.getUsers();
  }

  @override
  Future<User> getUserById(int id) async {
    if (id <= 0) {
      throw ArgumentError.value(id, 'id', 'ID harus berupa integer positif');
    }
    return await _apiService.getUserById(id);
  }

  void dispose() {
    // Tutup ApiService hanya dari DependencyInjector.
  }
}
