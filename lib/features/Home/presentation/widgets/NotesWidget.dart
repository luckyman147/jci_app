import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/notesBloc/notes_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskComponents.dart';

import '../../../Teams/presentation/widgets/MembersTeamSelection.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return PageView.builder(
      controller: PageController(),
      itemBuilder: (BuildContext context, int index) {
      if (state.noteIndex==0)
      return buildBlocConsumer();
      else{
        return addnoTes(titleController,contentController);
      }
    },
      itemCount: 2,
      onPageChanged: (value){
      context.read<ActivityCubit>().changeNotePage(value);
      },
    );
  },
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
  if (state.notes.isEmpty) {
    return  Center(child: Text('No Notes',style: PoppinsRegular(17, textColorBlack),));
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

  SizedBox buildNotex(BuildContext context, NotesState state) {
    return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: double.infinity,
    child: Column(
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

            if (index >= state.notes.length) {
              return LoadingWidget();
            } else {
              return Container(
margin: paddingSemetricHorizontal(),
            height: 169,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: textColorBlack,
                width: .5,
              ),
              borderRadius: BorderRadius.circular(10),


            ),
            child:Column(
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
          );
            }
          },
          itemCount: state.hasReachedMax ? state.notes.length : state.notes.length + 1,
          controller: _scrollController, separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10,);
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
                      child: MemberTeamSelection. photo(
                      state.notes[index].owner[0]["Images"],
                          30, 15),
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
                    IconButton.outlined(onPressed: ()=>null, icon: Icon(Icons.edit))

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
                                 ActivityAction.getFirstNWords(state.notes[index].content, 40),
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
  Widget addnoTes(TextEditingController title, TextEditingController content){
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(onPressed: (){
                context.read<ActivityCubit>().changeNotePage(0);
              },),
              Text("${"Add".tr(context)} note",style: PoppinsRegular(16, textColorBlack),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end
                ,            children: [
                IconButton(
                  icon: Icon(Icons.save,color: SecondaryColor,),
                  tooltip: 'Save',
                  onPressed: () {
                    // Handle save action
                    print('Save button pressed');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send,color: PrimaryColor,),
                  tooltip: 'Send',
                  onPressed: () {
                    // Handle send action
                    print('Send button pressed');
                  },
                ),
              ],
              ),
            ],
          )
          ,

          Padding(
            padding: paddingSemetricVerticalHorizontal(),
            child: TextFormField(
              controller: title,
              style: PoppinsRegular(14, textColorBlack),
              decoration: InputDecoration(
                hintText: "Title",

                hintStyle: PoppinsRegular(14, textColorBlack),
                border: border(PrimaryColor)
              ),
            ),
          ),
          Padding(
            padding: paddingSemetricHorizontal(),
            child: TextFormField(
              maxLines: 20,
              maxLength: 1000,
              controller: content,
              style: PoppinsRegular(14, textColorBlack),
              decoration: InputDecoration(
                hintText: "Content",

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
  }
}


