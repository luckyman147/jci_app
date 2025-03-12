import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../../core/app_theme.dart';
import '../../bloc/PageIndex/page_index_bloc.dart';
import '../Functions/AddUpdateFunctions.dart';
import '../buttons/SaveButton.dart';
import '../components/Compoenents.dart';

class FirstLineWidget extends StatelessWidget {
  final String work;

  final List<String> participants;
  final GlobalKey<FormState> formKey;
  final String id;
  final TextEditingController namecontroller;
  final TextEditingController descriptionController;
  final BuildContext context;

  final TextEditingController prof;
  final TextEditingController price;
  final TextEditingController location;
  final TextEditingController points;

  const FirstLineWidget({
    Key? key,
    required this.work,

    required this.participants,
    required this.formKey,
    required this.id,
    required this.namecontroller,
    required this.descriptionController,
    required this.context,

    required this.prof,
    required this.price,
    required this.location,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
              onPressed: () {
                AddUpdateFunctions.PopFunctions(work, context, id);
              },
            ),
            Row(
              children: [
                work != "edit"
                    ? Text("Add".tr(context),
                    style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none))
                    : Text("Edit".tr(context), style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none)),
                work != "edit"
                    ? const Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: MyDropdownButton(),
                )
                    : const SizedBox(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SaveButton(
                formKey: formKey,
                namecontroller: namecontroller,
                descriptionController: descriptionController,

                ProfesseurName: prof,
                LocationController: location,
                Points: points,
                Price: price,
                action: work,
                id: id,
                part: participants,
              ),
            ),
          ],
        );
      },
    );
  }
}
