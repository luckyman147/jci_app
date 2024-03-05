

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';


import 'package:jci_app/features/auth/presentation/widgets/Text.dart';


import '../../../../core/app_theme.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

import '../bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';


import 'Compoenents.dart';

class HomeWidget extends StatefulWidget {
final activity Activity;
  const HomeWidget({Key? key, required this.Activity}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: widget.Activity));



    super.initState();
  }



  Future<MemberModel?> _loadMemberModel() async {
    return await Store.getModel();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  BlocConsumer<ActivityCubit, ActivityState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return

            RefreshIndicator(
              onRefresh: () {

  context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: state.selectedActivity));
  context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: state.selectedActivity));

  return Future.value(true);





          },
          child:
            SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:mediaQuery.size.height / 33, horizontal: mediaQuery.size.width / 20),
              child: BlocBuilder<AuthBloc, AuthState>(
  builder: (context, ste) {
    return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder <MemberModel?>(
                            future:  _loadMemberModel(),
                            builder: (context,snap)  {
                              print("Data: ${snap.data}");
                              if (snap.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snap.hasError) {
                                print("Error: ${snap.error}");

                              }
                               if (snap.hasData && snap.data!=null && snap.data!.firstName!.isNotEmpty!=null){ return  Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Hello, ", style: PoppinsRegular(
                                      mediaQuery.devicePixelRatio*10, Colors.black),),
                                  Text(snap.data!.firstName, style: PoppinsSemiBold(
                                      mediaQuery.devicePixelRatio*11, Colors.black,
                                      TextDecoration.none),),

                                ],


                              );}
                               else{
                                 debugPrint("dddddd${snap.hasData}");
                               return Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Text("Hello, ", style: PoppinsRegular(
                                       mediaQuery.devicePixelRatio*10, Colors.black),),
                                   Text("There", style: PoppinsSemiBold(
                                       mediaQuery.devicePixelRatio*11, Colors.black,
                                       TextDecoration.none),),

                                 ],


                               );
                            }}
                          ),
                          Row(
                            children: [
                              CalendarButton(color: BackWidgetColor, IconColor: textColorBlack,),
                              const SearchButton(color: BackWidgetColor, IconColor: textColorBlack,),
                            ],
                          ),

                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33),
                        child: MyActivityButtons(),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Upcoming ${state.selectedActivity.name}", style: PoppinBold(
                                mediaQuery.size.width / 17, Colors.black,
                                TextDecoration.none),),
                            InkWell(
                              onTap: (){
                                context.read<PageIndexBloc>().add (SetIndexEvent(index: 1));



                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: LinkedText(text: "See more", size: mediaQuery.size.width/23),
                              ),
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
                              child:

                                   buildBody(context,state.selectedActivity)


                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(" This Weekend", style: PoppinBold(
                                mediaQuery.size.width / 15, Colors.black,
                                TextDecoration.none),),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33, horizontal: 6),

                            child: SizedBox(
                              height: mediaQuery.size.height * 0.4, // adjust the height as needed
                              child: buildWeekBody(context,state.selectedActivity),
                            ),
                          ),
                        ],
                      )



                    ]

                );
  },
),
              ),
            ),
          ));
        },
      );

  }
}
