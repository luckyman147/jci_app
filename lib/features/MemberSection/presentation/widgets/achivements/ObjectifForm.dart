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
import 'CibleSelector.dart';

class ObjectifForm extends StatefulWidget {


  const ObjectifForm({super.key,});
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
    return  BlocListener<ObjectifBloc, ObjectifState>(
  listener: (context, state) {
    if (state.status == ObjectifStatus.Created) {


          // Reset the form and clear all inputs
          _formKey.currentState!.reset();

          // Reset dropdown selections if needed
        

          //close the form
          Navigator.pop(context);
    }
    else if (state.status==ObjectifStatus.FailureCreation){
     // SnackBarMessage.showErrorSnackBar(message: "Objectif Creation Failed", context: context);
    }

    // TODO: implement listener
  },
  child: Column(


      children: [




        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: BlocBuilder<ObjectifFormCubit, ObjectifFormState>(
  builder: (context, state) {
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

                    }, validator: 'Select a group',),

Visibility(
    visible: state.groupObjectif!=null,

    child:  DropDown<ObjectifActionType?>(
      selected:     state.objectifActionType,
      options: state.groupObjectif!=null?   ObjectiveTypesForm.getActionTypesByGroup(state.groupObjectif!):[],
      onChanged: (value) => context.read<ObjectifFormCubit>().setObjectifActionType(value!), validator: 'Select The action',),
),

                Visibility(
                    visible: state.objectifActionType!=null && (state.objectifActionType) !=ObjectifActionType.Discover,

                    child: FormNormal(keyboard: TextInputType.number, controller: _scoreController, label: "Objectif Target",validatorMessage:  "Enter the objectif Score ")),

                Visibility(
                  visible: state.groupObjectif!=null,

                  child:  DropDown<FeaturesType?>(
                    selected:     state.feature,
                    options:state.groupObjectif!=null?  ObjectiveTypesForm.getFeaturesByGroup(state.groupObjectif!):[],
                    onChanged: (value) => context.read<ObjectifFormCubit>().setFeature(value!), validator: 'Select Features',),
                ),
                 Visibility(
                  visible: state.groupObjectif!=null,

                  child: CibleSelector(cibleOptions: state.groupObjectif!=null? ObjectiveTypesForm. getCiblesByGroup(state.groupObjectif!):[],)
                ),
                Visibility(
                  visible: state.groupObjectif!=null && !ObjectiveTypesForm.isPrivacyNullForGroup(state.groupObjectif!),

                  child:  DropDown<PrivacyType?>(
                    selected:     state.privacy,
                    options: PrivacyType.values,
                    onChanged: (value) => context.read<ObjectifFormCubit>().setPrivacy(value!), validator: 'Select privacy',),
                ),   Visibility(
                  visible: state.groupObjectif!=null && !ObjectiveTypesForm.isPrivacyNullForGroup(state.groupObjectif!),

                  child:  DropDown<ObjectifDifficulty?>(
                    selected:     state.difficulty,
                    options: ObjectifDifficulty.values,
                    onChanged: (value) => context.read<ObjectifFormCubit>().setDifficulty(value!), validator: 'Select Difficulty',),
                ),
                FormNormal(keyboard: TextInputType.number, controller: _PointsController,label:  "Points",validatorMessage: "Enter a Points to win"),




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
    ),
);
  }

  BlocSelector<ObjectifBloc, ObjectifState, bool> buildButtonSaveObjectiveSelector(ObjectifFormState Ostate) {
    return BlocSelector<ObjectifBloc, ObjectifState, bool>(
      selector: (state) {
        return state.status==ObjectifStatus.CreationLoading;
      },
      builder: (context, state) {
        return
          state? LoadingWidget():

          Center(child: SizedBox(
              width: double.infinity,
              child: ButtonsMemberComponents.   SaveChangesButton(()=>_saveObjectif(Ostate), context)));
      },
    );
  }


  void _saveObjectif(ObjectifFormState state) {
    if (_formKey.currentState!.validate()) {
      Objectif newObjectif = Objectif(
        id: "",

        difficulty:state.difficulty ,
        points: int.tryParse(_PointsController.text) ?? 0, groupObjectif: state.groupObjectif!,
        objectifActionType: state.objectifActionType!,
        privacy: state.privacy,
        cible: state.cibles, feature: state.feature!, target: int.tryParse(_scoreController.text) ?? 0,
      );

      context.read<ObjectifBloc>().add(CreateObjectifEvent(objectif: newObjectif));


    }
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