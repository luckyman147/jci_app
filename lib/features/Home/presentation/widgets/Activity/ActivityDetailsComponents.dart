import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/route/app_router.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';
import 'package:jci_app/features/Home/domain/Dtos/PArticipantParam.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/training.dart';
import 'package:jci_app/features/Home/domain/enums/ActivityEnum.dart';
import 'package:jci_app/features/Home/domain/enums/AttendeceEmum.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/ActivityFunctions.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';

import '../../../data/model/meetingModel/MeetingModel.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';
import '../../bloc/DescriptionBoolean/description_bool_bloc.dart';
import '../../pages/CreateUpdateActivityPage.dart';
import '../Functions/ActivityDetailsFunctions.dart';
import '../Implementations/ActivtysImplementations.dart';

import '../activityDetailsWidget/DcrollingTextAnimation.dart';
import '../activityDetailsWidget/ImageListCard.dart';
import '../buttons/ParticpatedButton.dart';
import '../buttons/PinnedButton.dart';
import '../components/stuff/NetworkCachedImageWidget.dart';
import '../shimmer/ShimmerButton.dart';

import '../Functions/Functions.dart';

enum actionType { edit, Add }

class ActivityDetailsComponent {
  static Widget searchField(
          Function(String) onsearch, String hintText, bool isRow) =>
      Padding(
        padding: paddingSemetricVerticalHorizontal(),
        child: SizedBox(
          height: 50,
          width: isRow ? 250 : double.infinity,
          child: TextField(
            onChanged: onsearch,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: PoppinsRegular(15, textColor),
              prefixIcon: const Icon(Icons.search),
              border: border(textColorBlack),
              focusedBorder: border(PrimaryColor),
              enabledBorder: border(PrimaryColor),
            ),
          ),
        ),
      );

  static Widget Description(MediaQueryData mediaQuery, Activity activitys) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width / 20),
        child: Align(
          alignment: Alignment.topLeft,
          child: BlocBuilder<ActivityCubit, ActivityState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: PoppinsSemiBold(
                          16, ColorsApp.textColorBlack, TextDecoration.none),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DescriptionToggle(
                        description: activitys.activityBasics.description,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

  static Widget buildAddButtonWi(
      BuildContext context, String act, String work) {
    return AddButtonWi(PrimaryColor, textColorBlack, Icons.add_rounded, () {
context.navigateTo(CreateUpdateActivityRoute(
              id: 'id',
              activity: act,
              work: work,
              particpants: const [],
            ));




      context
          .read<ChangeSboolsCubit>()
          .ChangePages('/home', '/create/${"id"}/$act/$work/${[]}');
    });
  }

  static Widget ImageCard(mediaQuery, String image, BuildContext ctx) =>
      image.isNotEmpty
          ? ClipRRect(
              child: InkWell(
              onTap: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(imageUrl: image),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorsApp.textColorWhite)),
                ),
                child: CachedNetworkImageWidget(
                  item: image,
                  height: mediaQuery.size.height / 2.5,
                  width: double.infinity,
                ),
              ),
            ))
          : ClipRRect(
              child: Container(
                height: mediaQuery.size.height / 2.5,
                width: double.infinity,
                color: backgroundColored,
                child: Image.asset(
                  images.jci,
                  fit: BoxFit.contain,
                ),
              ),
            );

  static Widget dots(BuildContext context, MediaQueryData mediaQuery,
          Activity activitys) =>
      Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<AddDeleteUpdateBloc, AddDeleteUpdateState>(
              listener: (context, state) {
                if (state is DeletedActivityMessage) {
                  context.pushRoute(HomeRoute());
                }

                // TODO: implement listener
              },
              child: GestureDetector(
                onTap: () {
                  ActivityDetailsFunctions.showGridModalBottomSheet(
                      context, activitys);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: BackWidgetColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Icon(Icons.more_horiz_sharp,
                      color: textColorBlack, size: 30),
                ),
              ),
            ),
          );

  static Widget rowName(mediaQuery, BuildContext context, Activity activitys,
          activity act, int index) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height / 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //  PriceWidget(mediaQuery, activitys, context),
            ScrollingTextAnimation(
              address: activitys.activityBasics.activityAdress,
              name: activitys.activityBasics.name,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ActivityDetailsComponent.PartipantsRow(
                  mediaQuery, context, activitys, act, index),
            ),
          ],
        ),
      );

  static Padding buildCategories(MediaQueryData mediaQuery, Activity activity) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: mediaQuery.size.width,
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: activity.settings.categoryIds.map((category) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: BackWidgetColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoSizeText(
                "#$category",
                style: PoppinsSemiBold(14.sp, ColorsApp.BackWidgetColor, TextDecoration.none),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  static Container PriceWidget(
      mediaQuery, Activity activitys, BuildContext context) {
    return Container(
        width: mediaQuery.size.width / 5,
        height: mediaQuery.size.height / 15,
        decoration: BoxDecoration(
            color: PrimaryColor.withOpacity(.2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
                activitys.settings.price.toString() == "0"
                    ? "Free".tr(context)
                    : "${activitys.settings.price.toString()} dt",
                style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 4,
                    PrimaryColor, TextDecoration.none)),
          ),
        ));
  }

  static Widget Back(mediaQuery, BuildContext context) => Positioned(
      top: mediaQuery.size.height / 27,
      left: 10,
      child: GestureDetector(
        onTap: () {
          context.pushRoute(HomeRoute());
        },
        child: Container(
          decoration: const BoxDecoration(
              color: BackWidgetColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SvgPicture.string(
            pic,
            width: 20,
            height: 42,
          ),
        ),
      ));
  static Widget header(MediaQueryData mediaQuery, context, bool isMeeting) =>
      SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.devicePixelRatio * 12,
                      vertical: 40.h),
                  child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        "${state.selectedActivity.name.tr(context)} Details",
                        style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 6,
                            isMeeting
                                ? ColorsApp.textColorBlack
                                : ColorsApp.PrimaryColor,
                            TextDecoration.none),
                      )),
                );
              },
            ),
          ],
        ),
      );

  static Widget PartipantsRow(MediaQueryData mediaQuery, BuildContext context,
          Activity activitys, activity act, int index) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // DeatailsTeamComponent.membersTeamImage(context,mediaQuery,activitys.Participants.length,activitys.Participants,20,30),
            BlocBuilder<AcivityFBloc, AcivityFState>(
              builder: (context, state) {
                return Padding(
                  padding: paddingSemetricHorizontal(h: 15),
                  child: FutureJoinButton(
                      state,
                      index,
                      activitys,
                      act,
                      mediaQuery,
                      mediaQuery.size.width / 2,
                      mediaQuery.devicePixelRatio * 4.5,
                      context),
                );
              },
            ),

          ],
        ),
      );

  static Widget FutureJoinButton(
      AcivityFState state,
      int index,
      Activity activitys,
      activity act,
      MediaQueryData mediaQuery,
      double width,
      double textsize,
      BuildContext context) {
    final ifExist=ActivityAction.checkifMemberExist(
        state.activitiesSearch[index].participation.participants,
        context);
    return
      state.activityfetchState==ActivityFetchState.LoadingButton?
          ShimmerButton(width: width, height:
          mediaQuery.size.height / 20,

          ):
      AnimatedSwitcher(
      duration: const Duration(
          milliseconds: 500), // Set the duration for the animation
      child: ParticipateButton(
        key:
        UniqueKey(), // Ensure widget is rebuilt when its properties change
        acti: activitys,
        index: index,
        isPartFromState:ifExist,
        act: act,
        textSize: textsize,
        containerWidth: width,
      ),
    );
  }

  static Widget kk(mediaQuery, Activity activitys) => Padding(
        padding: paddingSemetricHorizontal(h: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconInfo(
                activitys.online.isOnline ? Icons.online_prediction : Icons.place),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: mediaQuery.size.width / 1.5,
                  child: InkWell(
                    onTap: () {
                      if (activitys.online.isOnline) {
                        ActivityFunctions.launchURL(activitys.online.googleMeetLink);
                      }
                    },
                    child: Padding(
                      padding: paddingSemetricVerticalHorizontal(v: 20),
                      child: Text(
                        activitys.online.isOnline
                            ? activitys.online.googleMeetLink
                            : activitys.activityBasics.activityAdress,
                        style: PoppinsSemiBold(
                            17.sp,
                            textColorBlack,
                            activitys.online.isOnline
                                ? TextDecoration.underline
                                : TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  static Widget infoCircle(
          mediaQuery, Activity activitys, BuildContext context) =>
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<localeCubit, LocaleState>(
              builder: (context, state) {
                return Padding(
                  padding: paddingSemetricHorizontal(h: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconInfo(Icons.calendar_month),
                      Padding(
                        padding: paddingSemetricHorizontal(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: mediaQuery.size.width / 1.5,
                              child: Text(
                                DateFormat(
                                        'EEEE dd MMM yyyy',
                                        state.locale == const Locale('en')
                                            ? 'en_US'
                                            : 'fr_FR')
                                    .format(activitys.activityBasics.activityBeginDate)
                                    .toUpperCase(),
                                style: PoppinsSemiBold(
                                    17, textColorBlack, TextDecoration.none),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  ActivityAction.calculateDurationhour(
                                      activitys.activityBasics.activityBeginDate,
                                      activitys.activityBasics.activityEndDate,
                                      state),
                                  style: PoppinsSemiBold(
                                      15.sp, textColor, TextDecoration.none),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            kk(mediaQuery, activitys),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Visibility(
                  visible: activitys.runtimeType != MeetingModel,
                  child: Price(activitys, context, mediaQuery)),
            ),
            activityInfo(
                context: context, mediaQuery: mediaQuery, activity: activitys)
          ],
        ),
      );
  static Widget activityInfo({
    required BuildContext context,
    required MediaQueryData mediaQuery,
    required Activity activity,
  }) {
    String title;
    String name;
    String? imageUrl;

    if (activity is EventModel) {
      title = "Leader Informations";
      name = "${activity.leaderName.firstName} ${activity.leaderName.lastName}";
      imageUrl = activity.leaderName.Images.isNotEmpty
          ? activity.leaderName.Images[0]
          : null;
    } else if (activity is MeetingModel) {
      title = "Director Informations";
      name = "${activity.director.firstName} ${activity.director.lastName}";
      imageUrl = activity.director.Images.isNotEmpty
          ? activity.director.Images[0]
          : null;
    } else if (activity is Training) {
      title = "By Trainer".tr(context);
      name = activity.professeurName;
      imageUrl = null; // Training does not seem to have an image.
    } else {
      throw Exception("Unsupported activity type");
    }

    return SizedBox(
      width: mediaQuery.size.width,
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(h: 20, v: 14),
        child: Row(
          children: [
            IconInfo(Icons.person_2),
            Padding(
              padding: paddingSemetricHorizontal(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PoppinsRegular(15.sp, textColorBlack),
                  ),
                  imageUrl != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: CachedNetworkImageWidget(
                                item: imageUrl,
                                height: 30,
                                width: 30,
                              ),
                            ),
                            const SizedBox(
                                width: 8), // Add spacing between image and text
                            AutoSizeText(
                              name,
                              style: PoppinsSemiBold(
                                  16.sp, textColorBlack, TextDecoration.none),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: mediaQuery.size.width / 2.5,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: PoppinsSemiBold(
                                18, textColorBlack, TextDecoration.none),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Padding Price(Activity activitys, BuildContext context, mediaQuery) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 20),
      child: Row(
        children: [
          IconInfo(Icons.monetization_on),
          Padding(
            padding: paddingSemetricHorizontal(),
            child: Text(
                activitys.settings.isPaid ? "Paid".tr(context) : "Free".tr(context),
                style:
                    PoppinsSemiBold(18, textColorBlack, TextDecoration.none)),
          ),
        ],
      ),
    );
  }

  static Widget IconInfo(IconData icon) {
    return SizedBox(
      width: 40.h,
      height: 40.h,
      child: Icon(
        icon,
        color: ColorsApp.ThirdColor,
        size: 25,
      ),
    );
  }
}

class DescriptionToggle extends StatelessWidget {
  final String description;

  const DescriptionToggle({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return BlocBuilder<DescriptionBoolBloc, DescriptionBoolState>(
      builder: (context, state) {
        final truncatedDescription = state.isFullDescription
            ? description
            : description.length < 100
                ? description
                : '${description.substring(0, 100)}...';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              truncatedDescription,
              style: PoppinsRegular(
                  mediaquery.devicePixelRatio * 5, textColorBlack),
            ),
            if (description.length > 100)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  radius: 10.0,
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    context
                        .read<DescriptionBoolBloc>()
                        .add(ShowFullDescriptionEvent());
                  },
                  child: Text(
                    state.isFullDescription
                        ? 'Show less'.tr(context)
                        : 'Show more'.tr(context),
                    style: PoppinsSemiBold(mediaquery.devicePixelRatio * 5,
                        PrimaryColor, TextDecoration.underline),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

Widget actionRow(mediaQuery, Activity activity, Color color, IconData icon,
        String action, Function() onTap, BuildContext context) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(),
        child: Container(
          width: mediaQuery.size.width / 4,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$action ${activity.runtimeType.toString().split("Model")[0].tr(context)}",
                  textAlign: TextAlign.center,
                  style: PoppinsRegular(mediaQuery.devicePixelRatio * 4, color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
