import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/styles/text.dart';
import 'package:ionicons/ionicons.dart';

class DetailProductScreen extends StatefulWidget {
  DetailProductScreen({Key? key, this.id}) : super(key: key);
  final id;
  @override
  _DetailProductScreenState createState() => _DetailProductScreenState(id);
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final id;
  _DetailProductScreenState(this.id);
  late ProductoRepository productoRepository;

  String uid = "";
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('id')!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadCounter();
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductoBloc(productoRepository)..add(ProductoIdEvent(id));
      },
      child: Scaffold(
        body: _createPublics(context, uid),
      ),
    );
  }
}

Widget _createPublics(BuildContext context, String uid) {
  return BlocBuilder<ProductoBloc, ProductoState>(
    builder: (context, state) {
      if (state is ProductoInitialState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ProductoErrorState) {
        return Text("error");
      } else if (state is ProductoSuccessState) {
        return _post(context, state.productoResponse, uid);
      } else {
        return Center(child: Text("No hay post publicos actualmente"));
      }
    },
  );
}

Widget _post(BuildContext context, ProductoResponse data, String uid) {
  return Scaffold(
    backgroundColor: AppColors.kBgColor,
    appBar: AppBar(
      backgroundColor: AppColors.kBgColor,
      elevation: 0,
    ),
    body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .67,
          padding: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          child: Image.network(data.fileScale),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.nombre,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            data.precio.toString() + '€',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        data.descripcion,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.kGreyColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: Container(
      height: 70,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kGreyColor),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
              child: LikeButton(
                likeBuilder: (bool isliked) {
                  return Icon(CupertinoIcons.heart_fill,
                      color: data.idUsersLike.contains(uid)
                          ? Colors.red
                          : Color.fromARGB(255, 216, 216, 216));
                },
                onTap: (isLiked) {
                  return changedata(isLiked, data.id, context);
                },
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    ),
  );
}

Future<bool> changedata(status, id, context) async {
  //your code

  BlocProvider.of<ProductoBloc>(context).add(LikeProductoEvent(id));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('indice', 1);
  Navigator.pushNamed(context, '/home');
  return Future.value(!status);
}
