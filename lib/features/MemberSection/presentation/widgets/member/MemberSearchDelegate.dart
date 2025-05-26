import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../global-pres.dart';
import '../../mixins/MemberSearchMixin.dart';

class MemberSearchDelegate extends SearchDelegate<User> with MemberSearchMixin {
  final BuildContext context;


  MemberSearchDelegate(this.context, );

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    )
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  @override
  Widget buildResults(BuildContext context) {
    context.read<MembersBloc>().add(const GetAllMembersEvent(true));

    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        if (state.userStatus == UserStatus.Loading) {
          return const Center(child: LoadingWidget());
        }

        return buildSearchResults(
            filterMembers(state.members, query)
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final members = context.read<MembersBloc>().state.members;
    return buildSearchResults(
        filterMembers(members, query).take(5).toList()
    );
  }
}