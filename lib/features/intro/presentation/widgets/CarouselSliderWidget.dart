import 'package:carousel_slider/carousel_slider.dart' as c;
import '../widgets.global.dart';


class CarouselSliderWidget extends StatelessWidget {
  final IndexState state;
  final List<dynamic> jsondata;
  final MediaQueryData mediaQuery;

  const CarouselSliderWidget({
    Key? key,
    required this.state,
    required this.jsondata,
    required this.mediaQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return c.CarouselSlider.builder(
      options: c.CarouselOptions(
        height: 500,
        enlargeFactor: 1,
        autoPlayInterval: const Duration(seconds: 5),
        viewportFraction: 1,
        initialPage: state.props[0] as int,
        enableInfiniteScroll: false,
        autoPlay: true,
        enlargeStrategy:c. CenterPageEnlargeStrategy.height,
        onPageChanged: (index, reason) {
          context.read<IndexBloc>().add(SetIndexEvent(index: index));
        },
      ),
      itemCount: jsondata.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final urlImage = jsondata[index]['image'];
        final titre = jsondata[index]['titre'];
        final description = jsondata[index]['description'];

        return _buildDescription(urlImage, titre, description, index, mediaQuery.size.width / 2,context);
      },
    );
  }


  Widget _buildDescription(String image, String titre, String description, int index, double size,BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
              _buildIndicator(0, 3);
            }
          },
          builder: (context, state) {
            if (state is IndexInitial) {
              return _buildIndicator(0, 3);
            } else if (state is IndexLoaded) {
              return _buildIndicator(state.currentIndex, 3);
            } else if (state is ResetState) {
              return _buildIndicator(state.index, 3);
            } else {
              return _buildIndicator(0, 3);
            }
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("titre_$index".tr(context), style: PoppinsSemiBold(mediaQuery.size.width / 11, Colors.black, TextDecoration.none)),
            Padding(
              padding: const EdgeInsets.only(left: 65, right: 30),
              child: Text("description_$index".tr(context), style: PoppinsNorml(mediaQuery.size.width / 27.5, ColorsApp.textColorBlack), textAlign: TextAlign.start),
            ),
          ],
        )
      ],
    );
  }
}


Widget _buildIndicator(int index, int len) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 11, top: 30),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: index,
        count: len,
        effect: const WormEffect(
          dotColor:ColorsApp. dotscolor,
          activeDotColor:ColorsApp. textColorBlack,
          type: WormType.thin,
        ),
      ),
    ),
  );
}
