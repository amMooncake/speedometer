import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/res/app_dimens.dart';
import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../views/sign_in_screen.dart';
import '../views/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              AppDimens.gap(10),
              Text(
                'Witaj w speedometer!',
                style: t.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight(700),
                  fontStyle: FontStyle.italic,
                ),
              ),
              AppDimens.gap(2),
              Padding(
                padding: AppDimens.paddingHorizontal(3),
                child: TabBar(
                  controller: tabController,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withAlpha(155),
                  labelColor: Theme.of(context).colorScheme.onSurface,
                  tabs: [
                    Padding(
                      padding: AppDimens.paddingAll(2),
                      child: Text(
                        'Zaloguj',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: AppDimens.paddingAll(2),
                      child: Text(
                        'Zarejestruj',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    BlocProvider<SignInBloc>(
                      create: (context) =>
                          SignInBloc(context.read<AuthenticationBloc>().userRepository),
                      child: const SignInScreen(),
                    ),
                    BlocProvider<SignUpBloc>(
                      create: (context) =>
                          SignUpBloc(context.read<AuthenticationBloc>().userRepository),
                      child: const SignUpScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
