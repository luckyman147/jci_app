import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';

import '../../../../core/app_theme.dart';
import '../../../MemberSection/presentation/widgets/ProfileComponents.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../Domain/entities/President.dart';
import '../bloc/Board/YearsBloc/years_bloc.dart';
import '../bloc/presidents_bloc.dart';
import 'Fubnctions.dart';

class PresidentsComponents{
  static Widget AlertAddYearPresidents(List<String> yearsList) {
    return BlocBuilder<ActionJciCubit, ActionJciState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Add Board ', style: PoppinsRegular(16, textColorBlack)),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: PresidentsGridBuilder(yearsList, state),
          ),
          actions: actionsBoard(context, state),
        );
      },
    );
  }
  static GridView PresidentsGridBuilder(List<String> yearsList, ActionJciState state) {
    return GridView.builder(
      gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: yearsList.length, // 5 years with 3 rows per year
      itemBuilder: (context, index) {

        return InkWell(

          onTap: () {

              context.read<ActionJciCubit>().changeCloneYear(yearsList[index]);

            // Close dialog and pass selected year
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: textColor),
              borderRadius: BorderRadius.circular(10),
              color: state.cloneYear==yearsList[index]?PrimaryColor:Colors.transparent,
            ),
            child: Center(
              child: Text(
                '${yearsList[index]}',
                style: PoppinsRegular(16, state.cloneYear==yearsList[index]?textColorWhite:textColorBlack, ),
              ),
            ),
          ),
        );
      },
    );
  }
  static List<Widget> actionsBoard(BuildContext context, ActionJciState state) {
    return [
      ElevatedButton(

        onPressed: () {
          Navigator.pop(context); // Close dialog
        },
        child: Text(
          'Cancel',
          style: PoppinsSemiBold(16, textColor, TextDecoration.none),
        ),
      ), ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor),
        ),
        onPressed: () {
          context.read<ActionJciCubit>().changeYear(state.cloneYear);
          //context.read<YearsBloc>().add(ChangeCloneYear(year:""));
          Navigator.pop(context); // Close dialog

          // Close dialog
        },
        child: Text(
          'Submit',
          style: PoppinsSemiBold(16, textColorWhite, TextDecoration.none),
        ),
      ),
    ];
  }
  static AlertDialog UpodatePOhotoWid(TaskVisibleState state, BuildContext context, President president) {
    return AlertDialog(

      title: Text('Update President Image',style: PoppinsRegular(16, textColorBlack,),),
      content:            SizedBox(
          height: 200,
          child: Center(
              child:
              ProfileComponents.imagezChanged(state.image,MediaQuery.of(context),context))
      ),

      actions: <Widget>[


        TextButton(
          onPressed: () {
            // Perform action when the second button is pressed
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel',style: PoppinsRegular(16, textColor,),),
        ),  TextButton(
          onPressed: () {
            final President newPresident = President(name: president.name, CoverImage: state.image, year: president.year, id: president.id);
            context.read<PresidentsBloc>().add(UpdateImagePresident(newPresident));
            // Perform action when the second button is pressed
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Update',style: PoppinsRegular(16, PrimaryColor,),),
        ),
      ],
    );
  }


}