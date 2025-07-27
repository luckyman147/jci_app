
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/components/buttonsComponents.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/Member.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../global-pres.dart';
import '../../bloc/objectifs/objectif_bloc.dart';
import '../../pages/objectif/ObjectifFormPage.dart';
import 'ObjectifImpl.dart';

class BuildObjectifsWidget extends StatefulWidget {
  final Member member;
  final MemberManagementState state;


  const BuildObjectifsWidget({
    Key? key,
    required this.member,
    required this.state,
  }) : super(key: key);

  @override
  State<BuildObjectifsWidget> createState() => _BuildObjectifsWidgetState();
}

class _BuildObjectifsWidgetState extends State<BuildObjectifsWidget> {

  final _scrollController = ScrollController();
  late ObjectifBloc objectifBloc;
  @override
  void initState() {
    super.initState();
    objectifBloc = BlocProvider.of<ObjectifBloc>(context);

    objectifBloc.add(LoadObjectifs(userId: widget.member.id??"",));
    _scrollController.addListener(_onScroll);
  }
  @override
      void dispose() {
        _scrollController.dispose();
        super.dispose();
      }
      void _onScroll() {
        if (_isBottom) objectifBloc.add(LoadMoreObjectifs(userId: widget.member.id??"", lastDocument: objectifBloc.state.lastDocument,));
      }


  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child:Column(
        children: [


          const SizedBox(height: 20),
     ButtonsMemberComponents.     buildCreateObjectif((){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  Objectifformpage(MemberId:widget.member.id??"", event: ObjectiveEvent.Create ,),
              ),
            );
          },
         "Create objectif".tr(context),Constants.MANAGE_POINTS
     ),


          const SizedBox(height: 20),
          Expanded(
            child: Objectifimpl (controller: _scrollController, id: widget.member.id??"",),
          ),
        ],
      ),



    );
  }



}




