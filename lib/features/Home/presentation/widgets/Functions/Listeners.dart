import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';

import '../../../../../core/util/snackbar_message.dart';
import '../../../Activity_Global.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';

class Listeners {

  static void Listener(AddDeleteUpdateState ste, BuildContext context) {
    if (ste is ErrorAddDeleteUpdateState) {
      SnackBarMessage.showErrorSnackBar(
          message: ste.message, context: context);
    }
    if (ste is MessageAddDeleteUpdateState) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      Navigator.of(context).pop();
    }
    if (ste is ActivityUpdatedState) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      context.read<TaskVisibleBloc>().add(const ChangeImageEvent("",ActionImage.PREVIOUS));
      context.pop();
    }
    if (ste is DeletedActivityMessage) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      context.pop();
    }
    if (ste is LoadingAddDeleteUpdateState) {
      const LoadingWidget();
    }
  }
}