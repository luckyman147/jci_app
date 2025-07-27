
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/features/Home/domain/Dtos/PVParamDto.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/ActivityFunctions.dart';

import '../../../../Activity_Global.dart';
import '../../../../domain/entities/PVEntity/PV.dart';
import '../../../bloc/Activity/BLOC/PV/pv_bloc.dart';

class PVListWidget extends StatelessWidget {
  final List<PV> pvList;

  const PVListWidget({Key? key, required this.pvList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: mediaQuery.size.width,
      height: pvList.isEmpty ? mediaQuery.size.height * 0.5 : pvList.length * 150.0 + 100,

      child: Column(
        children: [

        AddPVWidget(mediaQuery,context),
      (pvList.isEmpty)?AutoSizeText("No PVs Found",style: PoppinsSemiBold(16.sp, ColorsApp.textColorBlack, TextDecoration.none),):

          SizedBox(
            width: mediaQuery.size.width,
            height: pvList.isEmpty ? mediaQuery.size.height * 0.2 : pvList.length * 150.0,
            child: ListView.separated(
              itemCount: pvList.length,
              itemBuilder: (context, index) {
                final pv = pvList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Card(
                    surfaceTintColor: ColorsApp.BackWidgetColor,
                     color: ColorsApp.textColorWhite,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ColorsApp.textColorBlack),
                    ),
                    child: ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
                          final pvdto=PvParamDto(PVId: pv.id, pvParam: pv,
                              ActivityId:  context.read<AcivityFBloc>().state.activityById!.activityBasics.id);
              context.read<PvBloc>().add(DeletePvEvent(pvdto));

                }),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: _getFileColor(pv.Extension),
                        child: Icon(
                          _getFileIcon(pv.Extension),
                          color: Colors.white,
                        ),
                      ),
                      title: AutoSizeText(
                        pv.title,
                        style:PoppinsSemiBold(16.sp, ColorsApp.textColorBlack, TextDecoration.none),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 5),
                          Text(
                            _formatDate(pv.date),
                            style: PoppinsNorml(14.sp, ColorsApp.BackWidgetColor),
                          ),
                        ],
                      ),
                      onTap: () {
              context.read<PvBloc>().add(downloadPvEvent(pv));
                      },
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
            },
            ),
          ),
        ],
      ),
    );
  }

  Widget AddPVWidget(MediaQueryData mediaQuery,BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
      onTap: () async{
       final file=     await ActivityAction.pickFile();
        if(file!=null){

      final pvdto=PvParamDto(PVId: file.id, pvParam: file,
          ActivityId:  context.read<AcivityFBloc>().state.activityById!.activityBasics.id);
      context.read<PvBloc>().add(AddPvEvent(params: pvdto));
        }


      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        color: Colors.grey,
        strokeWidth: 2,
        dashPattern: const [16, 13,12,24],
        child: Container(
          width: mediaQuery.size.width,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const   Icon(
                Icons.insert_link_rounded, // Insert icon
                color: ColorsApp.ThirdColor,
                size: 24,
              ),
               const SizedBox(width: 8), // Spacing between icon and text
              AutoSizeText(
                ' Insert PVs',
                style:PoppinsSemiBold(16.sp, ColorsApp.textColorBlack, TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }

  /// Get the appropriate icon for the file extension
  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Get the appropriate background color for the file type
  Color _getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Format date to a readable string
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  /// Get the first 100 words of the description
  String _getShortDescription(String description) {
    final words = description.split(' ');
    if (words.length <= 100) {
      return description;
    }
    return '${words.take(100).join(' ')}...';
  }
}