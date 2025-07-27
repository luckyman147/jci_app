import 'package:flutter/material.dart';
import 'package:jci_app/features/Home/domain/entities/Meeting.dart';

import '../../../../../core/app_theme.dart';

class AgendaWidget extends StatelessWidget {
  final Meeting activity;


  const AgendaWidget({
    Key? key,
    required this.activity,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return AgendaBottomSheet(activity: activity, );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90 * activity.agenda.length.toDouble(), // Adjust the height as needed
              child: AgendaListView(
                activity: activity,
                mediaQuery: mediaQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AgendaBottomSheet extends StatelessWidget {
  final Meeting activity;


  const AgendaBottomSheet({
    Key? key,
    required this.activity,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
            itemCount: activity.agenda.length,
            itemBuilder: (context, index) {
              var i = activity.agenda[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: PrimaryColor, width: 1.5),
                    ),
                    child: Padding(
                      padding: paddingSemetricVerticalHorizontal(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: mediaQuery.size.width,
                            child: Text(
                              '${index + 1}. ${i.title}',
                              overflow: TextOverflow.ellipsis,
                              style: PoppinsRegular(
                                mediaQuery.devicePixelRatio * 6,
                                textColorBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: mediaQuery.size.width * 0.6,
                            child: Text(
                              "${i.endTime} min",
                              overflow: TextOverflow.ellipsis,
                              style: PoppinsLight(
                                mediaQuery.devicePixelRatio * 5,
                                textColorBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
          ),
        ),
      ),
    );
  }
}


class AgendaListView extends StatelessWidget {
  final Meeting activity;
  final MediaQueryData mediaQuery;

  const AgendaListView({
    Key? key,
    required this.activity,
    required this.mediaQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: activity.agenda.length,
      itemBuilder: (context, index) {
        var i = activity.agenda[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration:const  BoxDecoration(

              border: Border(
                right: BorderSide(
                  color: ThirdColor,
                  width: 3,
                ),
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(

                    width: mediaQuery.size.width,
                    child: Text(
                      '${index + 1}. ${i.title}',
                      overflow: TextOverflow.ellipsis,
                      style: PoppinsSemiBold(
                        mediaQuery.devicePixelRatio * 6,
                        textColorBlack,
                        TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding:paddingSemetricHorizontal(),
                    child: SizedBox(

                      width: mediaQuery.size.width * 0.2,
                      child: Text(
                        "${i.endTime} min",
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsRegular(
                          mediaQuery.devicePixelRatio * 6,
                          ThirdColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,child:
          Divider(color: BackWidgetColor,)
          ,);
      },
    );
  }
}
