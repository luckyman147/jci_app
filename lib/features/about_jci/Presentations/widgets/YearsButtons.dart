import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/Board/BoardBloc/boord_bloc.dart';

class YearsButtons extends StatefulWidget {
  final ScrollController _scrollController;
final List<String> years;
  YearsButtons(this._scrollController, this.years);

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
                        context.read<YearsBloc>().add(ChangeCloneYear(year:widget.years[index]));

                        JCIFunctions.showDeleteBoard(context, widget.years[index]);
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
                  return SizedBox(width: 10,);
              },
              ),
            ),

          ],
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

