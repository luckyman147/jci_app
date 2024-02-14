import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../bloc/index_bloc.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({Key? key}) : super(key: key);


  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final controller=CarouselController();
  late IndexBloc indexBloc;
  @override
  void initState() {
    super.initState();
    indexBloc = BlocProvider.of<IndexBloc>(context);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      indexBloc.add(resetIndex());
    }
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);

    return FutureBuilder<List<dynamic>>(
      future: _loadJsonData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
         List<dynamic> jsondata = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BlocBuilder<IndexBloc, IndexState>(
  builder: (context, state) {
    return CarouselSlider.builder(
carouselController:controller ,
                      options: CarouselOptions(
                       height: 500,

                        enlargeFactor: 1,
autoPlayInterval: const Duration(seconds: 5),
                        viewportFraction: 1,
initialPage: state.props[0] as int,


                        enableInfiniteScroll: false,
                        autoPlay: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,

                        onPageChanged: (index, reason) {
                          context.read<IndexBloc>().add(SetIndexEvent( index: index));

                        },
                        ),
                      itemCount: jsondata.length,
                      itemBuilder: (BuildContext context, int index, int realIndex) {
                        final urlImage = jsondata[index]['image'];
                        final titre = jsondata[index]['titre'];
                        final description = jsondata[index]['description'];

                        return _buildDescription(urlImage, titre, description, index,mediaQuery.size.width/2);
                      },
                    );
  },
),
                  ),
                ),



              ],
            );
          }
        } else {
          return CircularProgressIndicator(); // You can use your loading widget here
        }
      },
    );
  }

  Widget _buildDescription(String image, String titre, String description, int index,double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Align(
          alignment: Alignment.center,
            child: Image.asset(image, width: size, height: 250, fit: BoxFit.contain),
          ),
        ),
        BlocConsumer<IndexBloc, IndexState>(
          listener: (context, state) {
            if (state is IndexInitial) {
              _buildIndicator(0,3);

            }
          },
          builder: (context, state) {
            if (state is IndexInitial) {
              return _buildIndicator(0, 3);
            }
            else

            if (state is IndexLoaded) {
              print((state.currentIndex));
              return _buildIndicator(state.currentIndex, 3);

            }
            else if (state is ResetState){
              return _buildIndicator(state.index, 3);
            }

            else {

              // Handle other states if needed
              return _buildIndicator(0, 3);

            }
          },

        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("titre_$index".tr(context), style: PoppinsSemiBold(44,Colors.black,TextDecoration.none),),
            Padding(padding: EdgeInsets.only(left: 65,right: 30),
                child: Text("description_$index". tr(context), style: PoppinsNorml(16,Colors.black),textAlign: TextAlign.start,)),
          ],
        )

      ],
    );
  }

}



Future<List< dynamic>> _loadJsonData(BuildContext context) async {
  // Load the JSON file from the assets using DefaultAssetBundle
  String jsonString =
  await DefaultAssetBundle.of(context).loadString('assets/json/description.json');

  // Parse the JSON string
  List<dynamic> jsonData = json.decode(jsonString);

  // Now you can work with the parsed JSON data
  return jsonData;
}
Widget _buildIndicator(int index,int len){
  MediaQueryData mediaQuery=MediaQueryData();
  return Padding(
    padding:  EdgeInsets.only(bottom: 20,top:30 ),
    child:   Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(activeIndex: index, count: len, effect:const  WormEffect(
        dotColor: dotscolor,
        activeDotColor: Colors.black,
        type: WormType.thin,

      )),
    ),
  );}

