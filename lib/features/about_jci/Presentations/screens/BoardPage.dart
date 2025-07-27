import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/BoardImpl.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';

import '../../../../core/app_theme.dart';

import '../bloc/Board/BoardBloc/boord_bloc.dart';
import '../bloc/presidents_bloc.dart';

import 'PastPresidentsPage.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  @override
  void initState() {

    context.read<YearsBloc>().add(GerBoardYearsEvent());
    pageController = PageController(initialPage: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        surfaceTintColor: textColorWhite,
        backgroundColor: textColorWhite,
        title: BlocBuilder<YearsBloc, YearsState>(
          builder: (context, state) {
            return BlocListener<BoordBloc, BoordState>(

              listener: (context, ste) {
       JCIFunctions.ListenerBoard(context, state, ste);

                // TODO: implement listener}
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Board'.tr(context), style: PoppinsSemiBold(
                      18, textColorBlack, TextDecoration.none),),
                  TextButton(child: Row(
                    children: [
                      Text('Last Presidents'.tr(context),style:PoppinsSemiBold(16,PrimaryColor, TextDecoration.underline)),
                      const Icon(Icons.arrow_forward_ios_rounded,color: PrimaryColor,)
                    ],
                  ),onPressed: (){
                    context.read<PresidentsBloc>().add(GetAllPresidentsEvent());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const PresidentsPage()));

                  },)

                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(

        child: Column(
          children: [
            Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: BoardImpl.GetYearsComponent(context, scrollController),
            ),
            BoardImpl.GetBoardComponent(pageController)
          ],

        ),
      ),),
    );
  }
}
