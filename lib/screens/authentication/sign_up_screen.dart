import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_auth_bloc_app/blocs/sign_up/sign_up_bloc.dart';
import 'package:login_auth_bloc_app/components/my_textfield.dart';
import 'package:login_auth_bloc_app/common/strings.dart';
import 'package:user_repository/user_repo.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool obscuredPassword = true;
  IconData iconPassword = Icons.visibility;
  bool signUpRequired = false;

  bool containsUpperCase = false;
	bool containsLowerCase = false;
	bool containsNumber = false;
	bool containsSpecialChar = false;
	bool contains8Length = false;


  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          setState(() {
            signUpRequired = false;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                  height: 20,
                ),
                SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  autofillHints: const [AutofillHints.email],
                  autofocus: true,
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in the field';
                    } else if (!emailRexExp.hasMatch(val)) {
                      return 'Please enter a valid email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  autofillHints: const [AutofillHints.password],
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscuredPassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(Icons.lock),
                  onChanged: (val) {
                    if(val!.contains(RegExp(r'[A-Z]'))) {
                        setState(() {
                          containsUpperCase = true;
                        });
                      } else {
                        setState(() {
                          containsUpperCase = false;
                        });
                      }
                      if(val.contains(RegExp(r'[a-z]'))) {
                        setState(() {
                          containsLowerCase = true;
                        });
                      } else {
                        setState(() {
                          containsLowerCase = false;
                        });
                      }
                      if(val.contains(RegExp(r'[0-9]'))) {
                        setState(() {
                          containsNumber = true;
                        });
                      } else {
                        setState(() {
                          containsNumber = false;
                        });
                      }
                      if(val.contains(specialCharRexExp)) {
                        setState(() {
                          containsSpecialChar = true;
                        });
                      } else {
                        setState(() {
                          containsSpecialChar = false;
                        });
                      }
                      if(val.length >= 8) {
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
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in the field';
                    } else if (!passwordRexExp.hasMatch(val)) {
                      return 'Please enter a valid password';
                    } else {
                      return null;
                    }
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscuredPassword = !obscuredPassword;
                        if (obscuredPassword) {
                          iconPassword = Icons.visibility;
                        } else {
                          iconPassword = Icons.visibility_off;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "⚈  1 uppercase",
                        style: TextStyle(
                          color: containsUpperCase ? Colors.green : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        "⚈  1 lowercase",
                        style: TextStyle(
                          color: containsLowerCase ? Colors.green : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        "⚈  1 number",
                        style: TextStyle(
                          color: containsNumber ? Colors.green : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "⚈  1 special character",
                        style: TextStyle(
                          color: containsSpecialChar ? Colors.green : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        "⚈  8 minimum character",
                        style: TextStyle(
                          color: contains8Length ? Colors.green : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  autofillHints: const [AutofillHints.name],
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.person),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in the field';
                    } else if (val.length > 30) {
                      return 'Name too long';
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              !signUpRequired
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser = myUser.copyWith(
                            email: emailController.text,
                            name: nameController.text
                          );

                          setState(() {
                            context.read<SignUpBloc>().add(
                              SignUpRequired(
                                user: myUser,
                                password: passwordController.text
                              )
                            );
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        elevation: 3.0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)
                        )
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
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
