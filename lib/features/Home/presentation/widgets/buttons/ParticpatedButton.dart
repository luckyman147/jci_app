import '../../../../auth/AuthWidgetGlobal.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/entities/Activity.dart';
import '../../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';

class ParticipateButton extends StatefulWidget {
  final Activity acti;
  final double textSize;
  final double containerWidth;
  final activity act;
  final bool isPartFromState;
  final int index;

  const ParticipateButton({
    Key? key,
    required this.acti,
    required this.index, required this.isPartFromState, required this.act, required this.textSize, required this.containerWidth,
  }) : super(key: key);

  @override
  _ParticipateButtonState createState() => _ParticipateButtonState();
}

class _ParticipateButtonState extends State<ParticipateButton> {




  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        final result=activityParams(act:  widget.acti, type: widget.act, Eventid:  widget.acti.id, name: '');
        if (widget.isPartFromState) {
          context.read<AcivityFBloc>().add(RemoveParticipantEvent( act: result));
        } else {

          context.read<AcivityFBloc>().add(AddParticipantEvent( act:result));
        }
      },
      child: AnimatedContainer(
        curve: Curves.easeIn,
        width:widget.containerWidth,
        decoration: BoxDecoration(
          color: widget.isPartFromState ? PrimaryColor : BackWidgetColor,
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(milliseconds: 1600),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon( widget.isPartFromState ? Icons.check : Icons.star,
                  color:  widget.isPartFromState ? textColorWhite : textColorBlack).
              animate(),
              Text(
                widget.isPartFromState ? "Interested".tr(context) : "Join".tr(context),
                style: PoppinsSemiBold(widget.textSize,
                    widget.isPartFromState ? textColorWhite : textColorBlack,
                    TextDecoration.none),
              ).animate(),
            ],
          ),
        ),
      ).animate(),
    ).animate(
      effects: [
        const FadeEffect(
          duration: Duration(milliseconds: 500),

          curve: Curves.easeIn,
        ),
      ],
    );

  }
}