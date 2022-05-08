import 'dart:io';

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
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';

class SubeloScreen extends StatefulWidget {
  const SubeloScreen({Key? key}) : super(key: key);

  @override
  _ProductoFormState createState() => _ProductoFormState();
}

class _ProductoFormState extends State<SubeloScreen> {
  late ProductoRepository productoRepository;
  final _formKey = GlobalKey<FormState>();
  String filePath = '';
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  String _selectedItem = '';
  String dropdownValue = 'coches';

  @override
  void initState() {
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return ProductoBloc(productoRepository);
        },
        child: _createBody(context));
  }

  _createBody(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<ProductoBloc, ProductoState>(
                listenWhen: (context, state) {
              return state is ProductoSuccessState ||
                  state is ProductoErrorState;
            }, listener: (context, state) async {
              if (state is ProductoSuccessState) {
                final prefs = await SharedPreferences.getInstance();
                Navigator.pushNamed(context, '/');
              } else if (state is ProductoErrorState) {
                _showSnackbar(context, state.message);
              }
            }, buildWhen: (context, state) {
              return state is ProductoInitialState;
            }, builder: (ctx, state) {
              if (state is ProductoInitialState) {
                return buildForm(ctx);
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
                              'Crear Producto',
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
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.person,
                                        color: AppColors.cyan,
                                      ),
                                      suffixIconColor: AppColors.cyan,
                                      hintText: 'Nombre del Producto',
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
                                  controller: descripcionController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cyan,
                                      ),
                                      hintText: 'Descripcion del Producto',
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
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: AppColors.cyan),
                                  controller: precioController,
                                  decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cyan,
                                      ),
                                      hintText: 'Precio del Producto',
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text(
                                        "Categoria: ",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      elevation: 8,
                                      style: const TextStyle(
                                          color: AppColors.cyan),
                                      underline: Container(
                                        height: 1,
                                        color: AppColors.cyan,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'coches',
                                        'motos',
                                        'moviles',
                                        'moda'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  ],
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
                                                    'Selecciona una imagen')));
                                      }),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                final productoDto = ProductoDto(
                                    nombre: titleController.text,
                                    descripcion: descripcionController.text,
                                    fileOriginal: "",
                                    fileScale: "",
                                    precio: double.parse(precioController.text),
                                    categoria: dropdownValue);

                                BlocProvider.of<ProductoBloc>(context).add(
                                    DoProductoEvent(productoDto, filePath));
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
                                    'Crear'.toUpperCase(),
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
