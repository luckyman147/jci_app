
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../../../core/route/app_router.dart';


@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
            leading: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: BackButton(onPressed:()=> context.pushRoute(HomeRoute()),),
            ),
          backgroundColor: backgroundColored,
          titleTextStyle: PoppinsSemiBold(15, textColorBlack, TextDecoration.none),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),
              onChanged: (value) {

              },

              decoration: InputDecoration(

                suffixIcon: const Icon(Icons.search, color: textColorBlack,),
                hintStyle: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),

                hintText: 'Search Activity Name'.tr(context),
              ),
            ),
          )
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Search Page'.tr(context),
              ),
            ],
          ),
        ),),
    );
  }
}



