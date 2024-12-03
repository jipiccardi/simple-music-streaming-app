import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/main.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/states/sign_in_state.dart';
import 'package:music_app/services/firestore_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInNotifier extends Notifier<SignInState> {
  late final FirestoreAuthService authService = FirestoreAuthService();

  @override
  SignInState build() {
    return const SignInState();
  }

  Future<Exception?> login(String email, String password) async {
    state = state.copyWith(screenState: const BaseScreenState.loading());

    try {
      final credentials = await authService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', credentials.user!.uid);
      sessionUserId = credentials.user!.uid;

      state = state.copyWith(
        screenState: const BaseScreenState.idle(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        state = state.copyWith(screenState: const BaseScreenState.idle());
        return Exception('Invalid email or password.');
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

  void resetPasswordLInk(String email) {
    authService.auth.sendPasswordResetEmail(email: email);
  }
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }
}
