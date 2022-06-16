import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/auth/register/register_bloc.dart';
import 'package:usao_mobile/bloc/image_pick/image_pick_bloc.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_dto.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/models/register/register_response.dart';
import 'package:usao_mobile/models/user/editUserDto.dart';
import 'package:usao_mobile/models/user/profile_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/repository/user/user_repository.dart';
import 'package:usao_mobile/repository/user/user_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/ui/menu_screem.dart';

import '../bloc/user/user_bloc.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({Key? key, this.id}) : super(key: key);
  final id;
  @override
  _UserEditFormState createState() => _UserEditFormState(id);
}

class _UserEditFormState extends State<EditUserScreen> {
  final id;
  _UserEditFormState(this.id);
  late UserRepository userRepository;
  late ProductoRepository productoRepository;
  final _formKey = GlobalKey<FormState>();
  String filePath = '';
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  TextEditingController nickController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController localizacionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _selectedItem = '';
  String dropdownValue = 'coches';
  String nombre = '';
  String descripcion = '';
  String precio = '';
  String categoria = 'coche';

  @override
  void initState() {
    userRepository = UserRepositoryImpl();
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            return UserBloc(userRepository, productoRepository)
              ..add(const FetchUserEdit());
          }),
        ],
        child: Scaffold(
          appBar: CupertinoNavigationBar(),
          body: _createBody(context),
        ));
  }

  _createBody(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
            child:
                BlocConsumer<UserBloc, UserState>(listenWhen: (context, state) {
              return state is UserFetchError || state is FetchUserEdit;
            }, listener: (context, state) async {
              if (state is UserEditState) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('indice', 4);

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                  (Route route) => false,
                );
              } else if (state is UserFetchError) {
                _showSnackbar(context, state.message);
              }
            }, buildWhen: (context, state) {
              return state is UserInitialEditState;
            }, builder: (ctx, state) {
              if (state is UserInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserFetchError) {
                return Text("error");
              } else if (state is UserInitialEditState) {
                return buildForm(ctx, state.editResponse);
              } else {
                return const Center(child: CircularProgressIndicator());
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

  Widget buildForm(BuildContext context, ProfileResponse editResponse) {
    nickController = TextEditingController(text: editResponse.nick);
    fechaNacimientoController =
        TextEditingController(text: editResponse.fechaNacimiento);
    _selectedItem = editResponse.localizacion;
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
                              'Editar User',
                              style: TextStyle(
                                  fontSize: 50, color: AppColors.cyan),
                            ),
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
                                      hintText: 'Nombre del Usuario',
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
                                  controller: fechaNacimientoController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cyan,
                                      ),
                                      hintText: 'Fecha',
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
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: AppColors.cyan),
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cyan,
                                      ),
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
                                                  BlocProvider.of<
                                                              ImagePickBloc>(
                                                          context)
                                                      .add(
                                                          const SelectImageEvent(
                                                              ImageSource
                                                                  .gallery));
                                                },
                                                child: const Text(
                                                    'Cambiar imagen')));
                                      }),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                final editDto = EditUserDto(
                                  nick: nickController.text,
                                  fechaNacimiento:
                                      fechaNacimientoController.text,
                                  localizacion: localizacionController.text,
                                  password: passwordController.text,
                                );

                                if (filePath.isEmpty) {
                                  BlocProvider.of<UserBloc>(context).add(
                                      EditUserEvent(
                                          editDto, editResponse.avatar));
                                } else {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(EditUserEvent(editDto, filePath));
                                }
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
                                    'Editar'.toUpperCase(),
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
