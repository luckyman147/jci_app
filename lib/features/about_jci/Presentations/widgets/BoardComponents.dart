
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/about_jci/Domain/entities/BoardRole.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import '../../../../core/app_theme.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';


import '../../Domain/entities/Post.dart';
import '../../Domain/useCases/BoardUseCases.dart';
import '../bloc/ActionJci/action_jci_cubit.dart';
import '../bloc/Board/BoardBloc/boord_bloc.dart';
import '../bloc/Board/YearsBloc/years_bloc.dart';
import 'BoardImpl.dart';

class BoardComponents{
  static BlocBuilder<YearsBloc, YearsState> AlertAddBoard(List<String> yearsList) {
    return BlocBuilder<YearsBloc, YearsState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Add Board ', style: PoppinsRegular(16, textColorBlack)),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: BoardGridBuilder(yearsList, state),
          ),
          actions: actionsBoard(context, state),
        );
      },
    );
  }

  static BlocBuilder<YearsBloc, YearsState> AddPositionWidget(PageController pageController,TextEditingController name_controller) {
    return BlocBuilder<YearsBloc, YearsState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2 ,
          child: BlocBuilder<ActionJciCubit, ActionJciState>(
  builder: (context, ste) {
    return PageView.builder(
      scrollBehavior: ScrollBehavior(),

            scrollDirection: Axis.vertical,
              controller: pageController,
itemCount: 2,
              onPageChanged: (int page) {
context.read<ActionJciCubit>().changePageNum(page);

              },
            itemBuilder: (context,index) {
              if (ste.pageNum == 0){
              return AddPositionColumn(context, state);}
              else{
                return AddNewRoleWidget(context,state,name_controller);
              }
            }
          );
  },
),
        );
      },
    );
  }

  static Column AddPositionColumn(BuildContext context, YearsState state) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(

              padding: paddingSemetricHorizontal(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      'Add Position',

                      style:PoppinsSemiBold(MediaQuery.of(context).devicePixelRatio*6, textColorBlack, TextDecoration.none)
                  ),
                  // Space between text and other widgets

                ],
              ),
            ),

            BoardImpl.GetBoardRolesComponent(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: BoardComponents.ButtomActin(context,() {
                  if (JCIFunctions.objectExistsInList(state.roles, state.newrole['role'])==true){
                    final Pos=PostField(year: state.year, role: (state.newrole['role'] as BoardRole).id, assignTo: null, id: null);

                    context.read<YearsBloc>().add(AddPosition(postField: Pos));
                    Navigator.pop(context);
                  }

                },"Add Position",PrimaryColor,textColorWhite,JCIFunctions.objectExistsInList(state.roles, state.newrole['role'])),
              ),
            ),
          ],
        );
  }


  static List<Widget> actionsBoard(BuildContext context, YearsState state) {
    return [
      ElevatedButton(

        onPressed: () {
          Navigator.pop(context); // Close dialog
        },
        child: Text(
          'Cancel',
          style: PoppinsSemiBold(16, textColor, TextDecoration.none),
        ),
      ), ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor),
        ),
        onPressed: () {
          context.read<BoordBloc>().add(AddBoardEvent(year: state.cloneyear));
          //context.read<YearsBloc>().add(ChangeCloneYear(year:""));
          Navigator.pop(context); // Close dialog

          // Close dialog
        },
        child: Text(
          'Submit',
          style: PoppinsSemiBold(16, textColorWhite, TextDecoration.none),
        ),
      ),
    ];
  }

  static GridView BoardGridBuilder(List<String> yearsList, YearsState state) {
    return GridView.builder(
      gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: yearsList.length, // 5 years with 3 rows per year
      itemBuilder: (context, index) {

        return InkWell(

          onTap: () {
            if (JCIFunctions.stringExistsOrselectedInList(state.years, yearsList[index], )==false){
              context.read<YearsBloc>().add(ChangeCloneYear(year:yearsList[index]));
            }
            // Close dialog and pass selected year
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: textColor),
              borderRadius: BorderRadius.circular(10),
              color: state.cloneyear==yearsList[index]?PrimaryColor:Colors.transparent,
            ),
            child: Center(
              child: Text(
                '${yearsList[index]}',
                style: PoppinsRegular(16, JCIFunctions.stringExistsOrselectedInList(state.years, yearsList[index],)?textColor:state.cloneyear==yearsList[index]?textColorWhite:textColorBlack, ),
              ),
            ),
          ),
        );
      },
    );
  }
  static Widget NewRolesGridprioritys(List<BoardRole>list) {

    return BlocBuilder<YearsBloc, YearsState>(
  builder: (context, state) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: 3, // Replace with your list length
      itemBuilder: (context, index) {
        return Padding(
          padding: paddingSemetricVertical(),
          child: InkWell(
              onTap: () {


                JCIFunctions.ChangeRoleFunction(state, list[index], context);
                // Close dialog and pass selected year
              },
              child: CardComponet(JCIFunctions.isSelected(state, list[index]), list[index], context,list[index].name.tr(context))),
        );
      },
    );
  },
);
  }



  static AlertDialog alertDialogDelete(String year,String role, BuildContext context,TypeDelete type,String text) {
  return AlertDialog(
    title: Text('Delete $text',style: PoppinsRegular(15, textColorBlack),),
    content: Text('Are you sure you want to delete this ${type.name}?',style: PoppinsLight(16, textColor, ),),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('No',style: PoppinsRegular(17, textColor, ),),
      ),
      TextButton(
        onPressed: () {
          if (type==TypeDelete.Role){
            context.read<YearsBloc>().add(RemoveRole(roleid:role ));
            Navigator.of(context).pop();


          }
else{
          context.read<BoordBloc>().add(RemoveBoardEvent(year: year));}
          Navigator.of(context).pop();
          context.read<ActionJciCubit>().changePageNum(0);

        },
        child: Text('Delete',style: PoppinsRegular(17, PrimaryColor),),
      ),
    ],
  );
}
 static  SizedBox SubmitAddMemberButton(ActionJciState state,Post post,BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height/15,
      child: BlocBuilder<YearsBloc, YearsState>(
        builder: (context, ste) {
          return BoardComponents.ButtomActin(context,
                  () {
                JCIFunctions.AddMemberFun(ste, state, context,post.id );
              }
              , "Assign", PrimaryColor, textColorWhite,true);
        },
      ),
    );
  }
  static Widget showPosWidget(BuildContext context,Post post, TextEditingController _searchController) {


    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/1.7, // Adjust the height as per your requirement
    child: BlocBuilder<ActionJciCubit, ActionJciState>(
      builder: (context, state) {
        return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [


    Column(
      children: [
        buildsSearchNumber(context, _searchController),
          BoardImpl.AssignToWidget(post.id),
      ],
    ),
        JCIFunctions.IsNotEmpty(state.member)?

        Padding(
          padding: paddingSemetricVerticalHorizontal(v: 10),
          child: SubmitAddMemberButton(state,post,context),
        ):
      RowPostAwction(context, post),
    ],);
      },
    ),

    );


  }


  static ElevatedButton ButtomActin( BuildContext context,Function () onTAp,String text,Color color,Color Textcolor,bool isactive) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: isactive?color:textColorWhite,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isactive?color:textColorWhite, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          onTAp();
        },
        child: Text(
          '$text', style: PoppinsRegular(16.0,
            !isactive?textColor:
            Textcolor),)
    );
  }

  static  Padding buildsSearchNumber(BuildContext context, TextEditingController _searchController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value){
          if (value.isEmpty) {
            context.read<MembersBloc>().add(GetAllMembersEvent());

          }
          if (value.length>2){
          context.read<MembersBloc>().add(GetMemberByNameEvent(name: value));}
        },
        decoration: InputDecoration(

          labelText: 'Search for member name',
          prefixIcon: Icon(Icons.search),
          labelStyle: PoppinsRegular(14.0, textColor),
          border: border(textColorBlack),
          focusedBorder: border(PrimaryColor),
          enabledBorder: border(PrimaryColor),
        ),
      ),
    );
  }
  static Widget RowPostAwction(BuildContext context, Post post) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: BlocBuilder<YearsBloc, YearsState>(
  builder: (context, state) {
    return Container(

        decoration: boxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:post.assignTo!=null&&post.assignTo[0].id.isNotEmpty? MainAxisAlignment.spaceAround:MainAxisAlignment.center,
            children:[

          Visibility(
            visible: post.assignTo!=null&&post.assignTo[0].id.isNotEmpty,

            child: buildCircularIconButton(Icons.close, () {
          final Pos=PostField(year: "", role: post.role, assignTo: post.assignTo[0].id, id: post.id);
          context.read<BoordBloc>().add(RemoveMemberEvent( postField: Pos));
          Navigator.pop(context);
            }, "Delete member ", context)),
          buildCircularIconButton(Icons.delete_rounded, () {
            final Pos=PostField(year: state.year, role: post.role, assignTo: post.assignTo[0].id, id: post.id);

            context.read<YearsBloc>().add(RemovePosition(post: Pos));
            Navigator.pop(context);
          }, "Delete  Position", context)
            ]
          ),
        ),
      );
  },
),
    );
  }

  static BoxDecoration boxDecoration() {
    return BoxDecoration(
gradient:const  LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [backgroundColored, backgroundColored]),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3), // Negative offset to position shadow above the container
          ),
        ],

        borderRadius: BorderRadius.circular(15),
      );
  }

static  Widget buildCircularIconButton(IconData iconData, VoidCallback onPressed,String text,BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: textColorBlack, // You can change the color as per your requirement
                width: 2.0,
              ),
              color: textColorWhite, // You can change the color as per your requirement
            ),
            child: Icon(
              iconData,
              color: textColorBlack, // You can change the color as per your requirement
              size: 20.0,
            ),
          ),
        ),
        SizedBox(height: 8.0), // Spacer between button and text, adjust as needed
        Text(
          '$text', // Replace with your button text or make it dynamic
          style:PoppinsLight(MediaQuery.of(context).devicePixelRatio*4, textColorBlack),
        ),
      ],
    );
  }
  static Container CardComponet(bool isSelected, BoardRole role, BuildContext context,String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(10),
        color: isSelected? PrimaryColor : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: PoppinsSemiBold(
              MediaQuery.of(context).devicePixelRatio * 5,
              isSelected ? textColorWhite : textColorBlack,
              TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
  static Widget AddNewRoleWidget(BuildContext context,YearsState state,TextEditingController nameController){
    final roles=BoardRole.createBoardRoles();
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headefnewrole(context),
          textfieldnamerole(nameController),

          Expanded(
            child: BoardComponents.NewRolesGridprioritys(roles),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,              child: BoardComponents.ButtomActin(context, (){
                if (JCIFunctions.objectExistsInList(roles, state.newrole['role']) && nameController.text.isNotEmpty){
 final role=BoardRole(name: nameController.text, priority: (state.newrole['role']as BoardRole).priority, id: '');
                  context.read<YearsBloc>().add(AddRoleEvent(role: role));
                  Navigator.pop(context);
                }


              }, "Add new role", PrimaryColor, textColorWhite,JCIFunctions.objectExistsInList(roles, state.newrole['role']) && nameController.text.isNotEmpty),
          )],
      ),
    );
  }

  static Row headefnewrole(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add New role",
                style:PoppinsSemiBold(MediaQuery.of(context).devicePixelRatio*6, textColorBlack, TextDecoration.none)
            
            ),
            Padding(
              padding: paddingSemetricVertical(),
              child: IconButton.outlined(onPressed: (){

                context.read<ActionJciCubit>().changePageNum(0);
              }, icon: Icon(Icons.arrow_upward_sharp,color: textColor,)),
            )
          ],
        );
  }

  static TextFormField textfieldnamerole(TextEditingController controller) {
    return TextFormField(
          style: PoppinsRegular(18, textColorBlack),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Role name';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter  Role name ',
          
            hintStyle: PoppinsRegular(18, textColor),
            border: border(textColor),
            focusedBorder: border(PrimaryColor),
            enabledBorder: border(textColor),
            errorBorder: border(Colors.red),
          ),
        );
  }
}


