import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:searchfield/searchfield.dart';

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
  TextEditingController localizacionController = TextEditingController();
  String filePath = '';
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  TextEditingController dropdownValue = TextEditingController(text: 'one');
  String _selectedItem = '';
  String? selectedValue;

  TextEditingController dateController = TextEditingController();
  bool publicController = true;

  final auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                //prefs.setString('avatar', state.registerResponse.avatar);
                prefs.setString('id', state.registerResponse.id);
                prefs.setString('nick', state.registerResponse.nick);
                prefs.setString('email', state.registerResponse.email);
                createUserInFirestore(
                    state.registerResponse.nick,
                    state.registerResponse.email,
                    state.registerResponse.avatar,
                    state.registerResponse.id);
                Navigator.pushNamed(
                  context,
                  '/home',
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
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cyan,
                                      ),
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
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);

                                      setState(() {
                                        dateController.text = formattedDate;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: deviceWidth - 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SearchField(
                                  searchStyle: TextStyle(color: AppColors.cyan),
                                  hint: 'Localización',
                                  searchInputDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.cyan,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: AppColors.cyan,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  maxSuggestionsInViewPort: 6,
                                  itemHeight: 50,
                                  suggestionsDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onSuggestionTap:
                                      (SearchFieldListItem<String> x) {
                                    setState(() {
                                      _selectedItem = x.item!;
                                    });
                                  },
                                  suggestions: [
                                    'Álava',
                                    'Albacete',
                                    'Alicante',
                                    'Almería',
                                    'Asturias',
                                    'Ávila',
                                    'Badajoz',
                                    'Barcelona',
                                    'Burgos',
                                    'Cáceres',
                                    'Cádiz',
                                    'Cantabria',
                                    'Castellón',
                                    'Ceuta',
                                    'Ciudad Real',
                                    'Córdoba',
                                    'Cuenca',
                                    'Gerona',
                                    'Granada',
                                    'Guadalajara',
                                    'Guipúzcoa',
                                    'Huelva',
                                    'Huesca',
                                    'Islas Baleares',
                                    'Jaén',
                                    'La Coruña',
                                    'La Rioja',
                                    'Las Palmas',
                                    'León',
                                    'Lérida',
                                    'Lugo',
                                    'Madrid',
                                    'Málaga',
                                    'Melilla',
                                    'Murcia',
                                    'Navarra',
                                    'Orense',
                                    'Palencia',
                                    'Pontevedra',
                                    'Salamanca',
                                    'Santa Cruzde Tenerife',
                                    'Segovia',
                                    'Sevilla',
                                    'Soria',
                                    'Tarragona',
                                    'Teruel',
                                    'Toledo',
                                    'Valencia',
                                    'Valladolid',
                                    'Vizcaya',
                                    'Zamora',
                                    'Zaragoza'
                                  ]
                                      .map((country) => SearchFieldListItem(
                                          country,
                                          item: country))
                                      .toList(),
                                ),
                              ),
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
                                                  /*BlocProvider.of<
                                                              ImagePickBloc>(
                                                          context)
                                                      .add(
                                                          const SelectImageEvent(
                                                              ImageSource
                                                                  .gallery));*/

                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      actionsAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      title: Center(
                                                        child: const Text(
                                                          'Elija una opción',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .cyan),
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => {
                                                            BlocProvider.of<
                                                                        ImagePickBloc>(
                                                                    context)
                                                                .add(const SelectImageEvent(
                                                                    ImageSource
                                                                        .gallery))
                                                          },
                                                          child: const Text(
                                                            'Galeria',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => {
                                                            BlocProvider.of<
                                                                        ImagePickBloc>(
                                                                    context)
                                                                .add(const SelectImageEvent(
                                                                    ImageSource
                                                                        .camera))
                                                          },
                                                          child: const Text(
                                                            'Camara',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
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
                                    localizacion: _selectedItem);

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

  void createUserInFirestore(
      String nick, String email, String filePath, String uid) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email, password: passwordController.text)
        .then((value) => users.doc(value.user!.uid).set(
            {'nick': nick, 'email': email, 'avatar': filePath, 'uid': uid}));
    //users.add({'nick': nick, 'email': email, 'avatar': filePath, 'uid': uid});
  }
}
