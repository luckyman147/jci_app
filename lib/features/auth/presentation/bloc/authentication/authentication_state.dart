part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.member = MemberSignUp.empty,

  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(MemberSignUp member)
      : this._(status: AuthenticationStatus.authenticated, member: member);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final MemberSignUp member;

  @override
  List<Object> get props => [status, member];
}