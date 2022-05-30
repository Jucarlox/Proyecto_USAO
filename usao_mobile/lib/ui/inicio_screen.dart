import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';

import 'package:usao_mobile/styles/text.dart';
import 'package:like_button/like_button.dart';
import 'package:usao_mobile/ui/detail_product.dart';
import 'package:usao_mobile/ui/menu_screem.dart';
import 'package:usao_mobile/ui/search_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  String id = "";
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id')!;
    });
  }

  late ProductoRepository productoRepository;
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    loadCounter();
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            return ProductoBloc(productoRepository)..add(FetchAllProducto());
          }),
        ],
        child: Scaffold(
            body: SafeArea(
                child: Stack(children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: _createPublics(context, id, _formKey, textController),
          )
        ]))));
  }
}

Widget _createPublics(BuildContext context, String id, GlobalKey _formkey,
    TextEditingController textController) {
  return BlocBuilder<ProductoBloc, ProductoState>(
    builder: (context, state) {
      if (state is ProductoInitialState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ProductoErrorState) {
        return Text("error");
      } else if (state is ProductoFetchedAll) {
        return _createPopularView(context, state.productoGangas,
            state.productoAll, id, _formkey, textController);
      } else {
        return Center(child: Text("No hay post publicos actualmente"));
      }
    },
  );
}

Widget _createPopularView(
    BuildContext context,
    List<ProductoResponse> gangas,
    List<ProductoResponse> all,
    String id,
    GlobalKey _formkey,
    TextEditingController textController) {
  final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 60.0),
    child: Column(
      children: [
        Form(
          key: _formkey,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: textController,
                    cursorColor: Colors.grey,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide.none),
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      suffixIcon: Container(
                          padding: EdgeInsets.all(15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchScreen(
                                      text: textController.text,
                                    ),
                                  ));
                            },
                            child: Icon(CupertinoIcons.search),
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Gangas Actuales",
            style: KTextStyle.headerTextStyle,
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _post(context, gangas[index], id);
            },
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const VerticalDivider(
              color: Colors.transparent,
              width: 6.0,
            ),
            itemCount: gangas.length,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Productos",
            style: KTextStyle.headerTextStyle,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (all.length / 7),
          child: Flexible(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: all.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Wrap(
                      children: <Widget>[
                        Center(
                            child: Container(
                                height: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        all.elementAt(index).fileScale),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              DetailProductScreen(
                                                  id: all
                                                      .elementAt(index)
                                                      .id))),
                                  child: ListTile(
                                      leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: all
                                          .elementAt(index)
                                          .propietario
                                          .avatar,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                ))),
                        Container(
                          height: 69,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(all.elementAt(index).nombre,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: KTextStyle.textFieldHeading),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 11),
                                    child: Text(
                                      all.elementAt(index).precio.toString() +
                                          " €",
                                      maxLines: 2,
                                      style: KTextStyle.textFieldHintStyle,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  child: LikeButton(
                                    likeBuilder: (bool isliked) {
                                      return Icon(CupertinoIcons.heart_fill,
                                          color: all
                                                  .elementAt(index)
                                                  .idUsersLike
                                                  .contains(id)
                                              ? AppColors.cyan
                                              : Color.fromARGB(
                                                  255, 216, 216, 216));
                                    },
                                    onTap: (isLiked) {
                                      if (all
                                          .elementAt(index)
                                          .idUsersLike
                                          .contains(id)) {
                                        return dislike(isLiked,
                                            all.elementAt(index).id, context);
                                      } else {
                                        return like(isLiked,
                                            all.elementAt(index).id, context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
                }),
          ),
        )
      ],
    ),
  );
}

Widget _post(BuildContext context, ProductoResponse data, String id) {
  return Container(
    alignment: Alignment.bottomCenter,
    width: 160,
    height: 320,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Wrap(
        children: <Widget>[
          Center(
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(data.fileScale),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                DetailProductScreen(id: data.id))),
                    child: ListTile(
                        leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        imageUrl: data.propietario.avatar,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    )),
                  ))),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(data.precio.toString(),
                      style: KTextStyle.textFieldHeading),
                  subtitle: Text(
                    data.precio.toString() + " €",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                child: LikeButton(
                  likeBuilder: (bool isliked) {
                    return Icon(CupertinoIcons.heart_fill,
                        color: data.idUsersLike.contains(id)
                            ? AppColors.cyan
                            : Color.fromARGB(255, 216, 216, 216));
                  },
                  onTap: (isLiked) {
                    if (data.idUsersLike.contains(id)) {
                      return dislike(isLiked, data.id, context);
                    } else {
                      return like(isLiked, data.id, context);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Future<bool> like(status, id, context) async {
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

Future<bool> dislike(status, id, context) async {
  //your code

  BlocProvider.of<ProductoBloc>(context).add(DislikeProductoEvent(id));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('indice', 0);
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    ),
    (Route route) => false,
  );
  return Future.value(!status);
}
