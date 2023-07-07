import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginRepo {}

final loginRepoProvider = Provider<LoginRepo>((ref) {
  return LoginRepo();
});
