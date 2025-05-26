import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../global-pres.dart';

import '../../bloc/objectifs/objectif_bloc.dart';
import 'AchivementsWidget.dart';
import 'GroupObjectifGroupByListWidget.dart';

class Objectifimpl extends StatelessWidget {
  const Objectifimpl({super.key, required this.controller, required this.id});
final ScrollController controller;
final String id;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: PrimaryColor,
      onRefresh: () {
        context.read<ObjectifBloc>().add(LoadObjectifs(userId: id??"",isRefreshed: true));
        return Future.delayed(Duration(seconds: 1));
      },
      child: BlocBuilder<ObjectifBloc, ObjectifState>(
          builder: (context, state) {
            switch(state.status){
              case ObjectifStatus.Failure:
                return Center(child: Text('failed to fetch posts',style:PoppinsNorml(18.sp, ColorsApp.textColorBlack) ,),);
              case ObjectifStatus.Success:
                if (state.objectifs.isEmpty) {
                  return  Center(child: Text('no Objectifs fama ghalta',style: PoppinsNorml(17.sp, ColorsApp.textColor),));
                }




                return
                  state.groupBYObjectifs.isEmpty?

                  ObjectifList(controller: controller, id: id, state: state):
                  GroupedObjectifsListWidget(groupBYObjectifs:state.groupBYObjectifs, hasReachedMax: state.hasReachedMax,
                    loadMoreCallback: (){
                      context.read<ObjectifBloc>().add(LoadMoreObjectifs(userId: id??"", lastDocument: state.lastDocument));

                    }, id: id ,);
              default:
                return const Center(child:LoadingWidget());
            }

          }


      ),
    );;
  }
}

class ObjectifList extends StatelessWidget {
  const ObjectifList({
    super.key,
    required this.controller,
    required this.id, required this.state,

  });
final ObjectifState state;
  final ScrollController controller;
  final String id;

  @override
  Widget build(BuildContext context) {
    List<ValueNotifier<bool>> expandStates =
    List.generate(state.hasReachedMax?state.objectifs.length:state.objectifs.length+1, (_) => ValueNotifier<bool>(false));

    return ListView.separated(
      controller: controller,
      shrinkWrap: true,
      itemCount:state.hasReachedMax?state.objectifs.length:state.objectifs.length+1,

      itemBuilder: (context, index) {
        if (index<state.objectifs.length){

          final item = state.objectifs[index];
          return AchievementWidget(
            userObjectif: item.userObjectif,
            objectif:item.objectif ,
            isExpanded: expandStates[index], memberid: id,


          );}
        return TextButton(
            style:
            ElevatedButton.styleFrom(
              side: BorderSide(color: ColorsApp.textColorBlack),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),

              ),
            )
            ,
            onPressed: (){
          context.read<ObjectifBloc>().add(LoadMoreObjectifs(userId: id??"", lastDocument: state.lastDocument));

        }, child: Text("Load More".tr(context),style: PoppinsNorml(18.sp, ColorsApp.textColorBlack),));

      }, separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 11,);
    },
    );
  }
}
