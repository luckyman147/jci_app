import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/global-pres.dart';
import '../../../../../core/strings/objectifsIcon.dart';
import '../../../domain/entity/UserObjectifInfos.dart';
import '../../pages/objectif/ObjectifPage.dart';
class ObjectifCarouselCard extends StatefulWidget {
  final List<UserObjectifInfos> objectifs;

  const ObjectifCarouselCard({super.key, required this.objectifs});

  @override
  State<ObjectifCarouselCard> createState() => _ObjectifCarouselCardState();
}

class _ObjectifCarouselCardState extends State<ObjectifCarouselCard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170, // height enough to contain card + carousel + dots
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: ColorsApp.textColorWhite, width: 2),
                borderRadius: BorderRadius.circular(13)),
            color: ColorsApp.PrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: CarouselSlider.builder(
                      itemCount: widget.objectifs.length,
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        height: 160,
                        onPageChanged: (index, reason) {
                          setState(() => _currentIndex = index);
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final obj = widget.objectifs[index];
                        double progress = (obj.objectif.target != null && obj.objectif.target! > 0)
                            ? (obj.userObjectif.currentProgress / obj.objectif.target!).clamp(0, 1).toDouble()
                            : 0;

                        return
SingleChildScrollView(scrollDirection: Axis.horizontal,
    child:
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center  ,
                          children: [
                            // Text + button column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(

                                  children: [
Icon(ObjectifIcons().objectifIcons[obj.objectif.feature]!.icon,color: ColorsApp.textColorWhite,size: 30,),
                            SizedBox(width: 10,),
                               SizedBox(
                                 width: MediaQuery.of(context).size.width / 2.7,
                                 child: AutoSizeText(
                                   "${obj.objectif.objectifActionType.name.doublesWords} ${ obj.objectif.target!=0? obj.objectif.target:""} ${obj.objectif.feature.name}",                                  style: PoppinsSemiBold(16, Colors.white, TextDecoration.none),
                                ),),

                                ],),
SizedBox(height: 10,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsApp.SecondaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  onPressed: () {
                                    ObjectifsPage.show( context,context.read<MembersBloc>().state.user!,  context.read<MemberManagementBloc>().state);
                                    // TODO: View Task
                                  },
                                  child:  Text("View Task",style: PoppinsSemiBold(16, Colors.white, TextDecoration.none),),
                                ),
                              ],
                            ),
                            // Circular progress
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth:9,
                                    color: ColorsApp.SecondaryColor,
                                    backgroundColor: Colors.white24,
                                  ),
                                ),
                                Text("${(progress * 100).toInt()}%",
                                    style:  PoppinsNorml( 16,Colors.white,)),
                              ],
                            ),
                          ],
                        ));
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.objectifs.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index ? ColorsApp.SecondaryColor : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          // You can add more cards here to scroll horizontally

        ],
      ),
    );
  }
}
