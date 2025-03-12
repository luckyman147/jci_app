import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../components/Header.dart';
import '../../components/SearchTextField.dart';
import 'MemberList.dart';

class MembersBottomSheetDetails extends StatelessWidget {
  final String text;

  const MembersBottomSheetDetails({
    Key? key,
    required this.text,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: mediaQuery.size.height / 0.9,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: BlocBuilder<FormzBloc, FormzState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Choose header widget
                ChooseHeader(
                  text: text,

                ),
                // Search text field widget
                SearchTextField(
                  onChanged: (String ) {
                       context.read<FormzBloc>().add(MembernameChanged(name: String));
                     if (state.memberName.value.length > 1) {
                     context.read<MembersBloc>().add(GetMemberByNameEvent(name: state.memberName.value));
                    } else if (state.memberName.value.isEmpty || state.memberName.displayError != null) {
                    context.read<MembersBloc>().add(const GetAllMembersEvent(false));
                     }

                  }, hintText: 'Search for a',
                  errorText:  null,
                ),
                // Members list widget
                MembersList(
                  mediaQuery: mediaQuery,
                  memberName: state.memberName.value,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
