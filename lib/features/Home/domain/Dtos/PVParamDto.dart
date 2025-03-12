import '../entities/PVEntity/PV.dart';

class PvParamDto{
  final  PV pvParam;
  final String ActivityId;
  final String? PVId;



  PvParamDto({required this.PVId ,required this.pvParam, required this.ActivityId});}