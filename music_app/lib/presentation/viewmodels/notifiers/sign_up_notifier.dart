import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/data/models/user.dart';
import 'package:music_app/data/repositories/providers.dart';
import 'package:music_app/data/repositories/users_repository.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/states/sign_up_state.dart';
import 'package:music_app/services/firestore_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/main.dart';

class SignUpNotifier extends Notifier<SignUpState> {
  late final UsersRepository usersRepository =
      ref.read(usersRepositoryProvider);
  late final FirestoreAuthService authService = FirestoreAuthService();

  @override
  SignUpState build() {
    return const SignUpState();
  }

  Future<Exception?> registerNewUser(String email, String password) async {
    state = state.copyWith(screenState: const BaseScreenState.loading());
    try {
      final userCredentials = await authService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await usersRepository.createUser(AppUser(
          id: userCredentials.user!.uid, email: userCredentials.user!.email!));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userCredentials.user!.uid);
      sessionUserId = userCredentials.user!.uid;

      state = state.copyWith(screenState: const BaseScreenState.idle());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        state = state.copyWith(screenState: const BaseScreenState.idle());
        return Exception('The account already exists for that email.');
      }

      state = state.copyWith(
        screenState: BaseScreenState.error(e.toString()),
      );
      return e;
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
      return Exception(error);
    }

    return null;
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateRepeatPassword(String repeatPassword) {
    state = state.copyWith(repeatPassword: repeatPassword);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleRepeatPasswordVisibility() {
    state =
        state.copyWith(isRepeatPasswordVisible: !state.isRepeatPasswordVisible);
  }
}
