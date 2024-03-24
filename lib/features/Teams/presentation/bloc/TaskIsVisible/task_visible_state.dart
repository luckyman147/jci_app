part of 'task_visible_bloc.dart';
enum Section{
  Details,Attachments,Comments

}
enum TextFieldsTitle {
  Active,Inactive}
enum TextFieldsDescription {
  Active,Inactive}

 class TaskVisibleState extends Equatable {
   final bool WillAdded;
   final bool WillDeleted;

final Section section;
final TextFieldsTitle textFieldsTitle;
final TextFieldsDescription textFieldsDescription;


   TaskVisibleState({this.WillAdded=false,this.WillDeleted=false,

   this.section=Section.Details,
    this.textFieldsTitle=TextFieldsTitle.Inactive,
    this.textFieldsDescription=TextFieldsDescription.Inactive

   });

   TaskVisibleState copyWith({
     bool? WillDeleted,
    bool? WillAdded,
    Section? section,
    TextFieldsTitle? textFieldsTitle,
    TextFieldsDescription? textFieldsDescription

   }) {
   return TaskVisibleState(
      WillDeleted: WillDeleted ?? this.WillDeleted,
      WillAdded: WillAdded ?? this.WillAdded,
      section: section ?? this.section,
      textFieldsTitle: textFieldsTitle ?? this.textFieldsTitle,
      textFieldsDescription: textFieldsDescription ?? this.textFieldsDescription



   );
   }

   @override
   // TODO: implement props
   List<Object?> get props => [WillAdded,WillDeleted,section,textFieldsTitle,textFieldsDescription];
   }


class TaskVisibleInitial extends TaskVisibleState {
  TaskVisibleInitial();

  @override
  List<Object> get props => [];
}
