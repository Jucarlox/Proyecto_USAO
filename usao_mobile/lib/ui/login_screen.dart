import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/auth/login/login_bloc.dart';
import 'package:usao_mobile/models/login/login_dto.dart';
import 'package:usao_mobile/repository/auth/auth_repository.dart';
import 'package:usao_mobile/repository/auth/auth_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/widgets/custom_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthRepository authRepository;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    authRepository = AuthRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return LoginBloc(authRepository);
        },
        child: _createBody(context));
  }

  _createBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<LoginBloc, LoginState>(
                listenWhen: (context, state) {
              return state is LoginSuccessState || state is LoginErrorState;
            }, listener: (context, state) async {
              if (state is LoginSuccessState) {
                final prefs = await SharedPreferences.getInstance();
                // Shared preferences > guardo el token
                //prefs.setString('token', state.loginResponse.token);
                //prefs.setString('avatar', state.loginResponse.avatar);
                Navigator.pushNamed(context, '/');
              } else if (state is LoginErrorState) {
                _showSnackbar(context, state.message);
              }
            }, buildWhen: (context, state) {
              return state is LoginInitialState || state is LoginLoadingState;
            }, builder: (ctx, state) {
              if (state is LoginInitialState) {
                return buildForm(ctx);
              } else if (state is LoginLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return buildForm(ctx);
              }
            })),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildForm(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Form(
        key: _formKey,
        child: SafeArea(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 40, color: AppColors.cyan),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            alignment: Alignment.centerLeft,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.09),
                            child: Image.asset(("assets/images/logo.png")),
                          ),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                width: deviceWidth - 100,
                                child: TextFormField(
                                  style: TextStyle(color: AppColors.cyan),
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.person,
                                        color: AppColors.cyan,
                                      ),
                                      suffixIconColor: AppColors.cyan,
                                      hintText: 'Email',
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.cyan))),
                                  onSaved: (String? value) {
                                    // This optional block of code can be used to run
                                    // code when the user saves the form.
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: deviceWidth - 100,
                                child: TextFormField(
                                  style: TextStyle(color: AppColors.cyan),
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.vpn_key,
                                        color: AppColors.cyan,
                                      ),
                                      suffixIconColor: Colors.white,
                                      hintText: 'Password',
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.cyan))),
                                  onSaved: (String? value) {
                                    // This optional block of code can be used to run
                                    // code when the user saves the form.
                                  },
                                  validator: (value) {
                                    return (value == null || value.isEmpty)
                                        ? 'Write a password'
                                        : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Text('No estas registrado?'),
                              TextButton(
                                child: const Text(
                                  'Resgistrate ahora',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColors.cyan),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                final loginDto = LoginDto(
                                    email: emailController.text,
                                    password: passwordController.text);
                                BlocProvider.of<LoginBloc>(context)
                                    .add(DoLoginEvent(loginDto));
                              }
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    top: 100, left: 30, right: 30),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                decoration: BoxDecoration(
                                    color: AppColors.cyan,
                                    border: Border.all(
                                        color: AppColors.cyan, width: 2),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                )),
                          )
                        ],
                      ),
                    )))));
  }
}
