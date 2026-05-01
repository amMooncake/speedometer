import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/res/app_dimens.dart';
import 'package:speedometer_mobile/res/app_styles.dart';
import 'package:speedometer_mobile/res/toast.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/my_text_field.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = Icons.visibility_off;
  bool obscurePassword = true;
  bool signUpRequest = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequest = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequest = true;
          });
        } else if (state is SignUpFailure) {
          ToastManager.showErrorToast(context, state.message ?? 'Błąd podczas rejestracji!');
          setState(() {
            signUpRequest = false;
          });
          return;
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: AppDimens.paddingHorizontal(3),
          child: Column(
            children: [
              AppDimens.gap(2),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Proszę wypełnić to pole!';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                    return 'Proszę podać prawidłowy email!';
                  }
                  return null;
                },
              ),
              AppDimens.gap(2),
              MyTextField(
                controller: passwordController,
                hintText: 'Hasło',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                onChanged: (val) {
                  if (val!.contains(RegExp(r'[A-Z]'))) {
                    setState(() {
                      containsUpperCase = true;
                    });
                  } else {
                    setState(() {
                      containsUpperCase = false;
                    });
                  }
                  if (val.contains(RegExp(r'[a-z]'))) {
                    setState(() {
                      containsLowerCase = true;
                    });
                  } else {
                    setState(() {
                      containsLowerCase = false;
                    });
                  }
                  if (val.contains(RegExp(r'[0-9]'))) {
                    setState(() {
                      containsNumber = true;
                    });
                  } else {
                    setState(() {
                      containsNumber = false;
                    });
                  }
                  if (val.contains(RegExp(r'[^a-zA-Z0-9]'))) {
                    setState(() {
                      containsSpecialChar = true;
                    });
                  } else {
                    setState(() {
                      containsSpecialChar = false;
                    });
                  }
                  if (val.length >= 8) {
                    setState(() {
                      contains8Length = true;
                    });
                  } else {
                    setState(() {
                      contains8Length = false;
                    });
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
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Proszę wypełnić to pole!';
                  } else if (!RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$',
                  ).hasMatch(val)) {
                    return 'Proszę podać prawidłowe hasło!';
                  }
                  return null;
                },
              ),
              AppDimens.gap(2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        containsUpperCase ? "✓  1 wielka litera" : "•  1 wielka litera",
                        style: TextStyle(
                          color: containsUpperCase ? Colors.green : t.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        containsLowerCase ? "✓  1 mała litera" : "•  1 mała litera",
                        style: TextStyle(
                          color: containsLowerCase ? Colors.green : t.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        containsNumber ? "✓  1 cyfra" : "•  1 cyfra",
                        style: TextStyle(
                          color: containsNumber ? Colors.green : t.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        containsSpecialChar ? "✓  1 znak specjalny" : "•  1 znak specjalny",
                        style: TextStyle(
                          color: containsSpecialChar ? Colors.green : t.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        contains8Length ? "✓  minimum 8 znaków" : "•  minimum 8 znaków",
                        style: TextStyle(
                          color: contains8Length ? Colors.green : t.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppDimens.gap(2),
              MyTextField(
                controller: repeatPasswordController,
                hintText: 'Powtórz hasło',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Proszę wypełnić to pole!';
                  } else if (val != passwordController.text) {
                    return 'Hasła nie pasują do siebie!';
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
              MyTextField(
                controller: nameController,
                hintText: 'Imię',
                obscureText: false,
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Proszę wypełnić to pole!';
                  } else if (val.length > 30) {
                    return 'Imię jest za długie!';
                  }
                  return null;
                },
              ),

              AppDimens.gap(2),
              !signUpRequest
                  ? FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser.email = emailController.text;
                          myUser.name = nameController.text;

                          setState(() {
                            context.read<SignUpBloc>().add(
                              SignUpRequest(myUser, passwordController.text),
                            );
                          });
                        }
                      },
                      child: Padding(
                        padding: AppDimens.paddingSymetric(2, 2),
                        child: Text('Zarejestruj', style: AppStyles.loginScreenButtonTextStyle),
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
