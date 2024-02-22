

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Event/events_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Text.dart';

import '../../../../core/app_theme.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/Event/EventsOfTheweekend/evebnts_of_thewwekend_bloc.dart';
import 'Compoenents.dart';

class HomeWidget extends StatefulWidget {

  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    context.read<EventsBloc>().add(GetEventsOfmonth());
    context.read<EvebntsOfThewwekendBloc>().add(GetEventsOfweek());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return RefreshIndicator(
      onRefresh: () {

        context.read<EventsBloc>().add(GetEventsOfmonth());
        context.read<EvebntsOfThewwekendBloc>().add(GetEventsOfweek());

        return Future.value(true);
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Hello ", style: PoppinsRegular(
                                  mediaQuery.size.width / 15, Colors.black),),
                              Text("There ", style: PoppinsSemiBold(
                                  mediaQuery.size.width / 14, Colors.black,
                                  TextDecoration.none),),

                            ],


                          ),
                          const SearchButton(),

                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33),
                        child: MyDropdownButton(),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Upcoming Events", style: PoppinBold(
                                mediaQuery.size.width / 19, Colors.black,
                                TextDecoration.none),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: LinkedText(text: "See more", size: mediaQuery.size.width/23),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(

                            padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33 , horizontal: 6),
                            child: SizedBox(
                              height: mediaQuery.size.height * 0.4, // adjust the height as needed
                              child: buildBody(context),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(" This Weekend", style: PoppinBold(
                                mediaQuery.size.width / 19, Colors.black,
                                TextDecoration.none),),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33, horizontal: 6),

                            child: SizedBox(
                              height: mediaQuery.size.height * 0.4, // adjust the height as needed
                              child: buildWeekBody(context),
                            ),
                          ),
                        ],
                      )



                    ]

                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
