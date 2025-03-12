part of 'task_visible_bloc.dart';

 class TaskVisibleState extends Equatable {
   final bool WillAdded;
   final bool WillDeleted;
   final bool willSearch;
   final bool isUpdated;
final Privacy privacy;
final Section section;
final List<String> images;


final TextFieldsTitle textFieldsTitle;
final TextFieldsDescription textFieldsDescription;
final Status status;


   const TaskVisibleState({this.WillAdded=false,this.WillDeleted=false,
      this.willSearch=false,
      this.privacy=Privacy.Primary,
     this.isUpdated=false,

     this.images=const  [],
     this.status=Status.Initial,

   this.section=Section.Details,
    this.textFieldsTitle=TextFieldsTitle.Inactive,
    this.textFieldsDescription=TextFieldsDescription.Inactive

   });

   TaskVisibleState copyWith({
      Privacy? privacy,
     bool? willSearch,

     List<String>? images,
     bool? WillDeleted,
    bool? WillAdded,
      bool? isUpdated,
    Section? section,
     Status? status,
    TextFieldsTitle? textFieldsTitle,
    TextFieldsDescription? textFieldsDescription

   }) {
   return TaskVisibleState(
      privacy: privacy ?? this.privacy,
      WillDeleted: WillDeleted ?? this.WillDeleted,
      WillAdded: WillAdded ?? this.WillAdded,
      section: section ?? this.section,
      isUpdated: isUpdated ?? this.isUpdated,
      willSearch: willSearch ?? this.willSearch,
      textFieldsTitle: textFieldsTitle ?? this.textFieldsTitle,
      textFieldsDescription: textFieldsDescription ?? this.textFieldsDescription,
      images: images ?? this.images,
       status: status ?? this.status,



   );
   }

   @override
   // TODO: implement props
   List<Object?> get props => [WillAdded,WillDeleted,section,
      privacy,
     textFieldsTitle,textFieldsDescription,images,status,willSearch,isUpdated];
   }


class TaskVisibleInitial extends TaskVisibleState {
  const TaskVisibleInitial();

  @override
  List<Object> get props => [];
}
