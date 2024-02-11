
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("settings")),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child:
            BlocConsumer<localeCubit, LocaleState>(listener: (context, state) {
              if (state is ChangeLocalState) {
        context.go('Intro');
              }
            }, builder: (context, state) {
              if (state is ChangeLocalState) {
                return DropdownButton<String>(
                  value: state.locale.languageCode,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: ["fr", 'en']
                      .map((String items) =>
                      DropdownMenuItem(value: items, child: Text(items)))
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      //* BlocProvider.of<LocaleCubit>(context).changeLanguage(value);
                      context.read<localeCubit>().changeLanguage(value);
                    }
                  },
                );
              }
              return SizedBox();
            }),
          )),
    );
  }
}
