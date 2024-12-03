import 'package:music_app/presentation/utils/base_screen_state.dart';

class SignUpState {
  final BaseScreenState screenState;
  final String email;
  final String password;
  final String repeatPassword;
  final bool isPasswordVisible;
  final bool isRepeatPasswordVisible;

  const SignUpState({
    this.screenState = const BaseScreenState.idle(),
    this.email = '',
    this.password = '',
    this.repeatPassword = '',
    this.isPasswordVisible = false,
    this.isRepeatPasswordVisible = false,
  });

  SignUpState copyWith({
    BaseScreenState? screenState,
    String? email,
    String? password,
    String? repeatPassword,
    bool? isPasswordVisible,
    bool? isRepeatPasswordVisible,
  }) {
    return SignUpState(
      screenState: screenState ?? this.screenState,
      email: email ?? this.email,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isRepeatPasswordVisible: isRepeatPasswordVisible ?? this.isRepeatPasswordVisible,
    );
  }
}
