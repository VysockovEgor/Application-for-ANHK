import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(const User(name: 'Даниил', level: 1, points: 100));

  void updateUser(User user) {
    state = user;
  }
}
