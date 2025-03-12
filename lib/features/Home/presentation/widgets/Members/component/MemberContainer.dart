import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';

import '../../../../../../core/PrimitiveUser/User.dart';

import 'ProfileImage.dart';

// Assuming you have imports for FormzBloc, Member, MemberImageWidget, etc.

class MemberContainer extends StatelessWidget {

  final User item;

  const MemberContainer({
    Key? key,

    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {
        final ff = state.memberFormz.value ?? User.UserTest();
final users = state.PrivateParticipants;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
          
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorsApp.textColorBlack,width: 2),
          
            ),
            child: Padding(
              padding: paddingSemetricHorizontal(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // MemberImageWidget to show user's image
                  MemberImageWidget(
                    item: item,
                    height: 40,
                    width: 15,
                    bools: true,
                    size: 20,
                  ),
          
          
          
                  // InkWell widget for interactive select button
                  BlocBuilder<ActivityCubit, ActivityState>(
                    builder: (context, stat) {
                      return InkWell(
                        onTap: () {
                          if (stat.userChoice==UserChoice.ONE){
                          context.read<FormzBloc>().add(MemberFormzChanged(
                              memberFormz: item));}
                          else if (stat.userChoice==UserChoice.MULTIPLE){
                            if (state.PrivateParticipants.contains(item)){
                              context.read<FormzBloc>().add(PaticipantsChanged(
                                  particpantOfActivity: item, actionType: ActionImage.DELETE));}
                            else{
                            context.read<FormzBloc>().add(PaticipantsChanged(
                                particpantOfActivity: item, actionType: ActionImage.ADD));
                          }}
                        },
                        child: AnimatedMemberSelectedContainer(
                            mediaQuery: mediaQuery, ff: ff, item: item, particpants: users, userChoice: stat.userChoice,),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedMemberSelectedContainer extends StatelessWidget {
  const AnimatedMemberSelectedContainer({
    super.key,
    required this.mediaQuery,
    required this.ff,
    required this.item,
    required this.particpants,
    required this.userChoice,
  });

  final MediaQueryData mediaQuery;
  final User ff;
  final User item;
  final List<User> particpants;
  final UserChoice userChoice;

  @override
  Widget build(BuildContext context) {
    final isSelected= userChoice==UserChoice.ONE? ff.id == item.id : particpants.contains(item);
    
    return AnimatedContainer(
      width: mediaQuery.size.width / 4,
      height: 40,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: isSelected? PrimaryColor : BackWidgetColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsApp.textColorBlack,width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isSelected ? "Selected".tr(context) : "Select".tr(context),
          style: PoppinsSemiBold(
            14,
           isSelected ? textColorWhite : textColorBlack,
            TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
