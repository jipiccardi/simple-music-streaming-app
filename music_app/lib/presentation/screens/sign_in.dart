import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/presentation/screens/sign_up.dart';
import 'package:music_app/presentation/screens/songs_list.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const name = 'SignInScreen';

  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final state = ref.read(signInViewModelProvider);

    _emailController = TextEditingController(text: state.email);
    _passwordController = TextEditingController(text: state.password);

    _emailController.addListener(() {
      ref
          .read(signInViewModelProvider.notifier)
          .updateEmail(_emailController.text);
    });
    _passwordController.addListener(() {
      ref
          .read(signInViewModelProvider.notifier)
          .updatePassword(_passwordController.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInViewModelProvider);
    final notifier = ref.read(signInViewModelProvider.notifier);

    return Scaffold(
      body: state.screenState.when(
        idle: () => _SignIn(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          togglePasswordVisibility: notifier.togglePasswordVisibility,
          isPasswordVisible: state.isPasswordVisible,
          onLogin: _onLogin,
          onForgotPassword: _onForgotPassword,
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  void _onLogin(String email, String password) async {
    final notifier = ref.read(signInViewModelProvider.notifier);
    final e = await notifier.login(email, password);
    if (e != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (context.mounted) {
      _emailController.clear();
      _passwordController.clear();
      context.pushReplacementNamed(SongsListScreen.name);
    }
  }

  void _onForgotPassword() async{
    final state = ref.read(signInViewModelProvider.notifier);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';
        return AlertDialog(
          title: const Text('Password reset link'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () async {
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                        const SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text('Email cannot be empty')),
                      )
                      .closed
                      .then((reason) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    }
                  });
                } else {
                  state.resetPasswordLInk(email);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      }
    );

    
  }
}

class _SignIn extends StatelessWidget {
  const _SignIn({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.togglePasswordVisibility,
    required this.isPasswordVisible,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final void Function(String, String) onLogin;
  final void Function() onForgotPassword;
  final void Function() togglePasswordVisibility;

  final bool isPasswordVisible;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                height: 100,
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                autocorrect: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  onForgotPassword();
                },
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  emailController.clear();
                  passwordController.clear();
                  context.pushReplacementNamed(SignUpScreen.name);
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (formKey.currentState?.validate() ?? false) {
                      onLogin(
                        emailController.text,
                        passwordController.text,
                      );
                    }
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
