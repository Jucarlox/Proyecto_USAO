import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/ui/chat_screen.dart';
import 'package:usao_mobile/ui/favoritos_screen.dart';
import 'package:usao_mobile/ui/inicio_screen.dart';
import 'package:usao_mobile/ui/perfil_screen.dart';
import 'package:usao_mobile/ui/subelo_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> pages = [
    const InicioScreen(),
    const FavoritosScreen(),
    const SubeloScreen(),
    const ChatScreen(),
    const PerfilScreen()
  ];

  late ProductoRepository productoRepository;

  @override
  void initState() {
    // TODO: implement initState
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductoBloc(productoRepository)
          ..add(const FetchProductoWithType());
      },
      child: Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: _buildBottomBar(context)),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(
            color: Color(0xfff1f1f1),
            width: 1.0,
          ),
        )),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: _currentIndex == 0
                  ? const Icon(
                      CupertinoIcons.house_fill,
                      color: AppColors.cyan,
                    )
                  : const Icon(
                      CupertinoIcons.home,
                      color: AppColors.cyan,
                    ),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            GestureDetector(
              child: _currentIndex == 1
                  ? const Icon(
                      CupertinoIcons.heart_fill,
                      color: AppColors.cyan,
                    )
                  : const Icon(
                      CupertinoIcons.suit_heart,
                      color: AppColors.cyan,
                    ),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            GestureDetector(
              child: _currentIndex == 2
                  ? const Icon(
                      CupertinoIcons.add_circled_solid,
                      color: AppColors.cyan,
                    )
                  : const Icon(
                      CupertinoIcons.add_circled,
                      color: AppColors.cyan,
                    ),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            GestureDetector(
              child: _currentIndex == 3
                  ? const Icon(
                      CupertinoIcons.chat_bubble_2_fill,
                      color: AppColors.cyan,
                    )
                  : const Icon(
                      CupertinoIcons.chat_bubble_2,
                      color: AppColors.cyan,
                    ),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
            GestureDetector(
              child: _currentIndex == 4
                  ? const Icon(
                      CupertinoIcons.person_alt_circle_fill,
                      color: AppColors.cyan,
                    )
                  : const Icon(
                      CupertinoIcons.person_alt_circle,
                      color: AppColors.cyan,
                    ),
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
              },
            ),
          ],
        ));
  }
}
