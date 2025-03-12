import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../core/app_theme.dart';
import '../bloc/Members/members_bloc.dart';
import '../widgets/member/MemberImpl.dart';

class TextFieldComponets{


  static Widget TextfieldNum(String name, String hintText,
      TextEditingController controller, Function(String) onChanged,BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            autofocus: true,
            autocorrect: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              onChanged(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            style: PoppinsRegular( 18, textColorBlack),
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only digits allowed
              LengthLimitingTextInputFormatter(8), // Limit to 8 characters
            ],
            decoration: decorationTextField(null,"Pin",context),
          ),
        ],
      ),
    );
  }

  static Widget dropNumber()=> Expanded(

    child: DropdownButton<String>(
      value: '+216', // Initially selected value
      onChanged: (String? newValue) {
        // Handle dropdown value change
        // You can use newValue if needed
      },
      items: <String>['+216',"+88"] // Dropdown items
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
          .toList(),
    ),
  );

  static Widget MembersWidgetOnlyName(MediaQueryData mediaQuery, BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 60,
            width: mediaQuery.size.width * 0.8,
            child: TextField(

                onChanged: (value) {
                  context.read<MembersBloc>().add(GetMemberByNameEvent( name: value));
                },
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.dark,


                style: PoppinsRegular( 18, textColorBlack),

                decoration:InputDecoration(
                  hintText: "${"Search".tr(context)} ${"Member".tr(context)}",

                  hintStyle: PoppinsRegular( 15, textColor),
                  suffixIcon: const Icon(Icons.search),
                  prefixIcon: IconButton(onPressed: () {

                    showModalBottomSheet(context: context, builder: (context){
                      return Container(

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${"Sort".tr(context)} ${"By".tr(context)}:",style: PoppinsRegular( 20, textColorBlack),),
                              const SizedBox(height: 10,),
                              BuildSortMember(context,"Membership".tr(context),()=>null,true),
                              BuildSortMember(context,"Points",()=>null,false),
                              BuildSortMember(context,"Role",()=>null,false),
                            ],
                          ),
                        ),
                      );
                    });

                  }, icon: const Icon(Icons.filter_alt),),

                  border:border(PrimaryColor),
                  focusedBorder: border(PrimaryColor),
                  enabledBorder: border(PrimaryColor),
                )

            )),
        const SizedBox(height: 10,),
        SizedBox(
            height: 10,
            width: mediaQuery.size.width * 0.8,

            child: const Divider()),
        MemberImpl.       MembersAdminWidget(mediaQuery),
      ],
    );
  }

  static Padding BuildSortMember(BuildContext context,String sort,Function() onChanged,bool isSelected) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: PrimaryColor)
        ),
        style: ListTileStyle.drawer,

        selected:isSelected,
        selectedTileColor: PrimaryColor,
        title: Text("${"By".tr(context)} $sort",style: PoppinsRegular( 18, isSelected?textColorWhite:textColorBlack),),
        onTap: (){
          onChanged();
          Navigator.pop(context);

          //context.read<MembersBloc>().add(GetMemberByNameEvent( name: ""));
        },

      ),
    );
  }


}