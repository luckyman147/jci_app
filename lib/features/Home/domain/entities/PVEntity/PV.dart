    import 'package:jci_app/core/Abstractions/Entity.dart';

class PV extends Entity<String>{

  final String title;

  final DateTime date;
  final String link;
  final String Extension;

  PV({super.id, super.createdAt, super.createdBy, super.lastModified, super.lastModifiedBy, required this.title, required this.date, required this.link, required this.Extension});
PV ToEntity() {
    return PV(
      title: title,
      date: date,
      link: link,
      Extension: Extension,
    );
  }
  PV fromLink(String links) {
    return PV(
      title: title,

      date: date,
      link: links,
      Extension: Extension,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props =>  [id,title,date,link,Extension];

  @override
  // TODO: implement stringify
  bool? get stringify =>
      throw UnimplementedError()

  ;}