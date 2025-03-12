import 'package:jci_app/features/Home/presentation/widgets/Functions/Listeners.dart';

import '../../../Activity_Global.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../Functions/ActivityFunctions.dart';

class SaveButton extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController namecontroller;
  final TextEditingController descriptionController;

  final TextEditingController ProfesseurName;
  final TextEditingController LocationController;
  final TextEditingController Points;
  final TextEditingController Price;
  final List<String> part;
  final String action;
  final String id;

  const SaveButton({
    Key? key,
    required this.formKey,
    required this.namecontroller,
    required this.descriptionController,

    required this.ProfesseurName,
    required this.LocationController,
    required this.Points,
    required this.Price,

    required this.part,
    required this.action,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocConsumer<AddDeleteUpdateBloc, AddDeleteUpdateState>(
      listener: (ctx, state) {
        Listeners.Listener(state, context);
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            ActivityFunctions.SaveActivityFunction(
              context.read<ActivityCubit>().state, // Assuming ActivityCubit provides state
              formKey,
              context.read<TaskVisibleBloc>().state, // Current AddDeleteUpdateState
              Price,
              context.read<FormzBloc>().state, // Assuming you need the FormzState here

              namecontroller,
              descriptionController,
              LocationController,
              Points,
              context.read<VisibleBloc>().state, // VisibleState
              part,
              action,
              id,
              context,
              ProfesseurName,
              context.read<TextFieldBloc>().state,
              context.read<CategoryBloc>().state,
              // TextFieldState
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child:

              state is LoadingAddDeleteUpdateState
                  ? const LoadingWidget()
                  :
              Text(
                "Save",
                style: PoppinsSemiBold(
                  mediaQuery.devicePixelRatio * 6,
                  PrimaryColor,
                  TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
