import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

enum ImageValidationError { empty }

class ImageInput extends FormzInput<XFile?, ImageValidationError> {

  const ImageInput.pure() : super.pure(null);
  const ImageInput.dirty([XFile? value]) : super.dirty(value);

  @override
  ImageValidationError? validator(XFile? value) {
    if (value == null) {
      return ImageValidationError.empty;
    }

    return null;
  }
}


