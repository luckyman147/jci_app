import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/MemberUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/memberProfilPage.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/about_jci/Domain/useCases/BoardUseCases.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/BoardBloc/boord_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/BoardComponents.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../auth/domain/entities/Member.dart';

class MemberGridView extends StatefulWidget {
  final List<Member> members;
  final String postId;

  const MemberGridView(
      {super.key, required this.members, required this.postId});

  @override
  _MemberGridViewState createState() => _MemberGridViewState();
}

class _MemberGridViewState extends State<MemberGridView> {
  TextEditingController _searchController = TextEditingController();


  List<Member> filteredMembers = [];

  @override
  void initState() {
    super.initState();
    filteredMembers = widget.members;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery
          .of(context)
          .size
          .height / 3,
      child: BlocBuilder<ActionJciCubit, ActionJciState>(
        builder: (context, state) {
          return BuildAssignComp();
        },
      ),
    );
  }




  Widget BuildAssignComp() {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: GridView.builder(
        itemCount: min(6, widget.members.length),
        // Change the number of items to display
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: .8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,

        ),
        itemBuilder: (BuildContext context, int index) {
          final member = filteredMembers[index];

          return buildMemberGrid(member);
        },
      ),
    );
  }

  Widget buildMemberGrid(Member member) {
    return BlocBuilder<ActionJciCubit, ActionJciState>(
      builder: (context, state) {
        return InkWell(
          hoverColor: textColor,
          onTap: () {
            if (JCIFunctions.isExist(member, state.member)) {
              context.read<ActionJciCubit>().RemoveMember();
            } else {
              context.read<ActionJciCubit>().changeMember(member);
              // Navigate to member profile
            }

            // Navigate to member profile
          },
          onLongPress: () {
            context.read<MembersBloc>().add(
                GetMemberByIdEvent(
                    MemberInfoParams(id: member.id, status: true)));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberSectionPage(id: member.id,),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: JCIFunctions.isExist(member, state.member)
                  ? PrimaryColor
                  : Colors.white,
              border: Border.all(color: textColor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: paddingSemetricVertical(),
              child: Center(
                child: Column(
                  children: [
                    // Image
                    member.Images.isEmpty ? Center(child: Container(
                      height: 60,
                      width: 60,

                      decoration: BoxDecoration(
                          border: Border.all(color: textColor, width: 2),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(vip),
                              colorFilter: ColorFilter.mode(
                                  JCIFunctions.isExist(member, state.member) ?
                                  Colors.white.withOpacity(0.1) :

                                  Colors.white.withOpacity(0.5)

                                  , BlendMode.dstATop),
                              fit: BoxFit.cover
                          )
                      ),

                    ),) :


                    Center(child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: textColor, width: 2)
                        ),
                        child: ProfileComponents.SHAPE(base64Decode(
                            member.Images[0]['url']), 60))),

                    // Badge

                    // Member Name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        member.firstName + ' ' + member.lastName,
                        style: PoppinsRegular(
                          15.0,
                          JCIFunctions.isExist(member, state.member)
                              ? Colors.white
                              :
                          Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class ShimmerMember extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery
          .of(context)
          .size
          .height / 4,
      child: Column(
        children: [
          // Shimmer Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.white,
              ),
            ),
          ),

          // GridView Builder
          Expanded(
            child: GridView.builder(
              itemCount: 3, // Change the number of items to display
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 7,

              ),
              itemBuilder: (BuildContext context, int index) {
                return buildMemberGrid();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMemberGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
        children: [
          // Image
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),

          // Badge
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: Container(
              width: 40.0,
              height: 40.0,
              color: Colors.white,
            ),
          ),

          // Member Name
          Positioned(
            bottom: 8.0,
            left: 8.0,
            child: Container(
              width: 100.0,
              height: 20.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


