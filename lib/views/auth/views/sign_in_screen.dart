import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/res/app_dimens.dart';
import 'package:speedometer_mobile/res/app_styles.dart';

import '../../../components/my_text_field.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequest = false;
  IconData iconPassword = Icons.visibility_off;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequest = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequest = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequest = false;
            _errorMsg = 'Invalid email or password!';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: AppDimens.paddingHorizontal(3),
          child: Column(
            mainAxisSize: .min,
            children: [
              AppDimens.gap(2),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail,
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field!';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                    return 'Please enter a valid email!';
                  }
                  return null;
                },
              ),
              AppDimens.gap(2),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field!';
                  } else if (!RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$',
                  ).hasMatch(val)) {
                    return 'Please enter a valid password!';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                      if (obscurePassword) {
                        iconPassword = Icons.visibility_off;
                      } else {
                        iconPassword = Icons.visibility;
                      }
                    });
                  },
                  icon: Icon(iconPassword),
                ),
              ),
              AppDimens.gap(2),
              !signInRequest
                  ? FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SignInBloc>().add(
                            SignInRequest(emailController.text, passwordController.text),
                          );
                        }
                      },
                      child: Padding(
                        padding: AppDimens.paddingSymetric(2, 2),
                        child: Text('Sign In', style: AppStyles.loginScreenButtonTextStyle),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
