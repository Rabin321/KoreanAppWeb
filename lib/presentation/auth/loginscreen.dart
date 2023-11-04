import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../web_main.dart';

class LoginPage extends StatelessWidget {
  static const String id = "weblogin";
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.blue.shade900,
                Colors.blue.shade600,
                Colors.blue.shade400,
                Colors.blue.shade200,
              ])),
              // child: const Center(
              //   child: Image(image: AssetImage("assets/images/loginm.png")),
              // ),
            ),
          ),
          const Expanded(
            flex: 7,
            child: Center(child: LoginForm()),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailtext = TextEditingController();
  TextEditingController passtext = TextEditingController();
  String username = 'admin';
  String password = 'admin';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print(emailtext.text);
      print(passtext.text);
      if (emailtext.text.trim() == username &&
          passtext.text.trim() == password) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const WebMainScreen();
        }));
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Invalid Credentials'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 2.h, horizontal: 6.w), // Adjusted horizontal padding
          child: Container(
            height: 50.h,
            width: 40.w,
            padding: EdgeInsets.all(2.h), // Adjusted padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.h), // Adjusted borderRadius
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 8.0.sp, // Adjusted fontSize
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ),
                  SizedBox(height: 5.h), // Adjusted vertical spacing
                  TextFormField(
                    controller: emailtext,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        // Update email variable here
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: passtext,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        // Update password variable here
                      });
                    },
                  ),
                  SizedBox(height: 5.h), // Adjusted vertical spacing
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 2.8.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.h)),
                      elevation: 5.0,
                      shadowColor: Colors.black26,
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 5.0.sp)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
