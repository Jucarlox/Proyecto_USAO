import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usao_mobile/styles/colors.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key, this.image}) : super(key: key);

  final image;
  @override
  _ImageScreenState createState() => _ImageScreenState(image);
}

class _ImageScreenState extends State<ImageScreen> {
  final image;
  _ImageScreenState(this.image);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.kBgColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Center(child: Image.network(image)),
    );
  }
}
