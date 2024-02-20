import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_theme.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import 'Compoenents.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Hello ", style: PoppinsRegular(
                              mediaQuery.size.width / 15, Colors.black),),
                          Text("There ", style: PoppinsSemiBold(
                              mediaQuery.size.width / 14, Colors.black,
                              TextDecoration.none),),

                        ],


                      ),
                      const SearchButton(),

                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33),
                    child: MyDropdownButton(),
                  ),

                ]

            ),
          ),
        );
      },
    );
  }
}
