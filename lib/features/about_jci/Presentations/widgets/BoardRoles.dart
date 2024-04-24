import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';

import '../../../../core/app_theme.dart';
import '../../Domain/entities/BoardRole.dart';
import '../bloc/ActionJci/action_jci_cubit.dart';
import '../bloc/Board/YearsBloc/years_bloc.dart';
import 'BoardComponents.dart';

class BoardRolesDropButton extends StatefulWidget {
  final List<BoardRole> items;

  const BoardRolesDropButton({super.key, required this.items});

  @override
  _BoardRolesDropButtonState createState() => _BoardRolesDropButtonState();
}

class _BoardRolesDropButtonState extends State<BoardRolesDropButton> {


  @override
  void initState() {
    super.initState();
    // Set the initial selected role
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/3, // Adjust the height as per your requirement
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: BlocBuilder<YearsBloc, YearsState>(
        builder: (context, state) {
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Display one item in a row
              childAspectRatio: 1.5, // Aspect ratio of the grid items
            ),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final role = widget.items[index];
              if (index == 0) {

                return   InkWell(

                  onTap: () {
                    context.read<ActionJciCubit>().changePageNum(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      radius: Radius.circular(10),
                      dashPattern:const  [21,17,21,17],
                      color: textColor,
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      child: Center(
                        child:  Icon(Icons.add,color: textColor,size: 50,),
                      ),
                    ),
                  ),
                );
              }

              return Body(context, role, state);
            },
          );
        },
      ),
    );
  }

  Padding Body(BuildContext context, BoardRole role, YearsState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
        JCIFunctions.  ChangeRoleFunction(state, role, context);
          ;

        },
        child: BoardComponents.CardComponet(JCIFunctions. isSelected(state, role) , role, context,role.name),
      ),
    );
  }





}
