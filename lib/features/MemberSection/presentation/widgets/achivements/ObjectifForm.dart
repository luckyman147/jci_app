import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/strings/objectifsIcon.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../domain/entity/ActionDetails.dart';
import '../../../domain/entity/Objectif.dart';

import '../../bloc/objectifs/objectif_bloc.dart';
import '../../components/ObjectifField.dart';
import '../../components/buttonsComponents.dart';
import '../../constants/ObjectifTypesForm.dart';
import '../../functions/FunctionObjectif.dart';
import '../../functions/ObjectifCreationService.dart';
import '../../components/CibleSelector.dart';

class ObjectifForm extends StatefulWidget {

final ObjectiveEvent event;
final Objectif? editObj;
  const ObjectifForm({super.key, required this.event, this.editObj, });
  @override
  _ObjectifFormState createState() => _ObjectifFormState();
}

class _ObjectifFormState extends State<ObjectifForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers


  final TextEditingController _PointsController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return  Column(


        children: [




          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: BlocBuilder<ObjectifFormCubit, ObjectifFormState>(
    builder: (context, state) {
      Map<String, bool> validationResults =ObjectifFunctions. validateForm(state, _PointsController, _scoreController);

      return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID

                  DropDown<GroupObjectif?>(
                      selected:     state.groupObjectif,
                      options: GroupObjectif.values,
                      onChanged: (value) {
                        context.read<ObjectifFormCubit>().reset();
                        _PointsController.clear();
                        _scoreController.clear();
                        context.read<ObjectifFormCubit>().setGroupObjectif(value!);

                      }, validator: 'Select a group', isError: state.isClicked && !validationResults['groupObjectif']! ,),

    Visibility(
      visible: state.groupObjectif!=null,

      child:  DropDown<ObjectifActionType?>(
        selected:     state.objectifActionType,
        options: state.groupObjectif!=null?   ObjectiveTypesForm.getActionTypesByGroup(state.groupObjectif!):[],
        onChanged: (value) => context.read<ObjectifFormCubit>().setObjectifActionType(value!), validator: 'Select the action', isError: state.isClicked && !validationResults['objectifActionType']!,),
    ),
                  Visibility(
                    visible: state.groupObjectif!=null && state.objectifActionType!=null,

                    child:  DropDown<FeaturesType?>(
                      selected:     state.feature,
                      options:state.groupObjectif!=null && state.objectifActionType!=null?  ObjectiveTypesForm.getFeaturesByGroup(state.groupObjectif!,state.objectifActionType!):[],
                      onChanged: (value) => context.read<ObjectifFormCubit>().setFeature(value!), validator: 'Select Features', isError: state.isClicked &&!validationResults['feature']! ,),
                  ),
                  Visibility(
                      visible: state.objectifActionType!=null && (state.objectifActionType) !=ObjectifActionType.Discover,

                      child: FormNormal(keyboard: TextInputType.number, controller: _scoreController, label: "Objectif Target",validatorMessage:  "Enter the objectif Score ", isError: state.isClicked && !validationResults['objectifTarget']!,)),


                   Visibility(
                    visible: state.groupObjectif!=null,

                    child: CibleSelector(cibleOptions: state.groupObjectif!=null? ObjectiveTypesForm. getCiblesByGroup(state.groupObjectif!):[],
                      isError: state.isClicked &&!validationResults['cibles']!,)
                  ),
                  Visibility(
                    visible: state.groupObjectif!=null && !ObjectiveTypesForm.isPrivacyNullForGroup(state.groupObjectif!) && state.feature!=null&&  state.feature!=FeaturesType.Objectif,

                    child:  DropDown<PrivacyType?>(
                      selected:     state.privacy,
                      options: PrivacyType.values,
                      onChanged: (value) => context.read<ObjectifFormCubit>().setPrivacy(value!), validator: 'Select privacy', isError: state.isClicked && !validationResults['privacy']!,),
                  ),   Visibility(
                    visible: state.groupObjectif!=null && !ObjectiveTypesForm.isPrivacyNullForGroup(state.groupObjectif!),

                    child:  DropDown<ObjectifDifficulty?>(
                      selected:     state.difficulty,
                      options: ObjectifDifficulty.values,
                      onChanged: (value) => context.read<ObjectifFormCubit>().setDifficulty(value!), validator: 'Select Difficulty', isError: state.isClicked  && !validationResults['difficulty']!,),
                  ),
                  FormNormal(keyboard: TextInputType.number, controller: _PointsController,label:  "Points",validatorMessage: "Enter a Points to win", isError: state.isClicked && !validationResults['points']!,),




                  // Created By

                  // Score

                  SizedBox(
                      width: double.infinity,

                      child: buildButtonSaveObjectiveSelector(state)),



                  // Deadline Picker


                  const SizedBox(height: 20),

                  // Submit Button

                ],
              );
    },
    ),
            ),

          ),
        ],
      );
  }

 Widget buildButtonSaveObjectiveSelector(ObjectifFormState Ostate) {
    return BlocBuilder<ObjectifBloc, ObjectifState>(

      builder: (context, state) {

        return
          state.status==ObjectifStatus.CreationLoading?const  LoadingWidget():

          Align(
              alignment: Alignment.center,
              child: ButtonsMemberComponents.   SaveChangesButton(


                      (){

                final objectifService = ObjectifUIService(
                  pointsController: _PointsController,
                  scoreController: _scoreController,
                  formKey: _formKey,
                  context: context,
                );

                objectifService.saveObjectif(Ostate, state, widget.event, widget.editObj);


              }, context,MediaQuery.of(context).size.width/1.5,));
      },
    );
  }





  @override
  void initState() {
    if (widget.event==ObjectiveEvent.Edit && widget.editObj!=null){
      if (widget.editObj!.target!=null) {
        _scoreController.text=widget.editObj!.target.toString();
      }
      _PointsController.text=widget.editObj!.points.toString();
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // Reset the form and clear all inputs
   _PointsController.clear();
   _scoreController.clear();



    // TODO: implement dispose
    super.dispose();
  }
}