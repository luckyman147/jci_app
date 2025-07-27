
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Activity_Global.dart';
import '../components/stuff/WebViewScreen.dart';

class TextFieldWithIcons extends StatelessWidget {
  const TextFieldWithIcons({
    Key? key, required this.controller,
  }) : super(key: key);
  final TextEditingController controller ;





  @override
  Widget build(BuildContext context) {
     final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter some text'.tr(context);
          }
          return null;
        },

        controller: controller,
        style: PoppinsNorml(18, textColorBlack),
        decoration: InputDecoration(
        errorStyle: ErrorStyle(15, Colors.red),
          hintStyle: PoppinsNorml(18, ThirdColor),
          hintText: 'Enter your meet link',

          errorBorder: border(Colors.red),
          border: border(ColorsApp.ThirdColor),
          focusedBorder: border(ColorsApp.PrimaryColor),
          enabledBorder: border(ColorsApp.ThirdColor),

          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {

                  final text = controller.text;
                  Clipboard.setData(ClipboardData(text: text)).then((_) {
                    SnackBarMessage.showErrorSnackBar(message:"Copied successfully", context: context);
                  });
                },
                tooltip: 'Copy',
                color: ColorsApp.ThirdColor,
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.link),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WebViewScreen()));
                },
                tooltip: 'Show Popup',
                color: ColorsApp.ThirdColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}