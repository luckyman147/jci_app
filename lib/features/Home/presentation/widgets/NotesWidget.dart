import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/domain/usercases/MeetingsUseCase.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/notesBloc/notes_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskComponents.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../Teams/presentation/widgets/MembersTeamSelection.dart';
import '../../domain/entities/Note.dart';
import 'ShimmerEffects.dart';

class NotesListWidget extends StatefulWidget {
  const NotesListWidget({Key? key, required this.activityId}) : super(key: key);
final String activityId;
  @override
  State<NotesListWidget> createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    _scrollController.addListener(_onScroll);
    // TODO: implement initState
    super.initState();
  }
  void _onScroll() {
    if (_isBottom) context.read<NotesBloc>().add(Notesfetched(activityId: widget.activityId, isUpdated: true));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
TextEditingController titleController = TextEditingController();
TextEditingController contentController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
  listener: (context, ste) {
    if (ste.status == NotesStatus.Created) {

      titleController.clear();
      contentController.clear();
      context.read<ActivityCubit>().changeNotePage(0);
      SnackBarMessage.showSuccessSnackBar(message: "Note Created Succesfully", context: context);

    }
    if (ste.status == NotesStatus.Deleted) {

      SnackBarMessage.showSuccessSnackBar(message: "Note deleted Succesfully", context: context);
      context.read<NotesBloc>().add(resetNotes());
      context.read<NotesBloc>().add(Notesfetched(activityId: widget.activityId, isUpdated: true));

    }
    if (ste.status == NotesStatus.Updated) {
      titleController.clear();
      contentController.clear();
      context.read<ActivityCubit>().changeNotePage(0);
      context.read<NotesBloc>().add(resetNotes());
      context.read<NotesBloc>().add(Notesfetched(activityId: widget.activityId, isUpdated: true));
      SnackBarMessage.showSuccessSnackBar(message: "Note Updated Succesfully", context: context);

    }

    // TODO: implement listener}
  },
  child: BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return PageView.builder(
      controller: PageController(),
      itemBuilder: (BuildContext context, int index) {
      if (state.noteIndex==0) {
        return buildBlocConsumer();
      } else{
        return addnoTes(titleController,contentController,widget.activityId, formKey);
      }
    },
      itemCount: 2,
      onPageChanged: (value){
      context.read<ActivityCubit>().changeNotePage(value);
      },
    );
  },
),
);
  }

  BlocConsumer<NotesBloc, NotesState> buildBlocConsumer() {
    return BlocConsumer<NotesBloc, NotesState>(
    builder: (context, state) {
switch (state.status){
case NotesStatus.initial:
  case NotesStatus.loading:
  return ReloadDetailsPage.loadNotesShimer(4);
case NotesStatus.success:
  case NotesStatus.Created:
  case NotesStatus.Updated:
  case NotesStatus.Deleted:
  case NotesStatus.FailureCRUD:

  if (state.notes.isEmpty) {
    return  BUildWhileNoNotes(context);
  }
  return buildNotex(context, state);
case NotesStatus.failure:
  log(widget.activityId);
  context.read<NotesBloc>().add(Notesfetched(activityId: widget.activityId, isUpdated: true));

  return ReloadDetailsPage.loadNotesShimer(3);

default:
  context.read<NotesBloc>().add(Notesfetched(activityId: widget.activityId, isUpdated: false));

  return ReloadDetailsPage.loadNotesShimer(3);
}
    }, listener: (BuildContext context, NotesState state) {
      if (state.status == NotesStatus.failure) {
        context.read<NotesBloc>().add(Notesfetched(activityId: widget.activityId, isUpdated: true));

      }

  },
  );
  }

  Center BUildWhileNoNotes(BuildContext context) {
    return Center(child: InkWell(
    onTap: (){
      context.read<ActivityCubit>().changeNotePage(1);
    },
    child: SizedBox(
      height: MediaQuery.of(context).size.height*0.5,
      width: MediaQuery.of(context).size.width*0.8,
      child: DottedBorder(

        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        dashPattern: const [12, 16],
        color: textColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add,size: 50,color: textColor,),
              const SizedBox(height: 10,),
              Text('Add The First Note',style: PoppinsRegular(14, textColorBlack),),



            ],
          ),
        ),
      ),
    ),
  ));
  }

  SizedBox buildNotex(BuildContext context, NotesState state) {
    return SizedBox(

    width: double.infinity,
    child: Column(
      mainAxisSize: MainAxisSize.min,

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Header(context),

        Body(state),
      ],
    ),
  );
  }

  Expanded Body(NotesState state) {
    return Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {

            if (index >= state.notes.length ) {
              return const SizedBox();
            } else {
              return InkWell(
                onTap: (){
            ActivityAction.      showNotedetails(context, state, index);
                },
                onLongPress: ()
                async{
                  await ActivityAction.showDeleteNotedialog(state, index, context,widget.activityId);
                },
                child: Container(
                margin: paddingSemetricHorizontal(),

                            width: double.infinity,
                            decoration: BoxDecoration(
                border: Border.all(color: textColorBlack,
                  width: .5,
                ),
                borderRadius: BorderRadius.circular(10),


                            ),
                            child:Column(
                              mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:   CrossAxisAlignment.start,
                children: [
                  NoteHeader(state, index),
                  Center(
                    child: SizedBox(
                      height: 1,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: const Divider()),
                  ),
                  noteBody(state, index),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('EEEE,MMM,yyy').format(state.notes[index].date),
                      style: PoppinsRegular(14, textColor),
                    ),
                  ),
                ],
                    ),
                          ),
              );
            }
          },
          itemCount: state.hasReachedMax ? state.notes.length : state.notes.length + 1,
          controller: _scrollController, separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10,);
        },
        ),
      );
  }




  Padding NoteHeader(NotesState state, int index) {
    return Padding(
                padding: paddingSemetricVerticalHorizontal(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween
                  ,children: [
                Row(
                  children: [
                    Padding(
                      padding: paddingSemetricHorizontal(),
                      child:
                      (state.notes[index].owner as List).isNotEmpty?
                      MemberTeamSelection. photo(
                      state.notes[index].owner[0]["Images"],
                          30, 15):
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 30,
                          width:30,
                          color: textColor,
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: textColorWhite,
                              size: 30 / 2,
                            ),
                          ),
                        ),

                      )

                    ),
                        Text(
                          state.notes[index].owner[0]["firstName"],
                          style: PoppinsRegular(14, textColorBlack),
                        ),
                  ],
                ),
                  Padding(
                    padding: paddingSemetricHorizontal(),
                    child: ProfileComponents.buildFutureBuilder(
                    IconButton.outlined(onPressed: (){
                      titleController.text = state.notes[index].title;
                      contentController.text = state.notes[index].content;
                      context.read<ActivityCubit>().changeNotePage(1);
                      context.read<NotesBloc>().add(changeNoteActionEvent(state.notes[index].id,action: NotesAction.update

                      ));


                    }, icon: const Icon(Icons.edit))

                    , true, "", (p0) => FunctionMember.isOwner(state.notes[index].owner[0]["_id"], ),
                    ),
                  ),
                  ],
                ),
              );
  }

  Padding noteBody(NotesState state, int index) {
    return Padding(
                padding: paddingSemetricVerticalHorizontal(h: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.notes[index].title,
                      style: PoppinsSemiBold(14, textColorBlack, TextDecoration.none),
                    ),
                    Text(
                                 ActivityAction.getFirstNWords(state.notes[index].content, 10),
                      style: PoppinsRegular(15, textColorBlack),
                    ),
                  ],
                ),
              );
  }

  Row Header(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              BackButton(onPressed: (){
                Navigator.pop(context);
                context.read<ActivityCubit>().changeNotePage(0);
                context.read<NotesBloc>().add(resetNotes());

              },),
              Padding(
                padding: paddingSemetricHorizontal(),
                child: Text("Notes",style: PoppinsRegular(17, textColorBlack),),
              ),
            ],
          ),
          Padding(
            padding: paddingSemetricHorizontal(),
            child: buildAddButton(() => context.read<ActivityCubit>().changeNotePage(1)),
          )
        ],
      );
  }
  Widget addnoTes(TextEditingController title, TextEditingController content,String activityId,GlobalKey<FormState> formKey,
      ){
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: BlocBuilder<NotesBloc, NotesState>(
  builder: (context, state) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(onPressed: (){
                  context.read<ActivityCubit>().changeNotePage(0);
                  title.clear();
                  content.clear();
                  context.read<NotesBloc>().add(const changeNoteActionEvent("",action: NotesAction.create

                  ));

                },),
                state.action==NotesAction.create?Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Text("${"Add".tr(context)} note",style: PoppinsRegular(16, textColorBlack),),
                ):Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Text("${"Edit".tr(context)} note",style: PoppinsRegular(16, textColorBlack),),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end
                  ,            children: [
                  Visibility(
                   visible: state.action==NotesAction.update,
                    child: IconButton(
                      icon: const Icon(Icons.archive,color: SecondaryColor,),
                      tooltip: 'ARCHIVE',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final note=Note(id: state.noteId, title: title.text, content: content.text, date: DateTime.now(), owner:"" );

                          if (state.action==NotesAction.update){
                            context.read<NotesBloc>().add(updateNote(note: note));

                        }}
                        // Handle save action

                      },
                    ),
                  ),
                  Visibility(
                    visible: state.action==NotesAction.create,
                    child: IconButton(
                      icon: const Icon(Icons.send,color: PrimaryColor,),
                      tooltip: 'Send',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final note=Note(id: '', title: title.text, content: content.text, date: DateTime.now(), owner:"" );
                          final noteIput=NoteInput(activityId, note,null);

                          context.read<NotesBloc>().add(createNoteEvent(note: noteIput));

                        }

                      },
                    ),
                  ),
                ],
                ),
              ],
            )
            ,

            Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text'.tr(context);
                  }
                  return null;
                },


                controller: title,
                style: PoppinsRegular(14, textColorBlack),
                decoration: InputDecoration(
                  hintText: "Title",

        errorStyle: PoppinsRegular(14, Colors.red),
                  hintStyle: PoppinsRegular(14, textColorBlack),
                  border: border(PrimaryColor),
                    enabledBorder: border(PrimaryColor)
                  ,focusedBorder: border(PrimaryColor)
                ),
              ),
            ),
            Padding(
              padding: paddingSemetricHorizontal(),
              child: TextFormField(
                maxLines: 20,
                maxLength: 1000,
                controller: content,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text'.tr(context);
                  }
                  else if(value.length<10){
                    return 'Please enter more than 10 characters';
                  }
                  return null;
                },
                style: PoppinsRegular(14, textColorBlack),
                decoration: InputDecoration(
                  hintText: "Content",
errorStyle: PoppinsRegular(14, Colors.red),
                  hintStyle: PoppinsRegular(14, textColor),
                  border: border(PrimaryColor)
                    ,enabledBorder: border(PrimaryColor)
                    ,focusedBorder: border(PrimaryColor)

                ),
              ),
            ),


          ],
        ),
      );
  },
),
    );
  }
}


