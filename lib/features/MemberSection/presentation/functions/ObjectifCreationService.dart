import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../domain/entity/Objectif.dart';
import '../bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import '../bloc/objectifs/objectif_bloc.dart';
import 'FunctionObjectif.dart';

class ObjectifUIService {
  final TextEditingController pointsController;
  final TextEditingController scoreController;
  final GlobalKey<FormState> formKey;
  final BuildContext context;

  ObjectifUIService({
    required this.pointsController,
    required this.scoreController,
    required this.formKey,
    required this.context,
  });

  void saveObjectif(ObjectifFormState state, ObjectifState objState, ObjectiveEvent event, Objectif? editObj) {
    // Validate form inputs
    final validationResults = ObjectifFunctions.validateForm(state, pointsController, scoreController);
    final bool isValid = validationResults.values.every((valid) => valid);

    if (!isValid) {
      _showValidationError();
      return;
    }

    // Disable the form while processing
    context.read<ObjectifFormCubit>().setBool(false);

    // Create a new Objectif
    final newObjectif = _buildObjectif(state, editObj, event);

    if (event == ObjectiveEvent.Create) {
      _createObjectif(newObjectif);
    } else {
      _editObjectif(newObjectif, objState, editObj!);
    }


  }

  /// Builds an Objectif instance from form inputs
  Objectif _buildObjectif(ObjectifFormState state, Objectif? editObj, ObjectiveEvent event) {
    return Objectif(
      id: editObj != null && event == ObjectiveEvent.Edit ? editObj.id : "",
      difficulty: state.difficulty,
      points: int.tryParse(pointsController.text) ?? 0,
      groupObjectif: state.groupObjectif!,
      objectifActionType: state.objectifActionType!,
      privacy: state.privacy,
      cible: state.cibles,
      feature: state.feature!,
      target: int.tryParse(scoreController.text) ?? 0,
    );
  }

  /// Handles creating a new Objectif
  void _createObjectif(Objectif objectif) {
    context.read<ObjectifBloc>().add(CreateObjectifEvent(objectif: objectif));
  }

  /// Handles editing an existing Objectif
  void _editObjectif(Objectif objectif, ObjectifState objState, Objectif editObj) {
    final userObjectif = ObjectifFunctions.getUserObjectif(editObj, objState.objectifs);

    if (objectif.target! > userObjectif.currentProgress) {
      context.read<ObjectifBloc>().add(EditObjectifEvent(objectif: objectif));
    } else {
      _showError("Objectif Target must be bigger than Progress");
      scoreController.clear();
    }
  }

  /// Shows a validation error message
  void _showValidationError() {
    context.read<ObjectifFormCubit>().setBool(true);
    _showError("Please fill the form correctly");
  }

  /// Displays an error message using SnackBar
  void _showError(String message) {
    SnackBarMessage.showErrorSnackBar(message: message, context: context);
  }
}
