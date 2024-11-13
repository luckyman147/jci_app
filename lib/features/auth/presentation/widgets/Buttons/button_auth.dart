


import '../../../AuthWidgetGlobal.dart';
class authButton extends StatelessWidget {
  const authButton({Key? key, required this.onPressed, required this.text, required this.icon, required this.isLoading, required this.isoogl})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final IconData icon ;
  final bool isLoading;
  final bool isoogl;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: mediaQuery.size.height / 15,
      decoration: BoxDecoration(
        color:!isoogl? PrimaryColor: ColorsApp.SecondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColorBlack
              ,
          width: 2
      )),
      child: InkWell(
       borderRadius: BorderRadius.circular(14),

        highlightColor: PrimaryColor.withOpacity(0.3),
        onTap: onPressed,
        child: Flex(
        direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
        Padding(
          padding: paddingSemetricHorizontal(h: mediaQuery.size.width/20)
            ,            child:  FaIcon(
          icon,
          color: ColorsApp.textColorWhite,
          size: mediaQuery.size.width/15,
        ),
        ),
            isLoading ? Center(
              child: Padding(
                padding: paddingSemetricHorizontal(h: mediaQuery.size.width/20),
                child: CircularProgressIndicator(
                  color: ColorsApp.textColorWhite,
                ),
              ),
            ) :

            Text(text,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColorWhite),),
          ],
        ),
      ),
    ).animate(
     effects: [
       FadeEffect(duration: 500.milliseconds),

     ]

    );
  }
}


