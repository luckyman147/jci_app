import 'package:jci_app/features/Home/domain/entities/Note.dart';

class NoteModel extends Note{
  NoteModel({required super.title, required super.content, required super.date, required super.owner, required super.id});

  factory NoteModel.fromJson(Map<String, dynamic> json){
    return NoteModel(
      title: json['title']??"",
      content: json['content']??"",
      date: DateTime.now(),
      owner: json['owner'], id: json['id']??json['_id']
    );
  }
  factory NoteModel.fromEntity(Note note){
    return NoteModel(
      title: note.title,
      content: note.content,
      date: note.date,
      owner: note.owner, id: note.id
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'owner': owner

    };
  }
}