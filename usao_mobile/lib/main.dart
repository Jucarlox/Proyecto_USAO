import 'package:flutter/material.dart';
import 'package:usao_mobile/repository/preferences_utils.dart';
import 'package:usao_mobile/ui/login_screen.dart';
import 'package:usao_mobile/ui/menu_screem.dart';
import 'package:usao_mobile/ui/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  runApp(const MyApp());
}

final Map<int, Color> _tealAccent700Map = {
  100: Color(0xFFA7FFEB),
  900: Colors.tealAccent,
  400: Colors.tealAccent.shade400,
  700: Colors.tealAccent.shade700,
};
final MaterialColor _yellow700Swatch = MaterialColor(100, _tealAccent700Map);

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
/*        '/profile': (context) => const ProfileScreen(),
        '/search': (context) => const SearchScreen(),
        '/post-form': (context) => const PostForm(),*/
      },
    );
  }
}