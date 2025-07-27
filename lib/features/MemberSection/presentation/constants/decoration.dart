
     import '../../../Home/Activity_Global.dart';

final boxDecoration = BoxDecoration(
  border: Border.all(color: textColor,width: 1),
  borderRadius: BorderRadius.circular(13),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 1,
      offset: const Offset(0, 1), // changes position of shadow
    ),
  ],
);