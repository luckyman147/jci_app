import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/auth/presentation/widgets/PinForm.dart';

import '../../../../core/widgets/backbutton.dart';
import '../widgets/Text.dart';

class Pincode extends StatefulWidget {
final String? email;
  const Pincode({Key? key, required this.email}) : super(key: key);

  @override
  State<Pincode> createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {

  final formKey = GlobalKey<FormState>();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  @override
  Widget build(BuildContext context) {  print("email from pin ${widget.email}");
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: Column(

        children:[

          Backbutton(mediaquery, context, '/forget'),
SizedBox(
    width: mediaquery.size.width/1.32,

    child: Text ('Verification Code'.tr(context), style: PoppinsSemiBold(30, textColorBlack,TextDecoration.none),)),
SizedBox(
    width: mediaquery.size.width/1.32,

    child: Text ('We have  sent the code verification'.tr(context), style: PoppinsLight(mediaquery.size.width/22, ThirdColor),)),

          SizedBox(
            width: mediaquery.size.width/1.32,

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: mediaquery.size.height /22 ),
                  child: Align(
                      alignment:    Alignment.topLeft,
                      child: Label(text: "Pincode".tr(context), size: 20)),
                ),
                PinForm(controller1: _controller1, formKey: formKey, controller2: _controller2, controller3: _controller3, controller4: _controller4),
              ],
            ),
          ),


          Padding(
            padding:  EdgeInsets.only(top: mediaquery.size.height/27),
            child: SizedBox(
              width: mediaquery.size.width/1.32,

              child: InkWell(
                onTap:  () {
                      // Do something with the entered numbers
                      final numbers = [
                      _controller1.text,
                      _controller2.text,
                      _controller3.text,
                      _controller4.text,
                      ];
                      print('Entered Numbers: $numbers');
                      context.go('/reset/${widget.email}');
                },
                child: Container(
                  width: double.infinity,
                  height: 66,
                      decoration: decoration,
                  child:  Center(child: Text('Submit'.tr(context),style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none) ,)),
                ),
              ),
            ),
          ),


        ]
      ),
    );
  }
}
