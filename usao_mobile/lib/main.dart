import 'package:flutter/material.dart';
import 'package:usao_mobile/repository/preferences_utils.dart';
import 'package:usao_mobile/ui/login_screen.dart';
import 'package:usao_mobile/ui/menu_screem.dart';
import 'package:usao_mobile/ui/perfil_screen.dart';
import 'package:usao_mobile/ui/register_screen.dart';
import 'package:usao_mobile/ui/subelo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'USAO',
      //theme: ThemeData(accentColor: Colors.tealAccent.shade700),
      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const PerfilScreen(),
        '/subelo': (context) => const SubeloScreen(),
        //       '/post-form': (context) => const PostForm(),
      },
    );
  }
}
