import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/MemberSection.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/SettingsComponents.dart';

import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';

class MemberImpl{

  static Widget  MemberWidget(String id){
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        if (state is MembersInitial) {
          return LoadingWidget();
        } else if (state is MemberLoading) {
          return LoadingWidget();
        } else if (state is UserLoaded) {

          return MemberSectionWidget(member:state.user);
        } else if (state is MemberFailure) {
          return SettingsComponent.signoput(context);
        }
        return LoadingWidget();
      },
    );
  }
}