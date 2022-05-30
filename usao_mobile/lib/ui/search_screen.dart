import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/styles/text.dart';
import 'package:usao_mobile/ui/detail_product.dart';
import 'package:usao_mobile/ui/inicio_screen.dart';

import '../models/producto/producto_response.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, this.text}) : super(key: key);
  final text;

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState(text);
}

String id = "";
void loadCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  id = prefs.getString('id')!;
}

class _FavoritosScreenState extends State<SearchScreen> {
  final text;
  _FavoritosScreenState(this.text);
  late ProductoRepository productoRepository;
  @override
  void initState() {
    loadCounter();
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductoBloc(productoRepository)..add(SearchProductoEvent(text));
      },
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "Busquedas",
            style: KTextStyle.headerTextStyle,
          ),
        ),
        body: _createPublics(context),
      ),
    );
  }
}

Widget _createPublics(BuildContext context) {
  return BlocBuilder<ProductoBloc, ProductoState>(
    builder: (context, state) {
      if (state is ProductoInitialState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ProductoErrorState) {
        return Text("error");
      } else if (state is ProductoFetched) {
        return _createPopularView(context, state.productosSearch);
      } else {
        return Center(child: Text("No hay productos"));
      }
    },
  );
}

Widget _createPopularView(
    BuildContext context, List<ProductoResponse> productos) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Column(
      children: [
        Flexible(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: productos.length,
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
                                      productos.elementAt(index).fileScale),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            DetailProductScreen(
                                                id: productos
                                                    .elementAt(index)
                                                    .id))),
                                child: ListTile(
                                    leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    imageUrl: productos
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
                                title: Text(productos.elementAt(index).nombre,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: KTextStyle.textFieldHeading),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 11),
                                  child: Text(
                                    productos
                                            .elementAt(index)
                                            .precio
                                            .toString() +
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
                                        color: productos
                                                .elementAt(index)
                                                .idUsersLike
                                                .contains(id)
                                            ? AppColors.cyan
                                            : Color.fromARGB(
                                                255, 216, 216, 216));
                                  },
                                  onTap: (isLiked) {
                                    if (productos
                                        .elementAt(index)
                                        .idUsersLike
                                        .contains(id)) {
                                      return dislike(
                                          isLiked,
                                          productos.elementAt(index).id,
                                          context);
                                    } else {
                                      return like(
                                          isLiked,
                                          productos.elementAt(index).id,
                                          context);
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
      ],
    ),
  );
}
