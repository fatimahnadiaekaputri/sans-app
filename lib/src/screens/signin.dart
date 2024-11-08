import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:SANS/src/api/api_manager.dart';
import 'package:SANS/src/screens/home.dart';
import 'package:SANS/src/widgets/custom_scaffold.dart';
import 'package:SANS/src/widgets/custom_text_form.dart';
import 'package:SANS/src/widgets/main_button.dart';
import 'package:SANS/src/screens/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final ApiManager apiManager =
      ApiManager('https://server-sans.vercel.app/signIn/');

  Future<void> _signIn() async {
    if (_formSignInKey.currentState?.validate() ?? false) {
      final response = await apiManager.get(
        'login/${_usernameController.text}/${_passwordController.text}',
        {},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final idUser = data['userId'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign In berhasil')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(id_user: idUser)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign In gagal. Silakan coba lagi')));
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return CustomScaffold(
        // ignore: prefer_const_constructors
        child: Center(
            // ignore: prefer_const_constructors
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(199, 54, 89, 1),
          ),
        ),
        Expanded(
            flex: 7,
            child: SingleChildScrollView(
                child: Form(
                    key: _formSignInKey,
                    child: Column(
                      children: [
                        CustomTextForm(
                          label: 'Username',
                          hintText: 'Masukkan username',
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomTextForm(
                          label: 'Password',
                          hintText: 'Masukkan password',
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Belum punya akun?',
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: const Color.fromRGBO(199, 54, 89, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 75.0,
                        ),
                        Center(
                          child: MainButton(
                            buttonText: 'Sign in',
                            buttonColor: const Color.fromRGBO(199, 54, 89, 1),
                            textColor: Colors.white,
                            onTap: _signIn,
                          ),
                        )
                      ],
                    )))),
      ],
    )));
  }
}
