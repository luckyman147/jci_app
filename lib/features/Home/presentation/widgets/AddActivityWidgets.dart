
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/app_theme.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';
import 'Compoenents.dart';
import 'Functions.dart';

Widget AddEndDateButton(mediaQuery) => BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: InkWell(
            onTap: () {

              context
                  .read<VisibleBloc>()
                  .add(VisibleEndDateToggleEvent(!state.isVisible));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.calendar_today,
                        color: SecondaryColor,
                      ),
                    ),
                    Text("Show End Date",
                        style: PoppinsRegular(
                            mediaQuery.devicePixelRatio * 5, textColorBlack)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );




class DateFieldWidget extends StatefulWidget {
  final String labelText;
  final String sheetTitle;
  final String hintTextDate;
  final String hintTextTime;
  final Function() saveMethod;
  final DateTime date;
  final MediaQueryData mediaQuery;


  DateFieldWidget({
    Key? key,
    required this.labelText,
    required this.sheetTitle,
    required this.hintTextDate,
    required this.hintTextTime,
    required this.saveMethod,
    required this.date,
    required this.mediaQuery,

  }) : super(key: key);

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: PoppinsRegular(18, textColorBlack),
          ),
          BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return bottomSheet(
                context,
                widget.mediaQuery,
                widget.sheetTitle,
                widget.date,
                widget.hintTextDate,
                widget.hintTextTime,
                ()async {
                  await    ChooseTimeOFDay(context,state.jokertime.value??TimeOfDay.now(),mounted);
                },

               ()async {

                 await   DatePicker(context,mounted);
               },
                widget.saveMethod,
              );
            },
          ),
        ],
      ),
    );
  }
}
Widget firstLine(String work) => BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        return Row(
          children: [
            BackButton(
              onPressed: () {
                GoRouter.of(context).go('/home');
              },
            ),
            work!="edit"?
            Text("Create",
                style:
                    PoppinsSemiBold(21, textColorBlack, TextDecoration.none)):  Text("Edit",style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)),
           work!="edit"? MyDropdownButton():SizedBox()
          ],
        );
      },
    );
Widget imagePicker(mediaQuery) {
  final ImagePicker picker = ImagePicker();
  return BlocBuilder<FormzBloc, FormzState>(
    builder: (context, state) {

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          InkWell(
            onTap: () async {
              final XFile? picked =
                  await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                context
                    .read<FormzBloc>()
                    .add(ImageInputChanged(imageInput: picked));
              }
            },
            child: Container(
              height: mediaQuery.size.height/5,
              width: double.infinity,


              color: PrimaryColor.withOpacity(.1),
              child: state.imageInput.value != null && state.imageInput.value?.path != null&&state.imageInput.value?.path != ""
                  ? Image.file(
                      File(state.imageInput.value?.path ?? ""),
                      fit: BoxFit.scaleDown,
                height: mediaQuery.size.height/2,
                width: mediaQuery.size.height/5,
                    )
                  :

              Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: PrimaryColor,
                          ),
                          Text(
                            "Add Image",
                            style: PoppinsRegular(19, PrimaryColor),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ],
      );
    },
  );
}

Widget TextfieldNormal(String name, String HintText,
        TextEditingController controller, Function(String) onchanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(
            onChanged: (value) {
              onchanged(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            style: PoppinsNorml(18, textColorBlack),
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );
Widget TextfieldDescription(String name, String HintText,
        TextEditingController controller, Function(String) onChanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              onChanged(value);
            },
            style: PoppinsNorml(18, textColorBlack),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );
DateTime getTodayDateTime() {
  final today = DateTime.now();
  final dateOnly =
      DateTime(today.year, today.month, today.day, today.hour, today.minute);
  return dateOnly;
}

Widget chooseDate(DateTime todayDate, MediaQueryData mediaQuery, String Format,
        Function() onTap, String text) =>
    InkWell(
      onTap: () async {
        onTap();
      },
      child: BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Container(
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
            border: Border.all(color: textColorBlack),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: PoppinsLight(
                  18,
                  textColorBlack,
                ),
              ),
              Text(
                DateFormat(Format).format(todayDate),
                style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                    textColorBlack, TextDecoration.none),
              ),
            ],
          ),
        ),
      );
  },
),
    );
Widget chooseTime(TimeOfDay todaytime, MediaQueryData mediaQuery, String Format,
        Function() onTap, String text) =>
    InkWell(
      onTap: () async {
        onTap();
      },
      child: BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Container(
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
            border: Border.all(color: textColorBlack),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: PoppinsLight(
                  18,
                  textColorBlack,
                ),
              ),
              Text(
               todaytime.format(context),
                style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                    textColorBlack, TextDecoration.none),
              ),
            ],
          ),
        ),
      );
  },
),
    );

Widget PriceWidget(mediaQuery,TextEditingController controller) => BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Is Paid",
                    style: PoppinsRegular(
                        mediaQuery.devicePixelRatio * 6, textColorBlack),
                  ),
                  Checkbox(
                    value: state.isPaid,
                    onChanged: (bool? value) {
                      context
                          .read<VisibleBloc>()
                          .add(VisibleIsPaidToggleEvent(value!));
                    },
                    activeColor: PrimaryColor,
                    checkColor: textColorWhite,
                    splashRadius: 13,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
              Visibility(
                  visible: state.isPaid,
                  child: TextFormField(
                    controller: controller,

                    style: PoppinsNorml(18, textColorBlack),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        focusedBorder: border(PrimaryColor),
                        enabledBorder: border(ThirdColor),
                        hintStyle: PoppinsNorml(18, ThirdColor),
                        hintText: "Price"),
                  ))
            ],
          ),
        );
      },
    );
DateTime combineTimeAndDate(TimeOfDay time, DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}
InkWell bottomSheet(BuildContext context, MediaQueryData mediaQuery,
    String sheetTitle, DateTime date,
    String hintTextDate, String hintTextTime,
    Function() timePickerFunction,
    Function() datePickerFunction,
    Function() saveMethod,
    ) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: BottomShetBody(mediaQuery, sheetTitle, state.joker.value??DateTime.now(), hintTextDate,
                    hintTextTime, timePickerFunction, datePickerFunction,saveMethod ,state.jokertime.value??TimeOfDay.now() )
              );
            },
          );
        },
      );
    },
    child:container(mediaQuery, date),
  );
}
Widget container(mediaQuery,DateTime date)=>BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Container(
  width: mediaQuery.size.width,
  decoration: BoxDecoration(
    border: Border.all(width: 3, color: ThirdColor),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Text(
      "${DateFormat("MMM,dd,yyyy, HH:mm a").format(date)}",
      style: PoppinsRegular(
        19,
        textColorBlack,
      ),
    ),
  ),
);
  },
);

Widget BottomShetBody(
    mediaQuery,String sheetTitle,
    DateTime date,
    String hintTextDate, String hintTextTime,
    Function() timePickerFunction,
    Function() datePickerFunction,
    Function() saveMethod,
    TimeOfDay time
    )=>SizedBox(
  height: mediaQuery.size.height / 2.5,
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 10,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sheetTitle,
          style: PoppinsSemiBold(
            mediaQuery.devicePixelRatio * 6,
            PrimaryColor,
            TextDecoration.none,
          ),
        ),
        chooseDate(
         date,
          mediaQuery,
          "MMM,dd,yyyy",
          datePickerFunction,
          hintTextDate,
        ),
        chooseTime(
time,
          mediaQuery,
          "hh:mm a",
          timePickerFunction,
          hintTextTime,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PrimaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: saveMethod,
          child: Center(
            child: Text(
              "Save",
              style: PoppinsSemiBold(
                18,
                textColorWhite,
                TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
class PrefixIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  const PrefixIconButton({required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
class TextFieldGenerator extends StatefulWidget {
  @override
  _TextFieldGeneratorState createState() => _TextFieldGeneratorState();
}

class _TextFieldGeneratorState extends State<TextFieldGenerator> {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TextFieldBloc, TextFieldState>(
  builder: (context, state) {
    debugPrint(state.textFieldControllers.length.toString());
if (state.textFieldControllers.isEmpty){
  context.read<TextFieldBloc>().add(AddTwoTextFieldEvent());
}
    return Column(
      children: [
        for (int index = 0; index < state.textFieldControllers.length; index += 2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(

                    validator:  (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: state.textFieldControllers[index],
                    decoration: InputDecoration(
                      prefixIcon: PrefixIconButton(
                        onPressed: () {
                          if (index == state.textFieldControllers.length - 2){
                            context.read<TextFieldBloc>().add(AddTwoTextFieldEvent());}
                          else{
                            context.read<TextFieldBloc>().add(RemoveTextFieldEvent([index, index + 1]));}


                          debugPrint(state.textFieldControllers.length.toString());
                        },
                        iconData: index==state.textFieldControllers.length-2?Icons.add:Icons.remove,
                      ),
                      hintText: "Points N°${(index/2+1).toInt()}",
                      focusedBorder: border(PrimaryColor),
                      enabledBorder: border(ThirdColor),
                      errorBorder: border(Colors.red),
                      errorStyle: ErrorStyle(18, Colors.red),
                      hintStyle: PoppinsNorml(18, ThirdColor),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please  text';
                      }
                      return null;
                    },
                    controller: state.textFieldControllers[index + 1],
                    decoration: InputDecoration(
                      hintText: "Duration",
                      focusedBorder: border(PrimaryColor),
                      enabledBorder: border(ThirdColor),
                      errorBorder: border(Colors.red),
                      errorStyle: ErrorStyle(18, Colors.red),
                      hintStyle: PoppinsNorml(18, ThirdColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

  },
);
  }

}

Future<XFile?> convertBase64ToXFile(String base64String) async {
  try {
    // Decode base64 string to bytes
    Uint8List bytes = base64.decode(base64String);

    // Create a MemoryImage from bytes
    MemoryImage memoryImage = MemoryImage(Uint8List.fromList(bytes));

    // Create an ImageStreamCompleter from MemoryImage
    ImageStream stream = memoryImage.resolve(ImageConfiguration.empty);
    Completer<ImageInfo> completer = Completer<ImageInfo>();

    // Listen for the first frame from the ImageStream
    stream.addListener(ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image);
    }));

    // Wait for the first frame
    final ImageInfo imageInfo = await completer.future;

    // Convert the image to byte data
    final ByteData? byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    // Check if byte data is not null
    if (byteData == null) {
      return null;
    }

    // Create a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File('${tempDir.path}/converted_image.png').create();

    // Save byte data to file
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    // Return XFile with the file path
    return XFile(tempFile.path);
  } catch (e) {
    print('Error converting base64 to XFile: $e');
    return null;
  }}