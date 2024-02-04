import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150.0,left: 7),
                    child: CarouselSlider.builder(
carouselController:controller ,
                      options: CarouselOptions(
                       height: 500,
                        enlargeFactor: 1,

                        viewportFraction: 1,



                        enableInfiniteScroll: false,
                        autoPlay: false,
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

                        return _buildDescription(urlImage, titre, description, index);
                      },
                    ),
                  ),
                ),

        BlocConsumer<IndexBloc, IndexState>(
          listener: (context, state) {
          if (state is IndexInitial) {
             _buildIndicator(0, jsondata.length);

          }
        },
        builder: (context, state) {
          if (state is IndexInitial) {
            return _buildIndicator(0, jsondata.length);
          }
          else

        if (state is IndexLoaded) {
          print((state.currentIndex));
        return _buildIndicator(state.currentIndex, jsondata.length);

        }
        else if (state is ResetState){
          return _buildIndicator(state.index, jsondata.length);
        }

        else {

        // Handle other states if needed
          return _buildIndicator(0, jsondata.length);

        }
        },

)

              ],
            );
          }
        } else {
          return CircularProgressIndicator(); // You can use your loading widget here
        }
      },
    );
  }

  Widget _buildDescription(String image, String titre, String description, int index) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<IndexBloc, IndexState>(
                  builder: (context, state) {
                    if(state is IndexLoaded){
                      return left_Arrow(state.currentIndex, controller);
                    }else{
                      return Container();
                    }
                  }
              ),
              Center(

                child: Image.asset(image, width: 270, height: 250, fit: BoxFit.contain),
              ),
              BlocBuilder<IndexBloc, IndexState>(
                  builder: (context, state) {
                    if(state is IndexLoaded){
                      return right_Arrow(state.currentIndex, controller);
                    }else{
                      return right_Arrow(0, controller);

                    }
                  }
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titre, style: PoppinsSemiBold(44,Colors.black,TextDecoration.none),),
              Padding(padding: EdgeInsets.only(left: 65,right: 30),
                  child: Text(description, style: PoppinsNorml(16,Colors.black),textAlign: TextAlign.start,)),
            ],
          )

        ],
      ),
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
Widget _buildIndicator(int index,int len)=>Padding(
  padding: const EdgeInsets.only(bottom: 30.0),
  child:   Padding(
    padding: const EdgeInsets.symmetric(vertical: 28.0),
    child: AnimatedSmoothIndicator(activeIndex: index, count: len, effect:const  WormEffect(
        dotColor: dotscolor,
        activeDotColor: Colors.black,
      type: WormType.thin,

    )),
  ),
);
Widget right_Arrow(int index, CarouselController controller) {
  if (index==0 || index ==1) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:index==1? 12.0:0),
      child: IconButton(
        icon: const Icon(Icons.keyboard_arrow_right, color: dotscolor, size: 60,),
        onPressed: () {
          controller.nextPage();
        },
      ),
    );
  }
  else { return Container();

  }
}Widget left_Arrow(int index, CarouselController controller) {
  if (index==2 || index ==1) {
    return Padding(
      padding:  EdgeInsets.only(right: index ==1?8:1),
      child: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left, color: dotscolor, size: 60,),
        onPressed: () {
          controller.previousPage();
        },
      ),
    );
  }
  else { return Container();

  }
}