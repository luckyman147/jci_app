

import 'package:carousel_slider/carousel_slider.dart' as c;
import 'package:jci_app/features/intro/presentation/widgets/CarouselSliderWidget.dart';

import '../../../../core/strings/Images.string.dart';
import '../widgets.global.dart';


class CarouselWidget extends StatefulWidget {
  const CarouselWidget({Key? key}) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
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
    final mediaQuery = MediaQuery.of(context);

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
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BlocBuilder<IndexBloc, IndexState>(
                      builder: (context, state) {
                        return CarouselSliderWidget(state: state, mediaQuery: mediaQuery, jsondata: jsondata);
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return const CircularProgressIndicator(); // Loading indicator
        }
      },
    );
  }


}

Future<List<dynamic>> _loadJsonData(BuildContext context) async {
  String jsonString = await DefaultAssetBundle.of(context).loadString(images.cartousel);
  List<dynamic> jsonData = json.decode(jsonString);
  return jsonData;
}

