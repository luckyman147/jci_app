import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../domain/enums/SearchType.dart';

Future<void> RefreshMembers(BuildContext context,SearchType type,String name) async {
  if (type==SearchType.All||name.isEmpty) {
    context.read<MembersBloc>().add(const GetAllMembersEvent(true));
  } else {
    context.read<MembersBloc>().add(GetMemberByNameEvent(name: name));
  }

}