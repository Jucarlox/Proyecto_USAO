import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/ui/chat_screen.dart';
import 'package:usao_mobile/ui/favoritos_screen.dart';
import 'package:usao_mobile/ui/inicio_screen.dart';
import 'package:usao_mobile/ui/perfil_screen.dart';
import 'package:usao_mobile/ui/subelo_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  var screens = [
    InicioScreen(),
    FavoritosScreen(),
    SubeloScreen(),
    ChatScreen(),
    PerfilScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: true,
      tabBar: CupertinoTabBar(
        activeColor: AppColors.cyan,
        items: const [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: Icon(
              CupertinoIcons.home,
              color: AppColors.cyan,
            ),
            activeIcon: Icon(
              CupertinoIcons.house_fill,
              color: AppColors.cyan,
            ),
          ),
          BottomNavigationBarItem(
            label: "Favoritos",
            icon: Icon(CupertinoIcons.suit_heart, color: AppColors.cyan),
            activeIcon: Icon(CupertinoIcons.heart_fill, color: AppColors.cyan),
          ),
          BottomNavigationBarItem(
              label: "Subelo",
              icon: Icon(CupertinoIcons.add_circled, color: AppColors.cyan),
              activeIcon: Icon(
                CupertinoIcons.add_circled_solid,
                color: AppColors.cyan,
              )),
          BottomNavigationBarItem(
              label: "Chat",
              icon: Icon(CupertinoIcons.chat_bubble_2, color: AppColors.cyan),
              activeIcon: Icon(
                CupertinoIcons.chat_bubble_2_fill,
                color: AppColors.cyan,
              )),
          BottomNavigationBarItem(
              label: "Perfil",
              icon:
                  Icon(CupertinoIcons.person_alt_circle, color: AppColors.cyan),
              activeIcon: Icon(
                CupertinoIcons.person_alt_circle_fill,
                color: AppColors.cyan,
              ))
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return screens[index];
      },
    );
  }
}
