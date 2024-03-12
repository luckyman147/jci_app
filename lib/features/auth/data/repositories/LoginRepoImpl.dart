  import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';


import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/LoginRemote.dart';
import 'package:jci_app/features/auth/data/models/MemberLogin/MerberLogin.dart';


import 'package:jci_app/features/auth/domain/entities/Member.dart';


import 'package:jci_app/features/auth/domain/repositories/LoginRepo.dart';


typedef Future<Unit> LogIn();
class LoginRepoImpl implements LoginRepo {

  final LoginRemoteDataSource loginRemoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepoImpl({ required this.loginRemoteDataSource,required this.networkInfo});
  @override



  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> logIn) async {
    if (await networkInfo.isConnected) {
      try {
        await logIn;
        return Right(unit);
      }

      catch (e) {
        print(e);
        return Left(ServerFailure());
      }

    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> LogInWithCredentials(Member loginMember) async {


        final   MemberLogin memberModelLogin=MemberLogin(email: loginMember.email, password: loginMember.password, id: loginMember.id, role: loginMember.role, is_validated: loginMember.is_validated,

          cotisation: loginMember.cotisation, Images: loginMember.Images, firstName: loginMember.firstName, lastName: loginMember.lastName, phone: loginMember.phone, IsSelected: false, Activities: loginMember.Activities


        );
        print("heelo from login repo");
        final message= loginRemoteDataSource.Login(memberModelLogin );
        print(message);
    return  await _getMessage(message);



  }

  @override
  Future<Either<Failure, Map>> LogInWithFacebook() {
    // TODO: implement LogInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map>> LogInWithGoogle() {
    // TODO: implement LogInWithGoogle
    throw UnimplementedError();
  }


  }



