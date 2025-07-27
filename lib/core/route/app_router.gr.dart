// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ActivityDetailsPage]
class ActivityDetailsRoute extends PageRouteInfo<ActivityDetailsRouteArgs> {
  ActivityDetailsRoute({
    Key? key,
    required String activityType,
    required String id,
    required int index,
    List<PageRouteInfo>? children,
  }) : super(
         ActivityDetailsRoute.name,
         args: ActivityDetailsRouteArgs(
           key: key,
           activityType: activityType,
           id: id,
           index: index,
         ),
         initialChildren: children,
       );

  static const String name = 'ActivityDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActivityDetailsRouteArgs>();
      return ActivityDetailsPage(
        key: args.key,
        activityType: args.activityType,
        id: args.id,
        index: args.index,
      );
    },
  );
}

class ActivityDetailsRouteArgs {
  const ActivityDetailsRouteArgs({
    this.key,
    required this.activityType,
    required this.id,
    required this.index,
  });

  final Key? key;

  final String activityType;

  final String id;

  final int index;

  @override
  String toString() {
    return 'ActivityDetailsRouteArgs{key: $key, activityType: $activityType, id: $id, index: $index}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ActivityDetailsRouteArgs) return false;
    return key == other.key &&
        activityType == other.activityType &&
        id == other.id &&
        index == other.index;
  }

  @override
  int get hashCode =>
      key.hashCode ^ activityType.hashCode ^ id.hashCode ^ index.hashCode;
}

/// generated route for
/// [CreateTaskScreen]
class CreateTaskRoute extends PageRouteInfo<CreateTaskRouteArgs> {
  CreateTaskRoute({
    Key? key,
    required Team team,
    required String taskId,
    List<PageRouteInfo>? children,
  }) : super(
         CreateTaskRoute.name,
         args: CreateTaskRouteArgs(key: key, team: team, taskId: taskId),
         initialChildren: children,
       );

  static const String name = 'CreateTaskRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateTaskRouteArgs>();
      return CreateTaskScreen(
        key: args.key,
        team: args.team,
        taskId: args.taskId,
      );
    },
  );
}

class CreateTaskRouteArgs {
  const CreateTaskRouteArgs({
    this.key,
    required this.team,
    required this.taskId,
  });

  final Key? key;

  final Team team;

  final String taskId;

  @override
  String toString() {
    return 'CreateTaskRouteArgs{key: $key, team: $team, taskId: $taskId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateTaskRouteArgs) return false;
    return key == other.key && team == other.team && taskId == other.taskId;
  }

  @override
  int get hashCode => key.hashCode ^ team.hashCode ^ taskId.hashCode;
}

/// generated route for
/// [CreateTeamScreen]
class CreateTeamRoute extends PageRouteInfo<CreateTeamRouteArgs> {
  CreateTeamRoute({Key? key, required Team team, List<PageRouteInfo>? children})
    : super(
        CreateTeamRoute.name,
        args: CreateTeamRouteArgs(key: key, team: team),
        initialChildren: children,
      );

  static const String name = 'CreateTeamRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateTeamRouteArgs>();
      return CreateTeamScreen(key: args.key, team: args.team);
    },
  );
}

class CreateTeamRouteArgs {
  const CreateTeamRouteArgs({this.key, required this.team});

  final Key? key;

  final Team team;

  @override
  String toString() {
    return 'CreateTeamRouteArgs{key: $key, team: $team}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateTeamRouteArgs) return false;
    return key == other.key && team == other.team;
  }

  @override
  int get hashCode => key.hashCode ^ team.hashCode;
}

/// generated route for
/// [CreateUpdateActivityPage]
class CreateUpdateActivityRoute
    extends PageRouteInfo<CreateUpdateActivityRouteArgs> {
  CreateUpdateActivityRoute({
    Key? key,
    required String id,
    required String activity,
    required String work,
    required List<String> particpants,
    List<PageRouteInfo>? children,
  }) : super(
         CreateUpdateActivityRoute.name,
         args: CreateUpdateActivityRouteArgs(
           key: key,
           id: id,
           activity: activity,
           work: work,
           particpants: particpants,
         ),
         initialChildren: children,
       );

  static const String name = 'CreateUpdateActivityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateUpdateActivityRouteArgs>();
      return CreateUpdateActivityPage(
        key: args.key,
        id: args.id,
        activity: args.activity,
        work: args.work,
        particpants: args.particpants,
      );
    },
  );
}

class CreateUpdateActivityRouteArgs {
  const CreateUpdateActivityRouteArgs({
    this.key,
    required this.id,
    required this.activity,
    required this.work,
    required this.particpants,
  });

  final Key? key;

  final String id;

  final String activity;

  final String work;

  final List<String> particpants;

  @override
  String toString() {
    return 'CreateUpdateActivityRouteArgs{key: $key, id: $id, activity: $activity, work: $work, particpants: $particpants}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateUpdateActivityRouteArgs) return false;
    return key == other.key &&
        id == other.id &&
        activity == other.activity &&
        work == other.work &&
        const ListEquality().equals(particpants, other.particpants);
  }

  @override
  int get hashCode =>
      key.hashCode ^
      id.hashCode ^
      activity.hashCode ^
      work.hashCode ^
      const ListEquality().hash(particpants);
}

/// generated route for
/// [ForgetPasswordPage]
class ForgetPasswordRoute extends PageRouteInfo<void> {
  const ForgetPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgetPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgetPasswordPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [IntroductionPage]
class IntroductionRoute extends PageRouteInfo<void> {
  const IntroductionRoute({List<PageRouteInfo>? children})
    : super(IntroductionRoute.name, initialChildren: children);

  static const String name = 'IntroductionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntroductionPage();
    },
  );
}

/// generated route for
/// [LanguagePage]
class LanguageRoute extends PageRouteInfo<void> {
  const LanguageRoute({List<PageRouteInfo>? children})
    : super(LanguageRoute.name, initialChildren: children);

  static const String name = 'LanguageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LanguagePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MemberSectionPage]
class MemberSectionRoute extends PageRouteInfo<MemberSectionRouteArgs> {
  MemberSectionRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
         MemberSectionRoute.name,
         args: MemberSectionRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'MemberSectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MemberSectionRouteArgs>();
      return MemberSectionPage(key: args.key, id: args.id);
    },
  );
}

class MemberSectionRouteArgs {
  const MemberSectionRouteArgs({this.key, required this.id});

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'MemberSectionRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemberSectionRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [ModifyUser]
class ModifyUserRoute extends PageRouteInfo<ModifyUserArgs> {
  ModifyUserRoute({Key? key, required Member member, List<PageRouteInfo>? children})
    : super(
        ModifyUserRoute.name,
        args: ModifyUserArgs(key: key, member: member),
        initialChildren: children,
      );

  static const String name = 'ModifyUser';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ModifyUserArgs>();
      return ModifyUser(key: args.key, member: args.member);
    },
  );
}

class ModifyUserArgs {
  const ModifyUserArgs({this.key, required this.member});

  final Key? key;

  final Member member;

  @override
  String toString() {
    return 'ModifyUserArgs{key: $key, member: $member}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ModifyUserArgs) return false;
    return key == other.key && member == other.member;
  }

  @override
  int get hashCode => key.hashCode ^ member.hashCode;
}

/// generated route for
/// [Objectionable]
class ObjectifformpageRoute extends PageRouteInfo<ObjectifformpageArgs> {
  ObjectifformpageRoute({
    Key? key,
    required String MemberId,
    required ObjectiveEvent event,
    Objectif? obj,
    List<PageRouteInfo>? children,
  }) : super(
         ObjectifformpageRoute.name,
         args: ObjectifformpageArgs(
           key: key,
           MemberId: MemberId,
           event: event,
           obj: obj,
         ),
         initialChildren: children,
       );

  static const String name = 'Objectifformpage';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ObjectifformpageArgs>();
      return Objectifformpage(
        key: args.key,
        MemberId: args.MemberId,
        event: args.event,
        obj: args.obj,
      );
    },
  );
}

class ObjectifformpageArgs {
  const ObjectifformpageArgs({
    this.key,
    required this.MemberId,
    required this.event,
    this.obj,
  });

  final Key? key;

  final String MemberId;

  final ObjectiveEvent event;

  final Objectif? obj;

  @override
  String toString() {
    return 'ObjectifformpageArgs{key: $key, MemberId: $MemberId, event: $event, obj: $obj}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ObjectifformpageArgs) return false;
    return key == other.key &&
        MemberId == other.MemberId &&
        event == other.event &&
        obj == other.obj;
  }

  @override
  int get hashCode =>
      key.hashCode ^ MemberId.hashCode ^ event.hashCode ^ obj.hashCode;
}

/// generated route for
/// [ObjectifsPage]
class ObjectifsRoute extends PageRouteInfo<ObjectifsRouteArgs> {
  ObjectifsRoute({
    Key? key,
    required Member member,
    required MemberManagementState state,
    List<PageRouteInfo>? children,
  }) : super(
         ObjectifsRoute.name,
         args: ObjectifsRouteArgs(key: key, member: member, state: state),
         initialChildren: children,
       );

  static const String name = 'ObjectifsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ObjectifsRouteArgs>();
      return ObjectifsPage(
        key: args.key,
        member: args.member,
        state: args.state,
      );
    },
  );
}

class ObjectifsRouteArgs {
  const ObjectifsRouteArgs({
    this.key,
    required this.member,
    required this.state,
  });

  final Key? key;

  final Member member;

  final MemberManagementState state;

  @override
  String toString() {
    return 'ObjectifsRouteArgs{key: $key, member: $member, state: $state}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ObjectifsRouteArgs) return false;
    return key == other.key && member == other.member && state == other.state;
  }

  @override
  int get hashCode => key.hashCode ^ member.hashCode ^ state.hashCode;
}

/// generated route for
/// [PasswordResetSentPage]
class PasswordResetSentRoute extends PageRouteInfo<PasswordResetSentRouteArgs> {
  PasswordResetSentRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
         PasswordResetSentRoute.name,
         args: PasswordResetSentRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'PasswordResetSentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PasswordResetSentRouteArgs>();
      return PasswordResetSentPage(key: args.key, email: args.email);
    },
  );
}

class PasswordResetSentRouteArgs {
  const PasswordResetSentRouteArgs({this.key, required this.email});

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'PasswordResetSentRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PasswordResetSentRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [ResetPasswordRoute]
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordArgs> {
  ResetPasswordRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
    ResetPasswordRoute.name,
         args: ResetPasswordArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'ResetPassword';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordArgs>();
      return ResetPassword(key: args.key, email: args.email);
    },
  );
}

class ResetPasswordArgs {
  const ResetPasswordArgs({this.key, required this.email});

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResetPasswordArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchPage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({
    Key? key,
    required Member member,
    List<PageRouteInfo>? children,
  }) : super(
         SettingsRoute.name,
         args: SettingsRouteArgs(key: key, member: member),
         initialChildren: children,
       );

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SettingsRouteArgs>();
      return SettingsPage(key: args.key, member: args.member);
    },
  );
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key, required this.member});

  final Key? key;

  final Member member;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key, member: $member}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SettingsRouteArgs) return false;
    return key == other.key && member == other.member;
  }

  @override
  int get hashCode => key.hashCode ^ member.hashCode;
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    Key? key,
    String? email,
    String? name,
    List<PageRouteInfo>? children,
  }) : super(
         SignUpRoute.name,
         args: SignUpRouteArgs(key: key, email: email, name: name),
         initialChildren: children,
       );

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpRouteArgs>(
        orElse: () => const SignUpRouteArgs(),
      );
      return SignUpPage(key: args.key, email: args.email, name: args.name);
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({this.key, this.email, this.name});

  final Key? key;

  final String? email;

  final String? name;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, email: $email, name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignUpRouteArgs) return false;
    return key == other.key && email == other.email && name == other.name;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode ^ name.hashCode;
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [TeamDetailsScreen]
class TeamDetailsRoute extends PageRouteInfo<TeamDetailsRouteArgs> {
  TeamDetailsRoute({
    Key? key,
    required String id,
    required int index,
    List<PageRouteInfo>? children,
  }) : super(
         TeamDetailsRoute.name,
         args: TeamDetailsRouteArgs(key: key, id: id, index: index),
         initialChildren: children,
       );

  static const String name = 'TeamDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TeamDetailsRouteArgs>();
      return TeamDetailsScreen(key: args.key, id: args.id, index: args.index);
    },
  );
}

class TeamDetailsRouteArgs {
  const TeamDetailsRouteArgs({this.key, required this.id, required this.index});

  final Key? key;

  final String id;

  final int index;

  @override
  String toString() {
    return 'TeamDetailsRouteArgs{key: $key, id: $id, index: $index}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeamDetailsRouteArgs) return false;
    return key == other.key && id == other.id && index == other.index;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode ^ index.hashCode;
}
