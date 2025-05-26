import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/RemotePermissionsDataSources.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';

import '../../../../Home/Activity_Global.dart';
import '../../../domain/entity/Objectif.dart';
import '../../bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import '../../components/ObjectifField.dart';
import '../../components/buttonsComponents.dart';
import '../../constants/Constants.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectifFormCubit, ObjectifFormState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Group Options".tr(context),
                  style: PoppinBold(
                      20.sp, ColorsApp.textColorBlack, TextDecoration.none),
                ),

                SizedBox(

                  child: DropDown<String?>(
                    selected: state.groupBy,
                    options: ConstantsObjetif.groupBy,
                    onChanged: (value) {
                      context.read<ObjectifFormCubit>().setGroupBy(value!);
                    },
                    validator: 'Group by',
                    isError: false,
                  ),
                ),

                SizedBox(height: 16),
                BlocBuilder<ObjectifFormCubit, ObjectifFormState>(

                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width /2.5,

                            child: ButtonsMemberComponents.ShowAction(context

                                , () {
                                  if (state.groupBy != null) {
                                    context.read<ObjectifBloc>().add(
                                        GroupByEvent(groupBy: state.groupBy!));
                                  }
                                  Navigator.pop(context);
                                }, "Save".tr(context)).animate(),
                          ),Padding(
                            padding: paddingSemetricHorizontal(),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width /2.5,
                              child: ButtonsMemberComponents.ShowAction(context

                                  , () {

                                      context.read<ObjectifFormCubit>().reset();
                                      context.read<ObjectifBloc>().add(
                                          GroupByEvent(groupBy: null));

                                    Navigator.pop(context);
                                  }, "Reset".tr(context),isPrimary: false).animate(),
                            ),
                          ),
                        ].reversed.toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
