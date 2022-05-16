import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usao_mobile/bloc/producto/producto_bloc.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/producto/producto_repository_impl.dart';
import 'package:usao_mobile/styles/colors.dart';
import 'package:usao_mobile/styles/text.dart';
import 'package:ionicons/ionicons.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  late ProductoRepository productoRepository;
  @override
  void initState() {
    // TODO: implement initState
    productoRepository = ProductoRepositoryImpl();
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductoBloc(productoRepository)
          ..add(const FetchProductoWithType());
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
        return _post(context, state.productos);
      } else {
        return Center(child: Text("No hay post publicos actualmente"));
      }
    },
  );
}

Widget _post(BuildContext context, ProductoResponse data) {
  return Scaffold(
    backgroundColor: AppColors.kBgColor,
    appBar: AppBar(
      backgroundColor: AppColors.kBgColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Ionicons.chevron_back,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Ionicons.bag_outline,
            color: Colors.black,
          ),
        ),
      ],
    ),
    body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .35,
          padding: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          child: Image.asset('assets/images/main_image.png'),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chanel',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Name',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$135.00',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor consectetur tortor vitae interdum.',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Similar This',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.kGreyColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: Container(
      height: 70,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kGreyColor),
            ),
            child: Icon(
              Ionicons.heart_outline,
              size: 30,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    ),
  );
}
