import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:insta_like_button/insta_like_button.dart';
import 'package:usao_mobile/styles/text.dart';

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
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "error",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
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
      child: Wrap(
        children: <Widget>[
          Center(
              child: Container(
            height: 230,
            decoration: BoxDecoration(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: ListTile(
              title: Text(data.nombre, style: KTextStyle.textFieldHeading),
              subtitle: Text(
                data.descripcion,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

/**/ 

/*return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(.3)))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
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
          ),
          title: Text(
            data.nombre,
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w400,
                fontSize: 21),
          ),
          trailing: const Icon(Icons.more_vert),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            data.nombre,
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w400,
                fontSize: 15),
          ),
        ),
        InstaLikeButton(
          image: NetworkImage(data.fileScale.toString()),
          onChanged: () {},
          icon: Icons.favorite,
          iconSize: 80,
          iconColor: Colors.red,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  Icon(
                    Icons.favorite_border,
                    size: 31,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.comment_sharp, size: 31),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.send, size: 31),
                ],
              ),
              const Icon(Icons.bookmark_border, size: 31)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            'liked by you and 299 others',
            style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            data.descripcion,
            style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.8)),
          ),
        )
      ],
    ),
  );*/ 