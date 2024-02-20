import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_auth_bloc_app/blocs/authentication/authentication_bloc.dart';
import 'package:login_auth_bloc_app/blocs/my_user/my_user_bloc.dart';
import 'package:login_auth_bloc_app/blocs/sign_in/sign_in_bloc.dart';
import 'package:login_auth_bloc_app/config/theme.dart';
import 'package:login_auth_bloc_app/screens/authentication/welcome_screen.dart';
import 'package:login_auth_bloc_app/screens/home/home_screen.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth',
      theme: theme(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<SignInBloc>(
                  create: (context) => SignInBloc(
                    myUserRepository: context.read<AuthenticationBloc>().userRepository
                  ),
                ),
                BlocProvider<MyUserBloc>(
                  create: (context) => MyUserBloc(
                    myUserRepository: context.read<AuthenticationBloc>().userRepository
                  )..add(
                    GetMyUser(
                      myUserId: context.read<AuthenticationBloc>().state.user!.uid
                    )
                  ),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
