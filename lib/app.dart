import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_auth_bloc_app/app_view.dart';
import 'package:login_auth_bloc_app/blocs/authentication/authentication_bloc.dart';
import 'package:user_repository/user_repo.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp(
    this.userRepository, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(userRepository: userRepository)
        )
      ], 
      child: const AppView());
  }
}
