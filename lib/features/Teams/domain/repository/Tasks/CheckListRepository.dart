import 'package:dartz/dartz.dart';

import '../../../../../core/error/Failure.dart';
import '../../entities/Checklist.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, CheckList>> addChecklist(String teamId, String taskId, String name);
  Future<Either<Failure, List<CheckList>>> fetchChecklists( String taskId, String name);
  Future<Either<Failure, Unit>> updateChecklist(

      String teamId,
      String taskId,
      String checklistId,
      CheckList checklist,
      );
  Future<Either<Failure, Unit>> updateChecklistName(String teamId,String taskId, String checklistId, String name);
  Future<Either<Failure, Unit>> updateChecklistStatus(String teamId,String taskId, String checklistId, bool isCompleted);
  Future<Either<Failure, Unit>> deleteChecklist(String teamId, String tasKId,String checklistId);
}
