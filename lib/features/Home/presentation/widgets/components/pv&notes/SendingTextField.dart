import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/ActivityDetailsFunctions.dart';

import '../../../../../../core/config/services/MemberStore.dart';
import '../../../../Activity_Global.dart';
import '../../../../domain/Dtos/NoteInput.dart';
import '../../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';

class SendingTextField extends StatelessWidget {
  const SendingTextField({
    super.key,
    required this.controller,
    required this.activityId,
    required this.onSend

  });
final Function(TextEditingController , String) onSend;
  final TextEditingController controller;
  final String activityId;

  @override
  Widget build(BuildContext context) {
    return Padding(padding : const EdgeInsets.all(8.0),child : Row(children : [
      Expanded(child :TextField(
        style: PoppinsRegular(14, ColorsApp.textColorBlack),
        enableSuggestions: true,
        minLines: 1,
        maxLines: 5,

        controller: controller,



        decoration : InputDecoration(
          suffixIcon: IconButton(
            icon:   Icon(Icons.send,color:controller.text.isNotEmpty?ColorsApp.SecondaryColor:ColorsApp.ThirdColor),
            onPressed: ()async{
              onSend(controller,activityId);
            },
          ),
          hintText: "Add a comment",
          hintStyle: PoppinsRegular(13.sp, ColorsApp.ThirdColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorsApp.textColorBlack),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsApp.PrimaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorsApp.textColorBlack),
          ),
        ),),),],),);
  }

}