import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

class SettingsComponent {
  static isProfile(SettingsBools state) {
    return state == SettingsBools.Profile;
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
    , SettingsBools state) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: AnimatedContainer(
        decoration: ProfileComponents.boxDecoration,
        duration: Duration(milliseconds: 800),
     curve: Curves.easeIn,
        padding: paddingSemetricVerticalHorizontal(),
        height: isSwitch ?  mediaQuery.size.width/2.3 : 70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconAndTextInfo(data, title),
                IconButton(
                  onPressed:isSwitch?
                      ()=>context.read<ChangeSboolsCubit>().changeSettings(SettingsBools.Initial):
                      ()=>context.read<ChangeSboolsCubit>().changeSettings(state) ,
                  icon: Icon(isSwitch?Icons.arrow_downward_rounded: Icons.arrow_forward_rounded),
                )
              ],
            ),

            isSwitch ? Expanded(child: SingleChildScrollView(child: body)) : SizedBox()
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
                    decoration: BoxDecoration(
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

  static Widget ColumnActions(BuildContext context,Member member) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
  builder: (context, state) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowAction(context, "Profile", Icons.person,isProfile(state.settings),Profile(context,member),MediaQuery.of(context),SettingsBools.Profile),

              FutureBuilder(future: context.read<localeCubit>().cachedLanguageCode(),
                 builder: (contex,snat) {
                    if(snat.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                   return rowAction(context, "Language (${snat.data})", Icons.language,
                       isLanguage(state.settings),WidgetChangeLanguageWidget(context,MediaQuery.of(context)),MediaQuery.of(context),SettingsBools.Language);
                 }
               ),

          rowAction(context, "Dark Mode", Icons.dark_mode,  isMode(state.settings),Container(),MediaQuery.of(context),SettingsBools.Mode),
          rowAction(context, "Enable Notifications", Icons.notification_important_rounded, isNotification(state.settings),Container(),MediaQuery.of(context),SettingsBools.Notifications),
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
                      child: IconAndTextInfo(Icons.cached, "Clear Cache"),
                    ))),
          ),signoput(context)

        ],
      );
  },
),
    );
  }

  static Padding signoput(BuildContext context) {
    return Padding(
          padding: paddingSemetricVertical(),
          child: InkWell(
              onTap: () {
                context.read<AuthBloc>().add(SignoutEvent());
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
                      Icon(Icons.logout,color: Colors.red,size: 30,),
                      Padding(
                        padding: paddingSemetricHorizontal(),
                        child: Text("Logout",style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),),
                      ),
                    ],
                  ),
                ),
              )),
        );
  }
 static Widget Profile(BuildContext context,Member member){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        Divider(color: textColor,),
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
          child: InkWell(child: IconAndTextInfo(Icons.lock, " Change Password")),
        ),
      ]
    );
  }
static   Widget LanguageButton(BuildContext context,String language,String languageCode,MediaQueryData mediaquery,String flag){
    return GestureDetector(
      onTap: (){
        context.read<localeCubit>().changeLanguage(languageCode);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: paddingSemetricHorizontal(),
            child: SvgPicture.string(flag),
          ),
          Center(child: Text(language,style:  PoppinsNorml(20, textColorBlack),)),
        ],
      ),
    );
  }

  static Widget  WidgetChangeLanguageWidget(BuildContext context,MediaQueryData mediaquery){
    return Column(
      children: [
        Divider(color: textColor,),
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