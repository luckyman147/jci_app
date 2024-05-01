import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/ShimmerEffects.dart';

import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../Domain/entities/President.dart';
import 'LastPresidentsWidget.dart';
import 'PresComponents.dart';

class PresidentsImpl{

  static Widget GetAllPresidents(ScrollController controller,bool mountde){
    return BlocBuilder<PresidentsBloc,PresidentsState>(builder: (context,state){
switch(state.state){
  case presidentsStates.Initial:
    return ShimmerEffects.PresidensShimmer(true);
  case presidentsStates.Loading:

    return ShimmerEffects.PresidensShimmer(true);
    case presidentsStates.Changed:
      case presidentsStates.Loaded:
      case presidentsStates.ErrorCrete:

    return LastPresidentsWidget(presidents: state.presidents, hasReachedMax: state.hasReachedMax, controller: controller, mounted: mountde,);

//return LastPresidentsWidget(presidents: state.presidents, hasReachedMax: state.hasReachedMax,controller: controller,mounted: mountde,);
  case presidentsStates.Error:
    return ShimmerEffects.PresidensShimmer(true);
  default:
    return ShimmerEffects.PresidensShimmer(true);
}
    });

  }

  static SizedBox PhotoImpl(President president) {
    return SizedBox(

      child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
        builder: (context, state) {
          switch (state.status){
            case Status.Loading:
              return ShimmerEffects.shimmerCircle(120, 120);
            case Status.Changed:
              return PresidentsComponents.UpodatePOhotoWid(state, context, president);
            default:
              return PresidentsComponents.UpodatePOhotoWid(state, context, president);
          }

        },
      ),
    );
  }
}