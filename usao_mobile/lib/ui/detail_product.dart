import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:usao_mobile/ui/image_screen.dart';
import 'package:usao_mobile/ui/menu_screem.dart';
import 'package:usao_mobile/ui/message.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
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

  bool a = true;

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductoBloc(productoRepository)..add(ProductoIdEvent(id));
      },
      child: Scaffold(
        body: _createPublics(context, uid, currentUser, a),
      ),
    );
  }
}

Widget _createPublics(
    BuildContext context, String uid, String currentUser, bool a) {
  return BlocBuilder<ProductoBloc, ProductoState>(
    builder: (context, state) {
      if (state is ProductoInitialState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ProductoErrorState) {
        return Text("error");
      } else if (state is ProductoSuccessState) {
        return _post(context, state.productoResponse, uid, currentUser, a);
      } else {
        return Center(child: Text("No hay post publicos actualmente"));
      }
    },
  );
}

Widget _post(BuildContext context, ProductoResponse data, String uid,
    String currentUser, bool a) {
  return Scaffold(
    backgroundColor: AppColors.kBgColor,
    appBar: AppBar(
      backgroundColor: AppColors.kBgColor,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    ),
    body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .67,
          padding: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                data.propietario.nick,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              ImageScreen(image: data.fileScale))),
                  child: Image.network(
                    data.fileScale,
                    width: MediaQuery.of(context).size.height / 3,
                  ))
            ],
          ),
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
                          ? AppColors.cyan
                          : Color.fromARGB(255, 216, 216, 216));
                },
                onTap: (isLiked) {
                  return changedata(isLiked, data.id, context);
                },
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print(currentUser);

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser)
                      .collection('chats')
                      .limit(1)
                      .get()
                      .then((snapshot) {
                    print(snapshot.size);
                    if (snapshot.size == 0) {
                      print('aaaaa');
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser)
                          .collection('chats')
                          .add({
                        'email': data.propietario.email,
                        'nick': data.propietario.nick,
                        'uid': data.propietario.id
                      });

                      FirebaseFirestore.instance
                          .collection('users')
                          .get()
                          .then((value) => {
                                for (var doc in value.docs)
                                  {
                                    if (doc
                                        .data()
                                        .containsValue(data.propietario.id))
                                      {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(doc.id)
                                            .collection('chats')
                                            .add({
                                          'email': prefs.get('email'),
                                          'nick': prefs.get('nick'),
                                          'uid': prefs.get('id'),
                                        })
                                      }
                                  }
                              });
                    }
                  });

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser)
                      .collection('chats')
                      .get()
                      .then((value) => {
                            for (var doc in value.docs)
                              {
                                print(doc),
                                print('aaaaaaaaaa'),
                                if (!doc
                                    .data()
                                    .containsValue(data.propietario.nick))
                                  {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUser)
                                        .collection('chats')
                                        .add({
                                      'email': data.propietario.email,
                                      'nick': data.propietario.nick,
                                      'uid': data.propietario.id
                                    }),
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .get()
                                        .then((value) => {
                                              for (var doc in value.docs)
                                                {
                                                  if (doc.data().containsValue(
                                                      data.propietario.id))
                                                    {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(doc.id)
                                                          .collection('chats')
                                                          .add({
                                                        'email':
                                                            prefs.get('email'),
                                                        'nick':
                                                            prefs.get('nick'),
                                                        'uid': prefs.get('id'),
                                                      })
                                                    }
                                                }
                                            })
                                  }
                              }
                          });

                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ChatDetail(
                              friendUid: data.propietario.id,
                              friendName: data.propietario.nick)));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Chat',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
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
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    ),
    (Route route) => false,
  );
  return Future.value(!status);
}
