import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/auth/presentation/widgets/Functions/Listeners.dart';

import '../../../../core/app_theme.dart';
import '../../../intro/presentation/widgets.global.dart';
import '../bloc/ResetPassword/reset_bloc.dart';
import '../bloc/bool/toggle_bool_bloc.dart';

class PasswordResetSentPage extends StatefulWidget {
  final String email;

  const PasswordResetSentPage({Key? key, required this.email})
      : super(key: key);

  @override
  State<PasswordResetSentPage> createState() => _PasswordResetSentPageState();
}

class _PasswordResetSentPageState extends State<PasswordResetSentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 7), (timer) {
    context.read<ToggleBooleanBloc>().add(const ChangeIsImage1( ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset Email Sent'.tr(context),
          style: PoppinsSemiBold(20, textColorBlack, TextDecoration.none),
        ),
      ),
      body: BlocListener<ResetBloc, ResetPasswordState>(
        listener: (context, state) {
          ListenerRestFunction.Listener(state, context,widget.email);
          // TODO: implement listener
        },
        child: Center(
          child: Padding(
            padding: paddingSemetricVerticalHorizontal(h: 17.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation)
                => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Padding(
                  padding: paddingSemetricVerticalHorizontal(h: 17.sp),
                  child: Image.asset(
                    state.IsImage1 ? images.mail : images.mailSenti,
                    height: 250.h,
                    width: 250.w,
                  ),
                ),
              );
            },
            ),
                SizedBox(height: 20
),
                Padding(
                  padding: paddingSemetricVerticalHorizontal(),
                  child: RichText(
                    text: TextSpan(
                      style: PoppinsRegular(23, textColorBlack),
                      children: [
                        TextSpan(text: 'A password reset email has been sent to '.tr(context)),
                        TextSpan(
                          text: widget.email,
                          style: PoppinBold(24, PrimaryColor, TextDecoration.underline),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ).animate(
                  effects: [
                    FadeEffect(duration: 500.milliseconds),
                  ],
                ),
                Padding(
                  padding:paddingSemetricVerticalHorizontal(),
                  child: Text('Please check your inbox and follow the instructions.'.tr(context),
                    style: PoppinsRegular(23, textColorBlack),
                  ),
                ).animate(
                  effects: [
                    FadeEffect(duration: 500.milliseconds),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: paddingSemetricVerticalHorizontal(h: .2.sp),
                  child: Container(
                    width: double.infinity,
                    height: 66.h,
                    decoration: BoxDecoration(
                      color: ColorsApp.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                          color: ColorsApp.textColorBlack, width: 2.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          // Navigate back to login screen or another desired screen
                          context.go('/login');
                        },
                        child: Center(
                          child: Text('Return'.tr(context),
                            style: PoppinsSemiBold(
                                24, textColorWhite, TextDecoration.none),
                          ),
                        )),
                  ).animate(
                    effects: [
                      FadeEffect(duration: 500.milliseconds),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}