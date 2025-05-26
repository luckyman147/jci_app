import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/ActivityDetailsComponents.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/Compoenents.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';

import '../../../auth/AuthWidgetGlobal.dart';

import '../bloc/PageIndex/page_index_bloc.dart';
import '../widgets/Functions/Listeners.dart';




class ActivityPage extends StatefulWidget {
  final activity Activity;
  const ActivityPage({Key? key, required this.Activity}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {

    context.read<PermissionsBloc>().add(LoadPermissionOfMasterEvent(featuresId: [Constants.MANAGE_EVENTS,Constants.MANAGE_MEETINGS,Constants.MANAGE_TRAININGS]));

      context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: widget.Activity));
      context.read<AddDeleteUpdateBloc>().add(CheckPermissions(act: widget.Activity));


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: MultiBlocListener(
  listeners: [
    BlocListener<AcivityFBloc, AcivityFState>(
  listener: (context, state) {
    Listeners.    ListentoJoinButton(state, context,widget.Activity.name);

    // TODO: implement listener
  },
),

  ],
  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: !state.isSearching,
                        child: BackButton(
                          onPressed: (){
                            context.read<PageIndexBloc>().add (SetIndexEvent(index:0));


                          }

                        ),
                      ),
                      state.isSearching?MySearchBar(context,widget.Activity):
                      const MyDropdownButton(),

                      Visibility(
                        visible:!state.isSearching,
                        child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
                                      builder: (context, ste) {
                                        return Row(
                          children: [

                            AsyncComponents.buildFutureBuilder( ActivityDetailsComponent
                                .buildAddButtonWi(context,widget.Activity.name,actionType.Add.name),
                                PermissionType.canCreate,
                                widget.Activity==activity.Events?
                                Constants.MANAGE_EVENTS
                            :   widget.Activity==activity.Trainings?
                                Constants.MANAGE_TRAININGS
                                    :Constants.MANAGE_MEETINGS
                            ),

                             SearchButton(
                              color: PrimaryColor, IconColor: textColorBlack,onPressed: (){
                                context.read<ActivityCubit>().search(true);
                             },),
                          ],
                        );
                                      },
                                    ),
                      ),
                    ],
                  ),

                  Expanded(


                      child: buildAllBody(context,state.selectedActivity))
                ]),
),
          ),
        );
      },
    );
  }



}
