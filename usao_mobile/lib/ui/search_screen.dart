import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/text.dart';
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
        return _createPopularView(context, state.productos);
      } else {
        return Center(child: Text("No hay productos"));
      }
    },
  );
}

Widget _createPopularView(BuildContext context, List<ProductoResponse> movies) {
  final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 60.0),
    child: Column(
      children: [
        SizedBox(
          height: 300,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _post(context, movies[index]);
            },
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const VerticalDivider(
              color: Colors.transparent,
              width: 6.0,
            ),
            itemCount: movies.length,
          ),
        )
      ],
    ),
  );
}

Widget _post(BuildContext context, ProductoResponse data) {
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(data.fileScale),
                fit: BoxFit.cover,
              ),
            ),
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
          )),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(data.nombre, style: KTextStyle.textFieldHeading),
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
                            ? Colors.red
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
              )
            ],
          )
        ],
      ),
    ),
  );
}
