import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/stuff/ErrorDisplayMessage.dart';

import '../../../../../core/app_theme.dart';
import '../../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../../auth/AuthWidgetGlobal.dart';

class ImageActivityPicker extends StatelessWidget {

  const ImageActivityPicker({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        Logger().i("ImageActivityPicker: Building widget with state: ${state.images}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePickerArea(
              mediaQuery: mediaQuery,
              images:state.images,
              onEditTap: () => _pickImages(context),
              onContainerTap: () => _pickImages(context),
            ),

            state.status==Status.Empty?
                const MessageDisplayWidget(message: "Required"):const SizedBox()
          ],
        );
      },
    );
  }

  Future<void> _pickImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      final List<String> imagePaths = picked.map((file) => file.path).toList();
      for (final path in imagePaths) {
        context.read<TaskVisibleBloc>().add(ChangeImageEvent(path,ActionImage.ADD));
      }

    }
  }
}

/// Widget to display the main image picker area
class ImagePickerArea extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final List<String> images;
  final VoidCallback onEditTap;
  final VoidCallback onContainerTap;

  const ImagePickerArea({
    Key? key,
    required this.mediaQuery,
    required this.images,
    required this.onEditTap,
    required this.onContainerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:images.isEmpty?  onContainerTap:null,
      child: ImageContainer(mediaQuery: mediaQuery, images: images, AddImage: () {
        onEditTap();
      },),
    );
  }
}

/// Widget for the main image container
class ImageContainer extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final List<String> images;
  final VoidCallback AddImage;

  const ImageContainer({
    Key? key,
    required this.mediaQuery,
    required this.images, required this.AddImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQuery.size.width / 1.1,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: ThirdColor, width: 2),
        color: textColorWhite,
      ),
      child: images.isEmpty
          ? DefaultImagePlaceholder()
          : ImageList(images: images, addImage: () {
            AddImage();
      },),
    );
  }
}

/// Widget to display the default placeholder image
class DefaultImagePlaceholder extends StatelessWidget {
  const DefaultImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        "assets/images/jci.png",
        height: 100,
        width: 100,
      ),
    );
  }
}
class ImageList extends StatelessWidget {
  final List<String> images;
  final Function() addImage;

  const ImageList({
    Key? key,
    required this.images,
    required this.addImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length + 1, // Adding 1 for the "Add" button
      itemBuilder: (context, index) {
        // Show the "Add" button at the first position
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: addImage,
              child: SizedBox(
                height: 200.h,
                width: 200.w,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: const [18,12,18,12],

                  radius: const Radius.circular(15),

                  child:const  Center(
                    child:  Icon(
                      Icons.add,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // Show image thumbnails for the remaining items
        final imageIndex = index - 1; // Adjust index for images
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _isImagePath(images[imageIndex])
                    ? Image.file(
                  File(images[imageIndex]),
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                )
                    : Image.network(
                  images[imageIndex], // Assuming this is a URL
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: EditIconButton(
                  action: ActionImage.DELETE,
                  onTap: () {
                    context.read<TaskVisibleBloc>().add(
                      ChangeImageEvent(
                        images[imageIndex],
                        ActionImage.DELETE,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget for the edit button in the image picker
class EditIconButton extends StatelessWidget {
  final ActionImage action;
  final VoidCallback onTap;

  const EditIconButton({
    Key? key,

    required this.onTap, required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Positioned(
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.size.height / 15,
          horizontal: 5,
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: BackWidgetColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
            action==ActionImage.ADD?    Icons.add:Icons.delete,
                color: textColorBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
bool _isImagePath(String image) {
  return !image.startsWith('http') && !image.startsWith('https');
}