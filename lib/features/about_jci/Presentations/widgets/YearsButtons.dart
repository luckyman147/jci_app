import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';

import '../../../MemberSection/presentation/widgets/ProfileComponents.dart';
import '../bloc/Board/BoardBloc/boord_bloc.dart';
import 'dialogs.dart';

class YearsButtons extends StatefulWidget {
  final ScrollController _scrollController;
final List<String> years;
  const YearsButtons(this._scrollController, this.years, {super.key});

  @override
  State<YearsButtons> createState() => _YearsButtonsState();
}

class _YearsButtonsState extends State<YearsButtons> {
  @override
  void initState() {
    context.read<YearsBloc>().add(ChangeBoardYears(year:widget.years[0]));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricHorizontal(h:12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ProfileComponents.buildFutureBuilder(buildaddButtBoard(context), true, "", (p0) => FunctionMember.isSuper()),
            SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,

                scrollDirection: Axis.horizontal,
                itemCount: widget.years.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: ()async{
                      if (await FunctionMember.isSuper()){
                        if (!mounted) return;
                        context.read<YearsBloc>().add(ChangeCloneYear(year:widget.years[index]));

                        Dialogs.showDelete(context, widget.years[index],TypeDelete.Board,"");
                      }

                    },
                    onTap: (){
                      context.read<YearsBloc>().add(ChangeBoardYears(year:widget.years[index]));
                      context.read<BoordBloc>().add(FetchBoardYearsEvent(year:widget.years[index]));

                    },
                    child: BlocBuilder<YearsBloc, YearsState>(
        builder: (context, state) {
      return Container(

                    decoration: buildBoxDecoration(state, index),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            widget.years[index],
                            style: PoppinsRegular(14,
                               state.year==widget.years[index]?textColorWhite:textColorBlack,
                            ),
                          ),
                        ),
                      ),
                    );
        },
      ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10,);
              },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Padding buildaddButtBoard(BuildContext context) {
    return Padding(
            padding: paddingSemetricHorizontal(),
            child: SizedBox(
              height: 50,
              width: 50,
              child: InkWell(
                radius: 20,
               onTap: (){
                 Dialogs.showYearSelectionDialog(context,);

               },
                child: DottedBorder(
                        radius: const Radius.circular(10),
                        dashPattern:const  [10,12,10,12],
                        color: textColor,
                        strokeWidth: 3,
                        borderType: BorderType.RRect,
                        child:const  Center(
                          child:  Icon(Icons.add,color: textColor,size: 20,),
                        ),
                      ),
              ),
            ),
          );
  }

  BoxDecoration buildBoxDecoration(YearsState state, int index) {
    return BoxDecoration(
                  borderRadius: BorderRadius.circular(10),  color: state.year==widget.years[index]?PrimaryColor:backgroundColored
                    ,border: Border.all(color: textColorBlack,width: 2),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
    state.year==widget.years[index]?PrimaryColor:backgroundColored,
    state.year==widget.years[index]?SecondaryColor:backgroundColored,]
    ),


                  );
  }
}

