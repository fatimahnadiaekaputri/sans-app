import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:SANS/src/screens/signin.dart';
import 'package:SANS/src/widgets/custom_scaffold.dart';
import 'package:SANS/src/widgets/custom_text_form.dart';
import 'package:SANS/src/widgets/main_button.dart';
import 'package:SANS/src/api/api_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignUpKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _domicileController = TextEditingController();
  final _nikController = TextEditingController();

  final ApiManager apiManager =
      ApiManager('https://server-sans.vercel.app/signIn/');

  Future<void> _signUp() async {
    if (_formSignUpKey.currentState?.validate() ?? false) {
      final response = await apiManager.post(
        'register',
        {
          'username': _usernameController.text,
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'telephone': _phoneController.text,
          'domicile': _domicileController.text,
          'nik': _nikController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up berhasil')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign Up gagal. Silakan coba lagi')));
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _domicileController.dispose();
    _nikController.dispose();
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
            'Sign Up',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(199, 54, 89, 1),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              flex: 7,
              child: SingleChildScrollView(
                  child: Form(
                      key: _formSignUpKey,
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
                            height: 15,
                          ),
                          CustomTextForm(
                            label: 'Nama',
                            hintText: 'Masukkan nama',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan nama';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextForm(
                            label: 'Email',
                            hintText: 'Masukkan email',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextForm(
                            label: 'Password',
                            hintText: 'Maasukkan password',
                            obscureText: true,
                            obscuringCharacter: '*',
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextForm(
                            label: 'Nomor Telepon',
                            hintText: 'Masukkan nomor telepon',
                            controller: _phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan nomor telepon';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextForm(
                            label: 'Domisili',
                            hintText: 'Masukkan domisili',
                            controller: _domicileController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan domisili';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextForm(
                            label: 'NIK',
                            hintText: 'Masukkan NIK',
                            controller: _nikController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan NIK';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Sudah punya akun? ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: 'Sign In',
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      color:
                                          const Color.fromRGBO(199, 54, 89, 1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignInScreen()));
                                      })
                              ])),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: MainButton(
                              buttonText: 'Sign Up',
                              buttonColor: const Color.fromRGBO(199, 54, 89, 1),
                              textColor: Colors.white,
                              onTap: _signUp,
                            ),
                          )
                        ],
                      ))))
        ],
      ),
    ));
  }
}
