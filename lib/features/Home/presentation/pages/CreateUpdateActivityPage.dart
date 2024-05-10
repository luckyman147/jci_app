

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';


import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/MeetingStore.dart';
import 'package:jci_app/core/config/services/TrainingStore.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';


import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';



import 'package:jci_app/features/Home/presentation/widgets/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';


import 'package:jci_app/features/auth/domain/entities/Member.dart';


import '../../../../core/config/services/MemberStore.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../domain/entities/Activity.dart';
import '../../domain/entities/Event.dart';


import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../../domain/usercases/ActivityUseCases.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import '../widgets/AddUpdateFunctions.dart';
import '../widgets/Formz.dart';
import '../widgets/Functions.dart';
import '../widgets/MemberSelection.dart';



class CreateUpdateActivityPage extends StatefulWidget {
  final String id;
  final String work;
  final String activity;
  final List<String> part;
  const CreateUpdateActivityPage({Key? key, required this.id, required this.activity, required this.work, required this.part}) : super(key: key);

  @override
  State<CreateUpdateActivityPage> createState() =>
      _CreateUpdateActivityPageState();
}


class _CreateUpdateActivityPageState extends State<CreateUpdateActivityPage> {

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _LeaderController = TextEditingController();
  final TextEditingController _ProfesseurName = TextEditingController();
  final TextEditingController _LocationController = TextEditingController();
  final TextEditingController _Points = TextEditingController();
  final TextEditingController _price = TextEditingController();


@override
  void initState() {

  AddUpdateFunctions.check(widget.work,
      widget.activity, context, widget.id, _price,widget.part,
    _LocationController,_Points,_namecontroller,_descriptionController,_LeaderController,_ProfesseurName,mounted





  );
  context.read<MembersBloc>().add(GetAllMembersEvent(false));
    // TODO: implement initState
    super.initState();
  }

  //Form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);


    return Scaffold(

      body: SafeArea(
        child: BlocBuilder<AcivityFBloc, AcivityFState>(
  builder: (context, state) {

     return body(mediaQuery);

  },
),
      ),
    );
  }


  Widget body(mediaQuery)=>SingleChildScrollView(
    child: Form(
      key: _formKey,
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, vis) {
          return BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AddWidgetComponents.   firstLine(work: widget.work, context: context, mediaQuery: mediaQuery, part: widget.part, id: widget.id
                  
                  ,formKey: _formKey, namecontroller: _namecontroller, descriptionController: _descriptionController,
                    LeaderName: _LeaderController, prof: _ProfesseurName, location: _LocationController, points: _Points, price: _price        
                  ),
                  AddWidgetComponents.         showImagePicker(vis.selectedActivity, mediaQuery),
                  TextfieldNormal(context,
                      "${vis.selectedActivity.name.tr(context)} ${"Name".tr(context)}" ,"${"Name of".tr(context)}${vis.selectedActivity.name} ${"here".tr(context)}", _namecontroller,

                          (value){
                        context.read<FormzBloc>().add(ActivityNameChanged(activityName: value));
                      }
                  ),
                  AddWidgetComponents.      showLeader(vis.selectedActivity,mediaQuery,context,_ProfesseurName,_LeaderController),

                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: SizedBox(
                          width: mediaQuery.size.width,
                          child: BeginTimeWidget()

                      )),
                  AddWidgetComponents.    AddEndDateButton(mediaQuery,"Show End date".tr(context)),
                     EndDateWidget(LabelText: 'End Date'.tr(context), SheetTitle: "Date and Hour of End".tr(context), HintTextDate: 'End Date'.tr(context), HintTextTime: 'End Time'.tr(context),
                  ),
                  AddWidgetComponents.    showDetails(mediaQuery, vis.selectedActivity, state.registrationTimeInput.value??DateTime.now().add(Duration(days: 1)),context,_price,_LocationController),
                  TextfieldNormal(context,"Points", "Points here".tr(context), _Points, (p0) => null),

                  TextfieldDescription(context,
                      "Description", "Description Here".tr(context), _descriptionController,

                          (value){
                        context.read<FormzBloc>().add(DescriptionChanged(description: value));
                      }
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          "Category".tr(context),
                          style: PoppinsRegular(18, textColorBlack),
                        ),
                      ),
                      SizedBox(
                          width: mediaQuery.size.width * 1.2,
                          child: MyCategoryButtons(act: vis.selectedActivity,)),
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    ),
  );


  


}