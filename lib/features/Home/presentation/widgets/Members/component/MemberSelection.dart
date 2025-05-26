import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:logger/logger.dart';

import '../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/strings/app_strings.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../../MemberSection/presentation/pages/user/memberProfilPage.dart';
import '../../../../../../core/Member.dart';
//import '../../../auth/presentation/bloc/Members/members_bloc.dart';
import '../../../../domain/enums/Privacy.dart';
import '../../../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../components/ErrorDisplayMessage.dart';
import '../../components/SearchWidget.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'MemberBottomSheetdetails.dart';
import 'ProfileImage.dart';

class BottomMemberSheetWidget extends StatelessWidget {
  final User member;
  final String text;
  final String title;

  final String? errorText;

  const BottomMemberSheetWidget({
    Key? key,

    required this.member,
    required this.text,
    required this.title,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: InkWell(
        onTap: () {
          context.read<ActivityCubit>().changeUserStatus(UserChoice.ONE);
          context.read<FormzBloc>().add(const ThrowError(error: ""));

          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return MembersBottomSheetDetails(text: title);
            },
          );
        },
        child: Container(
          width: mediaQuery.size.width,
          height: member.firstName.isNotEmpty ? 65 : 50,
          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color:errorText!=null?  errorText!.isNotEmpty?Colors.red:  ThirdColor:ThirdColor,
                width: 2,
              )), // Assuming this is a predefined decoration
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Padding(
              padding: paddingSemetricHorizontal(), // Assuming this is a predefined padding
              child: member.firstName.isNotEmpty
                  ? UserExistsWidget()
                  : Text(
                text,
                style: PoppinsNorml(18, ThirdColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row UserExistsWidget() {
    return Row(
                  children: [
                    MemberImageWidget(
                                    item: member,
                                    height: 30,
                                    width: 23,
                                    bools: true,
                                    size: 20,
                                  ),

                  ],
                );
  }

}



class BottomPrivatePartcipantsSelectionsSheetWidget extends StatelessWidget {
  final List<User> members;
  final String text;
  final String title;


  const BottomPrivatePartcipantsSelectionsSheetWidget({
    Key? key,

    required this.members,
    required this.text,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: InkWell(
        onTap: () {
          context.read<ActivityCubit>().changeUserStatus(UserChoice.MULTIPLE);

          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return MembersBottomSheetDetails(text: title);
            },
          );
        },
        child: Container(
          width: mediaQuery.size.width,
          height: members.isNotEmpty ? 65 : 50,
          decoration: memberdeco, // Assuming this is a predefined decoration
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Padding(
              padding: paddingSemetricHorizontal(), // Assuming this is a predefined padding
              child: members.isNotEmpty
                  ? UsersImage(context, mediaQuery, members)
                  : Text(
                text,
                style: PoppinsNorml(18, ThirdColor),
              ),
            ),
          ),
        ),
      ),
    );
  }Widget UsersImage(BuildContext context, MediaQueryData mediaQuery,
      List<User> members,)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(

      children: [
        for (var i = 0; i < (members.length > 4? 3 : members.length); i++)

          Align(
              widthFactor: .6,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: textColorWhite,width: 5),
                  shape: BoxShape.circle,
                ),
                child: ProfileImageWidget(item: members[i], height: 30),)),
        if (members.length > 4)
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: PrimaryColor,
              shape: BoxShape.circle,                      ),
            // Customize the container as needed
            child: Align(
              widthFactor: .4,
              child: Center(
                child: Text(
                  '+ ${members.length - 4} ',
                  style: PoppinsLight(18, textColorWhite),
                ),
              ),
            ),
          ),
      ],
    ),
  );

}