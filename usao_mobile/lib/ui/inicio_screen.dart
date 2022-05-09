import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:insta_like_button/insta_like_button.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/styles/text.dart';
import 'package:like_button/like_button.dart';
import 'package:usao_mobile/ui/error_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  late ProductoRepository productoRepository;

  @override
  void initState() {
    // TODO: implement initState
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
    return BlocProvider(
      create: (context) {
        return ProductoBloc(productoRepository)..add(FetchProductoWithType());
      },
      child: Scaffold(
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
        return Center(child: Text("No hay post publicos actualmente"));
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
                  likeBuilder: (isLiked) {
                    return Icon(CupertinoIcons.heart_fill,
                        color: isLiked
                            ? Colors.red
                            : Color.fromARGB(255, 216, 216, 216));
                  },
                  onTap: (isLiked) {
                    return changedata(isLiked, data.id, context);
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

Future<bool> changedata(status, id, context) async {
  //your code

  BlocProvider.of<ProductoBloc>(context).add(LikeProductoEvent(id));
  return Future.value(!status);
}
