import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/bloc/user/user_bloc.dart';
import 'package:usao_mobile/models/user/profile_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/repository/user/user_repository.dart';
import 'package:usao_mobile/repository/user/user_repository_impl.dart';
import 'package:usao_mobile/styles/text.dart';
import 'package:usao_mobile/ui/edit_producto_screen.dart';
import 'package:usao_mobile/ui/edit_user_screen.dart';
import 'package:usao_mobile/ui/error_screen.dart';
import 'package:usao_mobile/ui/image_screen.dart';
import 'package:usao_mobile/ui/menu_screem.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilScreen> {
  late UserRepository userRepository;
  late ProductoRepository productoRepository;

  @override
  void initState() {
    // TODO: implement initState
    userRepository = UserRepositoryImpl();
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UserBloc(userRepository, productoRepository)
          ..add(const FetchUser());
      },
      child: Scaffold(body: _createPublics(context)),
    );
  }
}

Widget _createPublics(BuildContext context) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInitial) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is UserFetchError) {
        return ErrorPage(
          message: state.message,
          retry: () {
            context.watch<UserBloc>().add(FetchUser());
          },
        );
      } else if (state is UserFetched) {
        return _profile(context, state.user);
      } else {
        return const Text('Not support');
      }
    },
  );
}

Widget _profile(BuildContext context, ProfileResponse user) {
  return SafeArea(
    child: Column(
      children: [
        Column(
          children: [
            SizedBox(height: 20.0),
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
              radius: 70.0,
            ),
            SizedBox(height: 10.0),
            Text(
              user.nick,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 20.0),
                Column(
                  children: [
                    Text(
                      user.productoList.length.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Productos",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.productoListLike.length.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Favoritos",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                SizedBox(width: 20.0),
              ],
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
              child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  width: 320,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    EditUserScreen(id: user.id)));
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.black),
                      ))),
            ),
          ],
        ),
        const Divider(
          height: 10,
        ),
        const SizedBox(
          width: 20,
        ),

        /*Image(  image: NetworkImage(user.publicaciones.elementAt(0).file.toString().replaceFirst('localhost', '10.0.2.2')),
                        
                        ),*/
        Flexible(
          child: GridView.builder(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: user.productoList.length,
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
                                  image: NetworkImage(user.productoList
                                      .elementAt(index)
                                      .fileScale),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ImageScreen(
                                            image: user.productoList
                                                .elementAt(index)
                                                .fileScale))),
                                child: ListTile(
                                    leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    imageUrl: user.avatar,
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
                                title: Text(
                                    user.productoList.elementAt(index).nombre,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: KTextStyle.textFieldHeading),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 11),
                                  child: Text(
                                    user.productoList
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
                            CupertinoButton(
                              child: Icon(
                                CupertinoIcons.square_pencil,
                                color: Colors.grey,
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => EditProductoScreen(
                                          id: user.productoList
                                              .elementAt(index)
                                              .id))),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                child: LikeButton(
                                  likeBuilder: (isLiked) {
                                    return Icon(CupertinoIcons.delete,
                                        color:
                                            isLiked ? Colors.red : Colors.red);
                                  },
                                  onTap: (isLiked) {
                                    return changedata(
                                        isLiked,
                                        user.productoList.elementAt(index).id,
                                        context);
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
        /*Container(
                width: 120,
                height: 150,
                child: Image(
                  image: AssetImage('assets/images/luismi.png'),
                  fit: BoxFit.contain,
                )),*/
      ],
    ),
  );
}

Future<bool> changedata(status, id, context) async {
  //your code

  BlocProvider.of<UserBloc>(context).add(DeleteProductoEvent(id));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('indice', 4);
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    ),
    (Route route) => false,
  );
  return Future.value(!status);
}
