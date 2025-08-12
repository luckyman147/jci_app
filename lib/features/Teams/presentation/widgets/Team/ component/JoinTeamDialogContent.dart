import '../../../../../Home/Activity_Global.dart';

class JoinTeamDialogContent extends StatelessWidget {

  final void Function(String? pincode) onJoin;
final bool status;
  const JoinTeamDialogContent({
    Key? key,
required this.status,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Column(
 mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "You are not in this team yet.\nWould you like to join?",
          textAlign: TextAlign.center,
          style: PoppinsRegular(16, Colors.black),
        ),
        const SizedBox(height: 16),
        if (status == true) // Ask for pin only if required
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter PIN code",
              hintStyle: PoppinsRegular(14, Colors.grey),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: PoppinsRegular(14, Colors.red)),
            ),
            ElevatedButton(
              onPressed: () => onJoin(controller.text),
              child: Text("Join", style: PoppinsRegular(14, ColorsApp.SecondaryColor)),
            ),
          ],
        )
      ],
    );
  }
}
