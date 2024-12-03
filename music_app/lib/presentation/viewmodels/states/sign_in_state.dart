import 'package:music_app/presentation/utils/base_screen_state.dart';

class SignInState {
  final BaseScreenState screenState;
  final String email;
  final String password;
  final bool isPasswordVisible;

  const SignInState({
    this.screenState = const BaseScreenState.idle(),
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
  });

  SignInState copyWith({
    BaseScreenState? screenState,
    String? email,
    String? password,
    bool? isPasswordVisible,
  }) {
    return SignInState(
      screenState: screenState ?? this.screenState,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
