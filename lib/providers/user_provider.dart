import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String name;

  const UserState({this.name = ""});

  UserState copyWith({String? name}) {
    return UserState(name: name ?? this.name);
  }
}

class UserProvider extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  void setName(String name) {
    state = state.copyWith(name: name);
  }
}
