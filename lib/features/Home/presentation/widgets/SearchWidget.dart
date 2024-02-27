import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';

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
              child: BackButton(onPressed:()=> context.go("/home"),),
            ),
          backgroundColor: backgroundColored,
          titleTextStyle: PoppinsSemiBold(15, textColorBlack, TextDecoration.none),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),
              onChanged: (value) {
                print(value);
              },

              decoration: InputDecoration(

                suffixIcon: Icon(Icons.search, color: textColorBlack,),
                hintStyle: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),

                hintText: 'Search Activity Name',
              ),
            ),
          )
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Search Page',
              ),
            ],
          ),
        ),),
    );
  }
}
