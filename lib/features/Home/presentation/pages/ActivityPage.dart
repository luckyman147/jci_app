import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/ActivityDetailsComponents.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/EventListWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';

import '../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import '../widgets/ActivityImplWidgets.dart';
import '../widgets/Functions.dart';
import 'CreateUpdateActivityPage.dart';



class ActivityPage extends StatefulWidget {
  final activity Activity;
  const ActivityPage({Key? key, required this.Activity}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {


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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        onPressed: (){
                          context.read<PageIndexBloc>().add (SetIndexEvent(index:0));
            
            
                        }
            
                      ),
                      MyDropdownButton(),
                      BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
              builder: (context, ste) {
                return Row(
                        children: [
                          ActivityDetailsComponent
                          .buildAddButtonWi(context,widget.Activity.name,actionD.Add.name),
                          const SearchButton(
                            color: PrimaryColor, IconColor: textColorBlack,),
                        ],
                      );
              },
            ),
                    ],
                  ),
            
                  Expanded(
            
            
                      child: buildAllBody(context,state.selectedActivity))
                ]),
          ),
        );
      },
    );
  }


}
