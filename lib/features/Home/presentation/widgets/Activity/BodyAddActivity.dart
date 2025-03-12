
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/presentation/pages/CreateUpdateActivityPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Category/CategoryWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/FirstLineWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/LocationField.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/DateWidget.dart';

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
  final List<String> participants; // Adjust type as necessary
  final ActivityState activityState; // Adjust type as necessary

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
    required this.activityState, // Current activity state
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, vis) {
            return BlocConsumer<FormzBloc, FormzState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FirstLineWidget(
                        work: work,
                        context: context,
                        participants: participants,
                        id:id ,
                        // Pass the appropriate ID if needed
                        formKey: formKey,
                        namecontroller: nameController,
                        descriptionController: descriptionController,
                        prof: professeurName,
                        location: locationController,
                        points: pointsController,
                        price: priceController
                    ).animate(
                      effects: [
                      const FadeEffect(
                        duration: Duration(milliseconds: 500),

                      )
                      ],
                    ),
                    AddWidgetComponents.showImagePicker(
                        vis.selectedActivity, mediaQuery).animate(
                    effects: [
                    const FadeEffect(
                    duration: Duration(milliseconds: 500),

                    )
                    ],
                    ),
                    NameAndLeaders(namecontroller: nameController,
                        ProfesseurName: professeurName,
                        vis: vis).animate(
                effects: [
                const FadeEffect(
                duration: Duration(milliseconds: 200),

                )
                ],
                ),
                    const TimesWidget().animate(
                effects: [
                VisibilityEffect(
                duration: Duration(milliseconds: 200),

                )
                ],
                ),
                    LocationVisibility(LocationController: locationController)
                    .animate(
                effects: [
                const FadeEffect(
                duration: Duration(milliseconds: 500),

                )
                ],
                ),
                    AddWidgetComponents.showDetails(
                        mediaQuery,
                        vis.selectedActivity,
                        state.registrationTimeInput.value ??
                            DateTime.now().add(const Duration(days: 1)),
                        context,
                        priceController
                    ).animate(
                effects: [
                const FadeEffect(
                duration: Duration(milliseconds: 500),

                )
                ],
                ),
                    TextfieldNormal(
                        context, "Points", "Points here".tr(context),
                        pointsController, (p0) => null).animate(
                effects: [
                const FadeEffect(
                duration: Duration(milliseconds: 500),

                )
                ],
                ),
                    TextfieldDescription(
                        context,
                        "Description",
                        "Description Here".tr(context),
                        descriptionController,
                            (value) {
                          context.read<FormzBloc>().add(
                              DescriptionChanged(description: value));
                        }
                    ).animate(
                    effects: [
                    const FadeEffect(
                    duration: Duration(milliseconds: 500),

                )
                ],
                ),
                    PrivacyWidget().animate(
                effects: [
                const FadeEffect(
                duration: Duration(milliseconds: 500),

                )
                ],
                ),
                    CategoryWidget(vis: vis).animate(
                      effects: [
                        const FadeEffect(
                          duration: Duration(milliseconds: 500),

                        )
                      ],
                    ),
                  ],
                );
              },
              listener: (BuildContext context, FormzState state) {
                if (state.Error.isNotEmpty) {
                  SnackBarMessage.showErrorSnackBar(
                      message: state.Error, context: context);
                  Future.delayed(
                      const Duration(seconds: 3),
                          () =>
                          context.read<FormzBloc>().add(const ThrowError(error: ""))
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
