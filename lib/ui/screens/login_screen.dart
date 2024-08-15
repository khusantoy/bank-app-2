import 'package:flutter/material.dart';
import 'package:online_bank/data/services/auth_firebase_services.dart';
import 'package:online_bank/ui/screens/register_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authHttpServices = FirebaseAuthServices();
  bool isLoading = false;
  String? password, email;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    setState(() {
      isLoading = true;
    });

    try {
      await _authHttpServices.loginUser(
        email: emailText.text,
        password: passwordText.text,
      );
    } catch (e) {
      String message = e.toString();
      if (e.toString().contains("INVALID_LOGIN_CREDENTIALS")) {
        message = "Bunday email hali ro'yhatdan o'tmagan";
      }
      if (e.toString().contains("Null check operator used on a null value")) {
        message = "Iltimos Email va Passwordlarni to'liq kiriting";
      }

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Xatolik"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Center(
                child: Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 50,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailText,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        labelText: "name@gmail.com",
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "iltimos emailingizni kiriting";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        email = newValue;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: passwordText,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        labelText: "Enter Password",
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "iltimos parolingizni kiriting";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        password = newValue;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ZoomTapAnimation(
                      onTap: submit,
                      child: Container(
                        width: 350,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 25),
              ZoomTapAnimation(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SignupScreen();
                      },
                    ),
                  );
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 18,
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
