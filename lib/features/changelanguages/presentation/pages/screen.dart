
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/strings/app_strings.dart';

import '../bloc/locale_cubit.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocConsumer<localeCubit, LocaleState>(listener: (context, state) {
        if (state is ChangeLocalState) {

        }
      }, builder: (context, state) {
        final mediaquery=MediaQuery.of(context);
        if (state is ChangeLocalState) {
          return Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width:mediaquery.size.width/1.2 ,

                    child: Text("Choose the language",style: PoppinsSemiBold(30, textColorBlack, TextDecoration.none),)),
                Padding(
                  padding:  EdgeInsets.only(top: mediaquery.size.height/30),

                  child: LanguageButton(context, "English", "en", mediaquery,englishFlag)
                  ),

                Padding(
                  padding:  EdgeInsets.symmetric(vertical: mediaquery.size.height/30),
                  child:  LanguageButton(context, "Frensh", "fr", mediaquery, FrenshFlag)
                ),
              ],
            ),
          );
        }
        return SizedBox();
      }),
    );
  }
  Widget LanguageButton(BuildContext context,String language,String languageCode,MediaQueryData mediaquery,String flag){
    return GestureDetector(
      onTap: (){
        context.read<localeCubit>().changeLanguage(languageCode);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: mediaquery.size.width/1.2,
        decoration: BoxDecoration(
          color: textColorWhite,

          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: textColorBlack, width: 2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: mediaquery.size.width/33),
              child: SvgPicture.string(flag),
            ),
            Center(child: Text(language,style:  PoppinsNorml(27, textColorBlack),)),
          ],
        ),

      ),
    );
  }
}
