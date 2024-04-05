import 'dart:convert';

import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/data/models/Member/AuthModel.dart';

class MemberSectionWidget extends StatefulWidget {
  final Member member;

  const MemberSectionWidget({Key? key, required this.member}) : super(key: key);

  @override
  State<MemberSectionWidget> createState() => _MemberSectionWidgetState();
}

class _MemberSectionWidgetState extends State<MemberSectionWidget> {
  @override
  void initState() {

    image();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
      builder: (context, state) {
        return
          Column(
            children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  children: [
                    BackButton(color: textColorBlack, onPressed: () {
                      context.read<PageIndexBloc>().add(SetIndexEvent(index: 0));
                    },),
                    Text('Member Section', style: PoppinsSemiBold(
                        18, textColorBlack, TextDecoration.none),),

                  ]  ),
              IconButton(
                onPressed: () async{

                  context.go('/settings?user=${jsonEncode(MemberModel.fromEntity(widget.member).toJson())}');
                },
                icon: Icon(Icons.settings, color: textColorBlack,),
              ),


            ],
          ),

        SizedBox(height: 20,),






          Column(
          children: [








            ProfileComponents.hh(widget.member),
            ProfileComponents.ExpandedContainer(context, ProfileComponents.isPoints(state.state), ProfileComponents.BuildPointsWidget(widget.member), 'Points', StatesBool.Points,mediaQuery)
       ,      ProfileComponents.ExpandedContainer(context, ProfileComponents.iActivities(state.state),ProfileComponents.ActivitiesComponent(widget.member.Activities , mediaQuery), 'Activities', StatesBool.Activities,mediaQuery),
            ProfileComponents.ExpandedContainer(context, ProfileComponents.iTeams(state.state), ProfileComponents.TeamsComponent(widget.member,mediaQuery), 'Teams', StatesBool.Teams,mediaQuery),
          ],
        )]);
      },
    );
  }
  void image()async {
    if(widget.member.Images != null && widget.member.Images.isNotEmpty){
      final image=await convertBase64ToXFile(widget.member.Images[0]['url']!);
      if (!mounted) return;
      if    (image!=null){

        context.read<TaskVisibleBloc>().add(ChangeImageEvent(image.path,));
      }
      else{
        context.read<TaskVisibleBloc>().add(ChangeImageEvent("assets/images/jci.png",));
      }

    }
    else{
      context.read<TaskVisibleBloc>().add(ChangeImageEvent("assets/images/jci.png",));

    }
  }
}
