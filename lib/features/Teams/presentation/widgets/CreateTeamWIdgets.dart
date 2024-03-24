import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/MembersTeamSelection.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/domain/entities/Event.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';

import '../../../auth/domain/entities/Member.dart';
import '../../domain/entities/Team.dart';
import 'EventSelection.dart';

Widget ActionsWidgets(mediaQuery,GlobalKey<FormState> key,TextEditingController TeamName,TextEditingController description ) => BlocConsumer<GetTeamsBloc, GetTeamsState>(
  builder: (context, state) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
  builder: (context, state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Header(context,"Create Team"),
        DoneActions(TeamName, description, key),

      ],
    );
  },
);
  }, listener: (BuildContext context, GetTeamsState state) {
    log(state.toString());
    if (state.status ==  TeamStatus.error)
    {SnackBarMessage.showErrorSnackBar(message: state.errorMessage, context: context);
    }
    if (state.status == TeamStatus.success) {
      SnackBarMessage.showSuccessSnackBar(message: "Team Added", context: context);
      GoRouter.of(context).go('/home');
    }


},
);
Widget DoneActions(TextEditingController TeamName, TextEditingController description,GlobalKey<FormState> key)=>BlocBuilder<FormzBloc, FormzState>(
  builder: (context, form) {
    return BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, Visstate) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap:(){
                if (key.currentState!.validate()&& form.imageInput.value!=null&&form.imageInput.value!.path.isNotEmpty) {
                  final Team team = Team(
                      name: TeamName.text,
                      description: description.text,
                      CoverImage: form.imageInput.value !=null? form.imageInput.value!.path:"",
                      event: form.eventFormz.value==null?"":form.eventFormz.value!.id,
                      id: '', TeamLeader: '', status: Visstate.isVisible, tasks: [], Members:getIds( form.membersTeamFormz.value??[]));
                  context.read<GetTeamsBloc>().add(AddTeam(team));
                }

              },
              child:  Text(
                  "Done",style: PoppinsSemiBold(21, PrimaryColor, TextDecoration.none)
              ),
            )
        );
      },
    );
  },
);


Row Header(BuildContext context,String text) {
  return Row(
        children: [
          BackButton(
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
          ),
          Text('$text ',style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)),
        ],
      );
}
Widget imageTeamPicker(mediaQuery) {
  final ImagePicker picker = ImagePicker();
  return BlocBuilder<FormzBloc, FormzState>(
    builder: (context, state) {

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          InkWell(
            onTap: () async {
              final XFile? picked =
              await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                context
                    .read<FormzBloc>()
                    .add(ImageInputChanged(imageInput: picked));
              }
            },
            child: Stack(
              children: [
                Container(
width: mediaQuery.size.width/1.1
                  ,
                  height: 200,

decoration: BoxDecoration(
borderRadius: BorderRadius.circular(15),

                    color: PrimaryColor.withOpacity(.1),
                  ),


                  child: state.imageInput.value != null && state.imageInput.value?.path != null&&state.imageInput.value?.path != ""
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                                            File(state.imageInput.value?.path ?? ""),
                                            fit: BoxFit.cover,
                        height: 200,
                                          ),
                      )
                      :

          //blase
choosWidget()
                ),
                state.imageInput.value != null && state.imageInput.value?.path != null&&state.imageInput.value?.path != ""?
                Positioned(
                    right: 0,

                    child:Padding(
                      padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height/15,horizontal: 5),
                      child: InkWell(
                        onTap: () async{
                          final XFile? picked =
                          await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            context
                                .read<FormzBloc>()
                                .add(ImageInputChanged(imageInput: picked));
                          }
                        },
                        child: Container(

                          decoration:
                          BoxDecoration(color: BackWidgetColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Icon(
                                  Icons.edit,
                                  color: textColorBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ) ):SizedBox()
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget choosWidget()=>        const Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 28.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo,
          size: 20,
          color: PrimaryColor,
        ),

      ],
    ),
  ));
Widget TextTeamfieldNormal(String name, String HintText,
    TextEditingController controller, Function(String) onchanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(

            textInputAction: TextInputAction.next,
            autofocus: true,
            autocorrect: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              onchanged(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            style: PoppinsNorml(18, textColorBlack),
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                focusedErrorBorder: border(PrimaryColor),

                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );
Widget TextTeamfieldDescription(String name, String HintText,
    TextEditingController controller, Function(String) onChanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(

            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: true,
            autofocus: true,
            minLines: 3,
            maxLength: 50,
            autofillHints: [HintText],
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              onChanged(value);
            },
            style: PoppinsNorml(18, textColorBlack),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                focusedErrorBorder: border(PrimaryColor),
                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );


Widget bottomMembersSheet(BuildContext context, MediaQueryData mediaQuery,
    List<Member> members,




    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0,),
    child: InkWell(
      onTap: () {
        MemberBottomSheetBuilder(context, mediaQuery, (value){}, (value){});
      },
      child:Container(
          width: mediaQuery.size.width,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: ThirdColor,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0,),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child:
              members!=null&& members.isNotEmpty?membersImage(context, mediaQuery, members):
              Text("Select  Members",style: PoppinsRegular(18, ThirdColor),),
            ),
          )),
    ),
  );}

void MemberBottomSheetBuilder(BuildContext context, MediaQueryData mediaQuery,
    Function(Member) onRemoveTap, Function(Member) onAddTap
    ) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return BlocBuilder<FormzBloc, FormzState>(
        builder: (context, state) {
          return MembersTeamBottomSheet(mediaQuery, onRemoveTap, onAddTap);
        },
      );
    },
  );
}


Widget membersImage(BuildContext context, MediaQueryData mediaQuery,
    List<Member> members,)=>Padding(
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
                child: photo(members[i].Images,50,100))),
      if (members.length > 4)
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
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
Widget bottomEventSheet(BuildContext context, MediaQueryData mediaQuery,
    Event event,


    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0,),
    child: InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return BlocBuilder<FormzBloc, FormzState>(
              builder: (context, state) {
                return EventsTeamBottomSheet(mediaQuery);
              },
            );
          },
        );
      },
      child:Container(
          width: mediaQuery.size.width,
          decoration:
          memberdeco,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0,),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child:
              event!=null&& event.name.isNotEmpty&& event.name!='Choose the Event'?imageEventWidget(event,mediaQuery):
              Text("Select Events",style: PoppinsRegular(18, ThirdColor),),
            ),
          )),
    ),
  );}
Widget StatusWidget(mediaQuery) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: BlocBuilder<VisibleBloc, VisibleState>(
  builder: (context, state) {
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 18.0),
  child: Column(
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  "Status",
  style: PoppinsRegular(
  mediaQuery.devicePixelRatio * 6, textColorBlack),
  ),
  InkWell(






      onTap: (){
        if(state.isPaid)
        context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(false));
        else
        context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(true));

      }, child: Container(
    width: mediaQuery.size.width * .3,
      decoration: BoxDecoration(
      color: state.isPaid?Colors.red:Colors.green,
      borderRadius: BorderRadius.circular(15.0),
      ),


      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(state.isPaid?"Private":"Public",style: PoppinsRegular(18, textColorWhite),)),
      )),
  ),
  ],
  ),
  ],
  ));
  }),
);

