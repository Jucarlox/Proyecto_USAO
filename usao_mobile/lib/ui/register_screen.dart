import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/auth/register/register_bloc.dart';
import 'package:usao_mobile/bloc/image_pick/image_pick_bloc.dart';
import 'package:usao_mobile/models/register/register_dto.dart';
import 'package:usao_mobile/repository/auth/auth_repository.dart';
import 'package:usao_mobile/repository/auth/auth_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/widgets/custom_header.dart';
import '../bloc/auth/login/login_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthRepository authRepository;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nickController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String filePath = '';
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  TextEditingController dateController = TextEditingController();
  bool publicController = true;

  @override
  void initState() {
    authRepository = AuthRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return RegisterBloc(authRepository);
        },
        child: _createBody(context));
  }

  _createBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<RegisterBloc, RegisterState>(
                listenWhen: (context, state) {
              return state is RegisterSuccessState ||
                  state is RegisterErrorState;
            }, listener: (context, state) async {
              if (state is RegisterSuccessState) {
                final prefs = await SharedPreferences.getInstance();
                // Shared preferences > guardo el token
                prefs.setString('avatar', state.registerResponse.avatar);
                Navigator.pushNamed(
                  context,
                  '/',
                );
              } else if (state is RegisterErrorState) {
                _showSnackbar(context, state.message);
              }
            }, buildWhen: (context, state) {
              return state is RegisterInitialState ||
                  state is RegisterLoadingState;
            }, builder: (ctx, state) {
              if (state is RegisterInitialState) {
                return buildForm(ctx);
              } else if (state is RegisterLoadingState) {
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
                      minHeight: MediaQuery.of(context).size.height - 90,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                            child: Text(
                              'Registro',
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
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),

                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: deviceWidth - 100,
                                child: TextFormField(
                                  style: TextStyle(color: AppColors.cyan),
                                  controller: nickController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.person,
                                        color: AppColors.cyan,
                                      ),
                                      suffixIconColor: AppColors.cyan,
                                      hintText: 'Nick',
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
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
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cyan,
                                      ),
                                      hintText: 'Email',
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
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
                                          borderSide:
                                              BorderSide(color: Colors.white))),
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
                                  controller: password2Controller,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.vpn_key,
                                        color: AppColors.cyan,
                                      ),
                                      suffixIconColor: Colors.white,
                                      hintText: 'Repeat Password',
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  onSaved: (String? value) {
                                    // This optional block of code can be used to run
                                    // code when the user saves the form.
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: deviceWidth - 100,
                                child: Row(
                                  children: [
                                    Text("Público:"),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 50.0),
                                      child: Switch(
                                        activeColor: AppColors.cyan,
                                        value: publicController,
                                        onChanged: (value) {
                                          setState(() {
                                            publicController = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: deviceWidth - 100,
                                child: TextField(
                                  controller: dateController,
                                  decoration: const InputDecoration(
                                    labelText: "Fecha de nacimiento",
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(formattedDate);

                                      setState(() {
                                        dateController.text = formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                              //avatar
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: deviceWidth - 100,
                                child: BlocProvider(
                                  create: (context) {
                                    return ImagePickBloc();
                                  },
                                  child: BlocConsumer<ImagePickBloc,
                                          ImagePickState>(
                                      listenWhen: (context, state) {
                                        return state
                                            is ImageSelectedSuccessState;
                                      },
                                      listener: (context, state) {},
                                      buildWhen: (context, state) {
                                        return state is ImagePickBlocInitial ||
                                            state is ImageSelectedSuccessState;
                                      },
                                      builder: (context, state) {
                                        if (state
                                            is ImageSelectedSuccessState) {
                                          print(
                                              'PATH ${state.pickedFile.path}');
                                          filePath = state.pickedFile.path;
                                          return Column(children: [
                                            Image.file(
                                              File(state.pickedFile.path),
                                              height: 100,
                                            )
                                          ]);
                                        }
                                        return Center(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppColors.cyan,
                                                ),
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              ImagePickBloc>(
                                                          context)
                                                      .add(
                                                          const SelectImageEvent(
                                                              ImageSource
                                                                  .gallery));
                                                },
                                                child: const Text(
                                                    'Selecciona una imagen')));
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Text('Estas Registrado?'),
                              TextButton(
                                child: const Text(
                                  'Logueate',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColors.cyan),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                final registerDto = RegisterDto(
                                    avatar: "",
                                    nick: nickController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    password2: password2Controller.text,
                                    fechaNacimiento: dateController.text,
                                    privacity: publicController);
                                BlocProvider.of<RegisterBloc>(context).add(
                                    DoRegisterEvent(registerDto, filePath));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      top: 30, left: 30, right: 30),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  decoration: BoxDecoration(
                                      color: AppColors.cyan,
                                      border: Border.all(
                                          color: AppColors.cyan, width: 2),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    'Registrar'.toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          )
                        ],
                      ),
                    )))));
  }
}