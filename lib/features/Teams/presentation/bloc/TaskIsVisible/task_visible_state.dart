part of 'task_visible_bloc.dart';
enum Section{
  Details,Attachments,Comments

}
enum Status{Loaded,Loading,Error,Empty,Initial,Changed}
enum TextFieldsTitle {
  Active,Inactive}
enum TextFieldsDescription {
  Active,Inactive}


enum Privacy{
  Primary,Private}
 class TaskVisibleState extends Equatable {
   final bool WillAdded;
   final bool WillDeleted;
   final bool willSearch;
   final bool isUpdated;
final Privacy privacy;
final Section section;
final String image;
final TextFieldsTitle textFieldsTitle;
final TextFieldsDescription textFieldsDescription;
final Status status;


   TaskVisibleState({this.WillAdded=false,this.WillDeleted=false,
      this.willSearch=false,
      this.privacy=Privacy.Primary,
     this.isUpdated=false,

     this.image= "assets/images/jci.png",
     this.status=Status.Initial,

   this.section=Section.Details,
    this.textFieldsTitle=TextFieldsTitle.Inactive,
    this.textFieldsDescription=TextFieldsDescription.Inactive

   });

   TaskVisibleState copyWith({
      Privacy? privacy,
     bool? willSearch,

     String? image,
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
      image: image ?? this.image,
       status: status ?? this.status,



   );
   }

   @override
   // TODO: implement props
   List<Object?> get props => [WillAdded,WillDeleted,section,
      privacy,
     textFieldsTitle,textFieldsDescription,image,status,willSearch,isUpdated];
   }


class TaskVisibleInitial extends TaskVisibleState {
  TaskVisibleInitial();

  @override
  List<Object> get props => [];
}
