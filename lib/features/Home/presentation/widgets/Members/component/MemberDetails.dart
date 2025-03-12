import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';

import '../../../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../../../MemberSection/presentation/pages/memberProfilPage.dart';
import 'MemberContainer.dart';

// Your other imports for MemberSectionPage and BLoC events and states

class MembersDetailsWidget extends StatelessWidget {
  final List<User> members;


  // Constructor
  const MembersDetailsWidget({
    Key? key,
    required this.members,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: members.length,
      itemBuilder: (context, index) {
        return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                // Navigate to the member details page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MemberSectionPage(id: members[index].id!);
                    },
                  ),
                );

                // Fetch member details using the BLoC event
                context.read<MembersBloc>().add(
                  GetMemberByIdEvent(
                    MemberInfoParams(id: members[index].id!, status: true),
                  ),
                );
              },
              child: MemberContainer(item:  members[index]), // Display member's data in a container
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 6); // Space between members
      },
    );
  }
}
