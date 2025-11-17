import 'package:agri_link/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password, String userType);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement login logic
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register(String name, String email, String password, String userType) async {
    // TODO: Implement register logic
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout logic
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // TODO: Implement get current user logic
    throw UnimplementedError();
  }
}
