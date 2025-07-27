import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Category/CategoryWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/FirstLineWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/LocationField.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/stuff/DateWidget.dart';
import '../../../../../core/widgets/CommonTextField.dart';
import '../../../Activity_Global.dart';
import '../Fields/LedaersWidget.dart';

class BodyWidget extends StatelessWidget {
  final String id;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController professeurName;
  final TextEditingController locationController;
  final TextEditingController pointsController;
  final TextEditingController priceController;
  final String work;
  final List<String> participants;
  final ActivityState activityState;

  const BodyWidget({
    Key? key,
    required this.id,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.professeurName,
    required this.locationController,
    required this.pointsController,
    required this.priceController,
    required this.work,
    required this.participants,
    required this.activityState,
  }) : super(key: key);

  Widget _animated(Widget child, {int delayMs = 0}) {
    return child.animate().fade(duration: 500.ms, delay: delayMs.ms);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, vis) {
            return BlocConsumer<FormzBloc, FormzState>(
              listener: (context, state) {
                if (state.Error.isNotEmpty) {
                  SnackBarMessage.showErrorSnackBar(
                      message: state.Error, context: context);
                  Future.delayed(
                    const Duration(seconds: 3),
                        () => context
                        .read<FormzBloc>()
                        .add(const ThrowError(error: "")),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    _animated(
                      FirstLineWidget(
                        work: work,
                        context: context,
                        participants: participants,
                        id: id,
                        formKey: formKey,
                        namecontroller: nameController,
                        descriptionController: descriptionController,
                        prof: professeurName,
                        location: locationController,
                        points: pointsController,
                        price: priceController,
                      ),
                    ),
                    _animated(AddWidgetComponents.showImagePicker(
                      vis.selectedActivity,
                      mediaQuery,
                    )),
                    _animated(NameAndLeaders(
                      namecontroller: nameController,
                      ProfesseurName: professeurName,
                      vis: vis,
                    )),
                    _animated(const TimesWidget()),
                    _animated(LocationVisibility(
                        LocationController: locationController)),
                    _animated(AddWidgetComponents.showDetails(
                      mediaQuery,
                      vis.selectedActivity,
                      state.registrationTimeInput.value ??
                          DateTime.now().add(const Duration(days: 1)),
                      context,
                      priceController,
                    )),
                    _animated(TextfieldNormal(
                      name: "Points",
                      hintText: "Points here".tr(context),
                      controller: pointsController,
                      onChanged: (_) {},
                    )),
                    _animated(TextfieldDescription(
                      name: "Description",
                      hintText: "Description Here".tr(context),
                      controller: descriptionController,
                      onChanged: (value) {
                        context
                            .read<FormzBloc>()
                            .add(DescriptionChanged(description: value));
                      },
                    )),
                    _animated( PrivacyWidget()),
                    _animated(CategoryWidget(vis: vis)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
