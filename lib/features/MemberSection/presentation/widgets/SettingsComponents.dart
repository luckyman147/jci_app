import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';

import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';

import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';

import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import 'package:shimmer/shimmer.dart';

import '../../../../core/strings/app_strings.dart';

import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../../auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

import '../bloc/Members/members_bloc.dart';
import 'BestMembersWidget.dart';

class SettingsComponent {
  static isProfile(SettingsBools state) {
    return state == SettingsBools.Profile;
  }static isMem(SettingsBools state) {
    return state == SettingsBools.Members;
  }
  static isLanguage(SettingsBools state) {
    return state == SettingsBools.Language;
  }
  static isNotification(SettingsBools state) {
    return state == SettingsBools.Notifications;
  }
static isMode(SettingsBools state) {
    return state == SettingsBools.Mode;
  }

  static Widget rowAction(BuildContext context, String title, IconData data,bool isSwitch,Widget body,MediaQueryData mediaQuery
    , SettingsBools state,IconData? iconData,double height,Function() onPressed) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: AnimatedContainer(

        decoration: ProfileComponents.boxDecoration,
        duration: const Duration(milliseconds: 1000),
     curve: Curves.easeIn,
        padding: paddingSemetricVerticalHorizontal(),
        height: isSwitch ?  height: 70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconAndTextInfo(data, title),
                Row(
                  children: [
                    iconData!=null?    Padding(
                      padding: paddingSemetricHorizontal(),
                      child: IconButton(  icon:Icon(iconData),onPressed: (){

                     BestMembersComponent.ShowRankMembers(mediaQuery, context);


                      },),
                    ):const SizedBox(),
                    IconButton(
                      onPressed:isSwitch?
                          ()=>context.read<ChangeSboolsCubit>().changeSettings(SettingsBools.Initial):
                          (){
                        onPressed();
                        context.read<ChangeSboolsCubit>().changeSettings(state);} ,
                      icon: Icon(isSwitch?Icons.arrow_downward_rounded: Icons.arrow_forward_rounded),
                    ),
                  ],
                )
              ],
            ),

            isSwitch ? Expanded(

                child: SingleChildScrollView(child: body)) : const SizedBox()
          ],
        ),
      ),
    );
  }



  static Row IconAndTextInfo(IconData data, String title) {
    return Row(
              children: [
                Container(height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: PrimaryColor,
                      shape: BoxShape.circle,

                    ),
                    child: Icon(data, color: Colors.white, size: 20,)
                ),
                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Text(title,style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),),
                ),
              ],
            );
  }

  static Widget ColumnActions(BuildContext context,Member member,TextEditingController pass,TextEditingController cpass,GlobalKey<FormState> key) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
  builder: (context, state) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowAction(context, "Profile".tr(context), Icons.person,isProfile(state.settings),Profile(context,member,pass,cpass,key),MediaQuery.of(context),SettingsBools.Profile,null,200,(){}),
          MembersAdmin(state),

              Language(context, state),

          //rowAction(context, "Dark Mode".tr(context), Icons.dark_mode,  isMode(state.settings),Container(),MediaQuery.of(context),SettingsBools.Mode),
         // rowAction(context, "Enable Notifications", Icons.notification_important_rounded, isNotification(state.settings),Container(),MediaQuery.of(context),SettingsBools.Notifications),
          Padding(
            padding: paddingSemetricVertical(),
            child: InkWell(
                onTap: () {
                  //context.read<AuthBloc>().add(SignoutEvent());
                },

                child: Container(
                    decoration: ProfileComponents.boxDecoration,
                    height: 70,
                    child: Padding(
                      padding: paddingSemetricHorizontal(),
                      child: IconAndTextInfo(Icons.cached, "Clear Cache".tr(context)),
                    ))),
          ),signoput(context),

        ],
      );
  },
),
    );
  }

  static FutureBuilder<String?> Language(BuildContext context, ChangeSboolsState state) {
    return FutureBuilder(future: context.read<localeCubit>().cachedLanguageCode(),
               builder: (contex,snat) {
                  if(snat.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(baseColor:Colors.grey[300]!, highlightColor: Colors.grey[300]!, child: const SizedBox(
                      height: 30,
                      width: 10,
                      
                    ));
                  }

                 return rowAction(context, "Language (${snat.data})", Icons.language,
                     isLanguage(state.settings),WidgetChangeLanguageWidget(context,MediaQuery.of(context)),MediaQuery.of(context),SettingsBools.Language,null,200,(){});
               }
             );
  }

  static FutureBuilder<bool> MembersAdmin(ChangeSboolsState state) {
    return FutureBuilder(
          builder: (context,snap) {
            if(snap.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            }
          else if (snap.data != null) {
            if (snap.data==true) {
              return rowAction(
                  context,
                  "Members".tr(context),
                  Icons.people,
                  isMem(state.settings),
                  ProfileComponents.MembersWidgetOnlyName(
                      MediaQuery.of(context),context),
                  MediaQuery.of(context),
                  SettingsBools.Members,Icons.emoji_events,300,()=>    context.read<MembersBloc>().add(const GetAllMembersEvent(true))
              );
            }
          else{return const  SizedBox();}
          }
          else{return const SizedBox();}

          }, future: FunctionMember.isAdminAndSuperAdmin(),
        );
  }

  static Padding signoput(BuildContext context) {
    return Padding(
          padding: paddingSemetricVertical(),
          child: InkWell(
              onTap: () {
                context.read<AuthBloc>().add(const SignoutEvent());
                context.go("/login");
              },

              child: Padding(
                padding: paddingSemetricHorizontal(),
                child: Container(
                  decoration: ProfileComponents.boxDecoration,
                  padding: paddingSemetricVerticalHorizontal(),
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                  const     Icon(Icons.logout,color: Colors.red,size: 30,),
                      Padding(
                        padding: paddingSemetricHorizontal(),
                        child: Text("Logout".tr(context),style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),),
                      ),
                    ],
                  ),
                ),
              )),
        );
  }
 static Widget Profile(BuildContext context,Member member,TextEditingController password,TextEditingController cpass,GlobalKey<FormState> key ){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
     const    Divider(color: textColor,),
        Padding(
          padding: paddingSemetricVertical(),
          child: InkWell(
              onTap: () async {

                context.go('/modifyUser?user=${jsonEncode(MemberModel.fromEntity(member).toJson())}');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              },
              child: IconAndTextInfo(Icons.edit, " Edit Profile")

          ),
        ),
        Padding(
          padding: paddingSemetricVertical(),
          child: InkWell(
              onTap: (){
                changePaswwordWidget(context,password,cpass,key,member);
                
                
              },


              child: IconAndTextInfo(Icons.lock, " Change Password")),
        ),
      ]
    );
  }

 static void changePaswwordWidget(BuildContext context,TextEditingController controller,TextEditingController cPassword,GlobalKey<FormState> key,Member newMember ) {
       showModalBottomSheet(
       showDragHandle: true,
       context: context, builder: (builder){
   return   SizedBox(height: MediaQuery.of(context).size.height,
     width: MediaQuery.of(context).size.width,
       child:Padding(
         padding: paddingSemetricHorizontal(),
         child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
  builder: (context, state) {
    return Form(
      key:key,
      child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
             buildPasswordTextField(controller, state.isObscur, () => context. read<ChangeSboolsCubit>().changeObscur(!state.isObscur), (p0) {
               if (p0 == null || p0.isEmpty) {
                 return 'Please enter password';
               }
               return null;

             }, 'New Password'), buildPasswordTextField(cPassword, state.isObscur, () => context. read<ChangeSboolsCubit>().changeObscur(!state.isObscur), (p0) {
               if (p0 == null || p0.isEmpty) {
                 return 'Please enter password';
               }
               if (p0!=controller.text) {
                 return 'Password does not match';
               }
               return null;

             }, ' Confirm New Password'),
               ProfileComponents.SaveChangesButton(()async{
                 if (key.currentState!.validate()) {
                   final language=await context.read<localeCubit>().cachedLanguageCode();
                   final  Member member=Member(email: newMember.email , password: cPassword.text, id: '', role: '', is_validated: false, cotisation: const [], Images: const [],teams: const [], firstName: '', lastName: '', phone: '', IsSelected: false, Activities: const [], points: 0, objectifs: const [],language: language??'fr', rank: 0, description: '', board: "", PreviousPoints: 0);

                   context.read<ResetBloc>().add(ResetSubmitted( member: member));
                 cPassword.clear();
                  controller.clear();
                   Navigator.pop(context);

                 }
                 else{
                   return;
                 }


               },context),
            ],),
    );
  },
),
       )

     );

   });

 }

 static Widget buildPasswordTextField(TextEditingController controller, bool obscureText, Function() toggleObscure,Function(String?) validator,String text) {
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Text(text, style: PoppinsNorml(16, textColorBlack)),
       TextFormField(
         validator: (value) {
          validator(value);
          return null;
         },
         textInputAction: TextInputAction.next,
         controller: controller,
         style: PoppinsNorml(18, textColorBlack),
         obscureText: obscureText,
         decoration: InputDecoration(
           suffixIcon: IconButton(
             icon: Icon(obscureText ? Icons.remove_red_eye : Icons.visibility_off),
             onPressed: toggleObscure,
           ),
           focusedBorder: border(PrimaryColor),
           enabledBorder: border(PrimaryColor),
           errorBorder: border(Colors.red),

         ),
       ),
     ],
   );
 }
static   Widget LanguageButton(BuildContext context,String language,String languageCode,MediaQueryData mediaquery,String flag){
    return GestureDetector(
      onTap: (){
        context.read<localeCubit>().changeLanguage(languageCode);
        context.read<MemberManagementBloc>().add(ChangeLanguageEvent(language: languageCode));
      },
      child: BlocBuilder<localeCubit, LocaleState>(
  builder: (context, state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: paddingSemetricHorizontal(),
                child: SvgPicture.string(flag),
              ),
              Center(child: Text(language,style:  PoppinsNorml(20, textColorBlack),)),
            ],
          ),
        state.locale == Locale(languageCode) ? const Icon(Icons.check_circle,color: PrimaryColor,) : const SizedBox(),
      ],
    );
  },
),
    );
  }

  static Widget  WidgetChangeLanguageWidget(BuildContext context,MediaQueryData mediaquery){
    return Column(
      children: [
        const Divider(color: textColor,),
        Padding(
          padding: paddingSemetricVertical(),
          child: LanguageButton(context, "English", "en", mediaquery, englishFlag),
        ),
        Padding(
          padding: paddingSemetricVertical(),
          child: LanguageButton(context, "Français", "fr", mediaquery, FrenshFlag),
        ),
      ],
    );
  }



}