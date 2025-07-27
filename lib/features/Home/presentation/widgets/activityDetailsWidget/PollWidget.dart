
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/domain/Dtos/PollDto.dart';
import 'package:jci_app/features/Home/domain/entities/poll/Poll.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import '../../../Activity_Global.dart';
import '../../../domain/entities/poll/PollOption.dart';


import '../../bloc/Poll/poll_bloc.dart';
import '../Functions/ActivityDetailsFunctions.dart';
import '../components/stuff/NetworkCachedImageWidget.dart';

class PollWidget extends StatelessWidget {
  const PollWidget({super.key, required this.poll});
  final Poll poll;


  double _calculateVotePercentage(int totalVotes, int optionVotes) {
    if (totalVotes == 0) return 0;
    return   (totalVotes/optionVotes) * 100;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onLongPress: (){
ActivityDetailsFunctions.showDeleteDialog(context: context, onDelete: (){
  final poldto=PollDto(null, poll.options, ActivityId: poll.ActivityId, Pollid: poll.id, index: null);
  context.read<PollBloc>().add(DeletePollEvent(poldto: poldto));

});
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

        color: ColorsApp.textColorWhite,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ColorsApp.ThirdColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poll Title
              Text(
                poll.title,
                style: PoppinsSemiBold(17.sp, ColorsApp.PrimaryColor, TextDecoration.none),
              ),
              const SizedBox(height: 16),

              // Poll Options
              Column(
                children: poll.options.take(3).map((option) {
                  double votePercentage = _calculateVotePercentage(option.votes.length,
                      context.read<AcivityFBloc>().state.activityById!.participation. participants.length );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row with option title and user images
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Option Title
                            AutoSizeText(
                              option.title,
                              style: PoppinsRegular(16.sp, textColorBlack),
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Voter Images
                            Row(
                              children: option.votes
                                  .take(3) // Show up to 5 user images
                                  .map((vote) => Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child:ClipOval(child: CachedNetworkImageWidget(item:vote.userImage,height: 20,width: 20,)),

                              ))
                                  .toList(),
                            ),
                            if (option.votes.length > 3)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('+${option.votes.length - 3}'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress Line
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(8),
                          value: votePercentage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(ColorsApp.PrimaryColor),
                        ),
                        const SizedBox(height: 4),
                        // Percentage Text
                        Text(
                          '${votePercentage.toStringAsFixed(1)}%',
                          style: PoppinsRegular(14.sp, ColorsApp.ThirdColor),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Vote Button
              BlocBuilder<PollBloc, PollState>(
        builder: (context, state) {
      return Center(
        child: ElevatedButton(
                  onPressed: () {
                    context.read<PollBloc>().add(InitOptions(options: poll.options));

                  // Launch dialog to vote or add an option
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        Logger().i('ortiginal: ${poll.options}');

                        return
                          _VotesDialog(options: poll.options, ActivityId: poll.ActivityId, Pollid: poll.id);
                      },
                    );
                    // Handle voting logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.PrimaryColor,
                  ),
                  child:  Text('Vote', style: PoppinsRegular(16.sp, Colors.white)),
                ),
      );
        },
      ),
            ],
          ),
        ),
      ),
    );
  }
}
class _VotesDialog extends StatefulWidget {
  const _VotesDialog({required this.options, required this.ActivityId, required this.Pollid});
  final List<PollOptions> options;
  final String ActivityId;
  final String Pollid;

  @override
  State<_VotesDialog> createState() => _VotesDialogState();
}

class _VotesDialogState extends State<_VotesDialog> {

  final TextEditingController newOptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    newOptionController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollBloc, PollState>(
  builder: (context, state) {
    return AlertDialog(
      title: Text('Vote or Add an Option',style: PoppinsRegular(16.sp, ColorsApp.textColorBlack)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // List of options with checkboxes
            Expanded(
              child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.options.length,
                          itemBuilder: (context, index) {
                            final option = widget.options[index];
                              return
                                CheckboxListTile(
                                  activeColor: ColorsApp.PrimaryColor,
splashRadius: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                value: state.voted[option.id],
                                onChanged: (value) {
                                  if (value != null && state.voted[option.id] == true) {
                                    context.read<PollBloc>().add(unvoteEvent(pollOptionId: option.id));
                                  }
                                  else {
                                    context.read<PollBloc>().add(voteEvent(pollOptionId: option.id));
                                  }
                                  
                                  
                                },
                                  secondary:      (option.votes.isNotEmpty)?
                            SizedBox(
                              height: 20,
                              width: 100,
                              child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: option.votes.map((vote) => Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    
                                    child:ClipOval(child: CachedNetworkImageWidget(item:vote.userImage,height: 20,width: 20,)),

                                  )).toList(
                                  )
                              ),
                            ):null,
                                  controlAffinity: ListTileControlAffinity.leading,
                                title: SingleChildScrollView(
                                 scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      AutoSizeText(option.title, style: PoppinsRegular(16.sp, ColorsApp.textColorBlack)),

                                    ],
                                  ),
                                ),
                              );
                          },
                        ),
            ),
     /*       const SizedBox(height: 10),
            TextField(
              controller: newOptionController,
              decoration:PollInput("Add an Option", optionController: newOptionController, iconExisted: true, AddOption: () {
                ActivityDetailsFunctions.AddOption(context, newOptionController);
              },),
            )
*/
            // Add new option

          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
          final polldto=PollDto(null, state.options, ActivityId: widget.ActivityId, Pollid: widget.Pollid, index: null);
          context.read<PollBloc>().add(SubmitVotes(poldto: polldto));
            Navigator.of(context).pop();
          },
          child:  Text('Submit', style: PoppinsRegular(16.sp, ColorsApp.PrimaryColor)),
        ),
        TextButton(
          onPressed: () {


            Navigator.of(context).pop();
          },
          child:  Text('Cancel' , style: PoppinsRegular(16.sp, ColorsApp.ThirdColor)),
        ),
      ],
    );
  },
);
  }
}
class PollListWidget extends StatefulWidget {
  const PollListWidget({super.key, required this.polls});
  final List<Poll> polls;

  @override
  _PollListWidgetState createState() => _PollListWidgetState();
}

class _PollListWidgetState extends State<PollListWidget> {
  // Create a ScrollController


  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(


        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*.9,
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
               // Disable scrolling on ListView
                itemCount: widget.polls.length,
                itemBuilder: (context, index) {
                  return PollWidget(poll: widget.polls[index]);
                },
                separatorBuilder: (context, index) => const SizedBox(height: 4),
              ),

            ],
          ),
        ),
      );
  }
}

