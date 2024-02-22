import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Home/domain/usercases/EventUseCases.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Event/EventsOfTheweekend/evebnts_of_thewwekend_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/EventListWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/EventOfweek.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../bloc/Event/events_bloc.dart';
import 'ErrorDisplayMessage.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 49,
      child: IconButton(
        style: IconButton.styleFrom(
            backgroundColor: BackWidgetColor,
            shape: CircleBorder(

            )

        ),
        onPressed: () {
          // Navigator.pushNamed(context, Routes.search);
        },
        icon: Icon(Icons.search),
      ),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String selectedValue = 'Event';


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeStringBloc, ChangeStringState>(
      builder: (context, Chastate) {
        return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
          builder: (context, state) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                width: 200,
                height: 65,

                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(

                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(


                  child: DropdownButton2(

                  style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),

                    dropdownStyleData:const  DropdownStyleData(

                      maxHeight: 200,
                      elevation: 1,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
                        border: Border(
top: BorderSide(color: Colors.black, width: 2.0),
                          left: BorderSide(color: Colors.black, width: 2.0),
                          right: BorderSide(color: Colors.black, width: 2.0),
                          bottom: BorderSide(color: Colors.black, width: 2.0),
                        ),

                      ),
                      offset: const Offset(-14, 0),
                      scrollbarTheme: ScrollbarThemeData(

                        radius: const Radius.circular(14),

                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                    onMenuStateChange: (bool isMenuOpen) {

                        context.read<ToggleBooleanBloc>().add(ToggleBoolean());

                    },
iconStyleData:  IconStyleData(iconSize: 30,icon:SvgPicture.string(state.value?Arrow_UP:Arrow_Down)),
                  
                    isDense: true,
                    value: Chastate.value,


                  
             
                    underline: Container(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {

                      context.read<ToggleBooleanBloc>().add(ToggleBoolean());

                      context.read<ChangeStringBloc>().add(SetStringEvent(value: newValue??"Events"));
                  
                    },
                    items: <String>["Events", "Meetings", "Trainings", ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value),

                      );
                    }).toList(),

                  ),
                )
              ),
            );
          },
        );
      },
    );
  }
}
Widget buildBody(BuildContext context){
  return BlocBuilder<EventsBloc, EventsState>(
    builder: (context, state) {
      if (state is EventsOfMonthLoadingState) {
        return LoadingWidget();
      } else if (state is EventsOfMonthLoadedState) {
        return RefreshIndicator(
            onRefresh: () {
              print(state.eventsOfMonth.length);
              return

                onRefresh(context);},
            child:



            EventsOfMonthListWidget (Events: state.eventsOfMonth,)

        );
      }
       else if (state is EventsErrorState) {
        return MessageDisplayWidget(message: state.message);
      }
      return LoadingWidget();
    },
  );}
Widget buildWeekBody(BuildContext context){
  return BlocBuilder<EvebntsOfThewwekendBloc, EvebntsOfThewwekendState>(
    builder: (context, state) {
      if (state is EventsOfWeekLoadingState) {
        return LoadingWidget();
      } else if (state is EventsOfWeekLoadedState) {
        return RefreshIndicator(
            onRefresh: () {
              print(state.eventsOfWeek.length);
              return

                onRefresh(context);},
            child:

            EventsOfWeekListWidget (Events: state.eventsOfWeek,)
        );
      } else if (state is EventsErrorOfTheweekenState) {
        return MessageDisplayWidget(message: state.message);
      }
      return Text("eee");
    },
  );}

Future<void> onRefresh(BuildContext context) async {


    BlocProvider.of<EventsBloc>(context).add(GetEventsOfmonth());


    BlocProvider.of<EvebntsOfThewwekendBloc>(context).add(GetEventsOfweek());


}