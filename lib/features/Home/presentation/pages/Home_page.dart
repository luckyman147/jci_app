import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLogoutState){
                    context.go('/login');
                  }
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.center,


                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(SignoutEvent());
                            }, child: Text('Signout')),
                        Text('B Page'),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),);
  }
}
