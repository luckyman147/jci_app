import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';

class CreateUpdateActivityPage extends StatefulWidget {
  const CreateUpdateActivityPage({Key? key}) : super(key: key);

  @override
  State<CreateUpdateActivityPage> createState() => _CreateUpdateActivityPageState();
}

class _CreateUpdateActivityPageState extends State<CreateUpdateActivityPage> {
  final TextEditingController _namecontroller=TextEditingController();


  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final todayDate=getTodayDateTime();
    final TextEditingController _BeginDateController=TextEditingController(text: DateFormat("MMM,dd,yyyy h:mm a").format(todayDate));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[

                    firstLine(),
                    Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.0),
            child:ImagePicker(mediaQuery),
                    ),
TextfieldNormal("Leader Name", "Leader name here ", _namecontroller),
                TextfieldNormal("Event Name", "Name of event here", _namecontroller),
              Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
          child: SizedBox(
            width: mediaQuery.size.width,
            child:
DateField(LabelText: "Begin Date", SheetTitle: "DAte and Hour of begin", hintTextDate: "Begin Date", hintTexttime: "Begin Time", date: todayDate))),


                Visibility(
                    visible: true,
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),


                      child: InkWell(
                        child: Container(
                          decoration:
                          BoxDecoration(
                            color: PrimaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.calendar_today,color: SecondaryColor,),
                                ),
                                Text("Show End Date",style:PoppinsRegular(mediaQuery.devicePixelRatio*5, textColorBlack)),
                              ],
                            ),
                          ),

                        ),


                                      ),
                    ) ),

                Visibility(
                    visible :false,child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),

                  child: DateField(LabelText: "End Date", SheetTitle: "DAte and Hour of End", hintTextDate: "End Date", hintTexttime: "End Time", date: todayDate),
                    )
                ),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),

  child: DateField(LabelText: "Registration Deadline", SheetTitle: "Registration Date ", hintTextDate: "End Date", hintTexttime: "End Time", date: DateTime.now()),
)




                ,TextfieldNormal("Location", "Location Here", _namecontroller),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Is Paid",style: PoppinsRegular(mediaQuery.devicePixelRatio*6, textColorBlack),),
                          Checkbox(value: true, onChanged: (bool? value) {  },activeColor: PrimaryColor,checkColor: textColorWhite,splashRadius: 13,
                            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))

                            ,),
                        ],
                      ),
                      Visibility(
                          visible: true,
                          child: TextFormField(
                        style: PoppinsNorml(18, textColorBlack),
                 keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusedBorder: border(PrimaryColor),
                            enabledBorder: border(ThirdColor),
                            hintStyle: PoppinsNorml(18, ThirdColor),
                            hintText: "Price"
                        ),
                      ))
                    ],
                  ),
                ),
                TextfieldDescription("Description", "Description Here", _namecontroller),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 18.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Category",style:   PoppinsRegular(18, textColorBlack),),
      SizedBox(
          width: mediaQuery.size.width*1.2,

          child: MyCategoryButtons()),
    ],
  ),
)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstLine()=>    Row(
    children: [
      BackButton(),
      Text("Create",style:PoppinsSemiBold(21, textColorBlack,TextDecoration.none)),
MyDropdownButton()


    ],
  );
  Widget ImagePicker(mediaQuery)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Upload Image",style: PoppinsRegular(19, textColorBlack),),
      InkWell(
        child: Container(
          height: 100,
          width:  mediaQuery.size.width*0.88,
          color: PrimaryColor.withOpacity(.1),
          child: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo,size: 40,color: PrimaryColor,),
                Text("Add Image",style: PoppinsRegular(19, PrimaryColor),)
              ],


            ),
          ),
        ),
      ),
    ],
  );
  Widget TextfieldNormal(String name,String HintText,TextEditingController controller)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,style: PoppinsRegular(18, textColorBlack),)
        ,TextFormField(
          style: PoppinsNorml(18, textColorBlack),

          controller: controller,
          decoration: InputDecoration(
            focusedBorder: border(PrimaryColor),
            enabledBorder: border(ThirdColor),
              hintStyle: PoppinsNorml(18, ThirdColor),
              hintText: HintText
          ),
        ),
      ],
    ),
  ); Widget TextfieldDescription(String name,String HintText,TextEditingController controller)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,style: PoppinsRegular(18, textColorBlack),)
        ,TextFormField(
          style: PoppinsNorml(18, textColorBlack),
maxLines: null,
keyboardType: TextInputType.multiline,
          controller: controller,

          decoration: InputDecoration(
          focusedBorder: border(PrimaryColor),
          enabledBorder: border(ThirdColor),
              hintStyle: PoppinsNorml(18, ThirdColor),
              hintText: HintText
          ),
        ),
      ],
    ),
  );
  DateTime getTodayDateTime() {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day,today.hour,today.minute);
    return dateOnly;
  }








}
Widget chooseDate(DateTime todayDate,MediaQueryData mediaQuery
    , String Format

    ,Function() onTap,String text)=>InkWell(
  onTap: ()async {
    onTap();
  },
  child: Container(
    width: mediaQuery.size.width,


    decoration:BoxDecoration(
        border: Border.all(color: textColorBlack)
        ,borderRadius: BorderRadius.circular(15)
    ),
    child:Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,style: PoppinsLight(18, textColorBlack,),),
          Text( DateFormat(Format).format(todayDate),style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none),),
        ],
      ),
    ),


  ),
);
class DateField extends StatelessWidget {
  final String  LabelText ;
  final String SheetTitle;
  final String hintTextDate;
  final String hintTexttime;
  final DateTime date ;

  const DateField({Key? key, required this.LabelText, required this.SheetTitle, required this.hintTextDate, required this.hintTexttime, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Text(LabelText,style: PoppinsRegular(18, textColorBlack),),
          InkWell(
            onTap: (){
              showModalBottomSheet(context: context, builder: (ctx)=>
                  SingleChildScrollView(
                    child: SizedBox(height: mediaQuery.size.height / 3,width: double.infinity,



                      child:Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(SheetTitle,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, PrimaryColor, TextDecoration.none),),
                            chooseDate(date, mediaQuery,"MMM,dd,yyyy", () => null, hintTextDate),
                            chooseDate(date, mediaQuery,"hh:mm a", () => null, hintTexttime),
                          ],

                        ),
                      ) ,),
                  )

              );
            },
            child: Container(
              width: mediaQuery.size.width ,

              decoration: BoxDecoration(
                  border: Border.all(width: 3,color:  ThirdColor),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("${date}",style:PoppinsRegular(19, textColorBlack, ) ,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

