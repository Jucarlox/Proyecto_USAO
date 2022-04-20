import 'package:flutter/material.dart';
import 'package:usao/repository/preferences_utils.dart';
import 'package:usao/ui/register_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register',
      routes: {
/*        '/': (context) => const MenuScreen(),
        '/login': (context) => const LoginScreen(),*/
        '/': (context) => const RegisterScreen(),
/*        '/profile': (context) => const ProfileScreen(),
        '/search': (context) => const SearchScreen(),
        '/post-form': (context) => const PostForm(),*/
      },
    );
  }
}
