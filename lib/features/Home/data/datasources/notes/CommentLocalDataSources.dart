import 'package:dartz/dartz.dart';

import '../../model/CommentModel.dart';


abstract class CommentLocalDataSource{
  Future<Unit> cacheComments(List<ActivityCommentModel> notes,);

  Future<List<ActivityCommentModel>> getComments(String ActivityId, );

}
class CommentLocalDataSourceImpl implements CommentLocalDataSource {
  @override
  Future<Unit> cacheComments(List<ActivityCommentModel> notes) {
    // TODO: implement cacheComments
    throw UnimplementedError();
  }

  @override
  Future<List<ActivityCommentModel>> getComments(String ActivityId) {
    // TODO: implement getComments
    throw UnimplementedError();
  }
}