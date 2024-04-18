import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';

import 'LastPresidentsWidget.dart';

class PresidentsImpl{

  static Widget GetAllPresidents(ScrollController controller,bool mountde){
    return BlocBuilder<PresidentsBloc,PresidentsState>(builder: (context,state){
switch(state.state){
  case presidentsStates.Initial:
    return Center(child: LoadingWidget
    (),);
  case presidentsStates.Loading:

    return Center(child: LoadingWidget
    (),);
    case presidentsStates.Changed:
    return LastPresidentsWidget(presidents: state.presidents, hasReachedMax: state.hasReachedMax, controller: controller, mounted: mountde,);
  case presidentsStates.Loaded:
return LastPresidentsWidget(presidents: state.presidents, hasReachedMax: state.hasReachedMax,controller: controller,mounted: mountde,);
  case presidentsStates.Error:
    return Center(child: MessageDisplayWidget(message: state.message,),);
  default:
    return Center(child: LoadingWidget
    (),);
}
    });

  }
}