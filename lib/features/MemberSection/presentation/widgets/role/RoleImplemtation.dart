import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/features_cubit.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/role/ChangeRoleTab.dart';

import '../../../global-pres.dart';
import 'FeaturePermissionWidget.dart';

class RoleImpl extends StatelessWidget {
  const RoleImpl({super.key, required this.roleName, required this.MemberId});
final String roleName;
final String MemberId;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        context.read<RoleBloc>().add(FetchRolesEvent());

      },
      color: ColorsApp.PrimaryColor,
      child: BlocConsumer<RoleBloc,RoleState>(
          builder: (context,state){
            return state.status.when(

                loading: ()=>const LoadingWidget(),
                loaded:() {
                  if (state.roles .isEmpty)
                    return Text("empty");
                  return ChangeRoleTab(roles: state.roles, roleName: roleName,memberId: MemberId,);
                }, error: ()=>Column(
              children: [Text("sss",style: PoppinsSemiBold(15.sp, ColorsApp.textColor, TextDecoration.none),)],

            ));

          },

          listener: (context,state){}),
    );
  }
}
class FeatureImplementations extends StatelessWidget {
  const FeatureImplementations({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async {
        context.read<FeaturesCubit>().fetchFeatures();

      },
      color: ColorsApp.PrimaryColor,
      child: BlocConsumer<FeaturesCubit,FeaturesState>(builder:
          (context,state){
        if (state.typeFeatureStatus ==TypeFeatureStatus.Loaded ){
          if (state.featuresModified.isEmpty     ) {

            return Text("no data ");
          }
          return FeaturePermissionsWidget (features: state.featuresModified,);
        }
        return LoadingWidget();

          },
          listener: (context,state){}),
    );
  }
}

