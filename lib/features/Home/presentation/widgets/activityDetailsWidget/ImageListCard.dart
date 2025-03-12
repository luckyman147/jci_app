import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/NetworkCachedImageWidget.dart';

import '../../../../../core/app_theme.dart';
import '../../../../auth/AuthWidgetGlobal.dart';

class ImageListCard extends StatelessWidget {
  final List<String> images; // List of image URLs or asset paths

  const ImageListCard({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    const int maxImages = 5; // Maximum images to display
    final int remainingCount = images.length > maxImages ? images.length - maxImages + 1 : 0;

    return Positioned(
      top: mediaQuery.size.height / 3.5,
      left: 0,
      right: 0
      ,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox
          (
          width: images.length > maxImages ? mediaQuery.size.width- maxImages*6.h : 67.h*(images.length+.5)+images.length*5,
          height: 70.h,
          child: Padding(
            padding: paddingSemetricHorizontal(),
            child: BlocBuilder<ChangeStringBloc, ChangeStringState>(
  builder: (context, state) {
    return Card(

              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: SizedBox(
                  height: 60.h, // Fixed height for the ListView
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length > maxImages ? maxImages : images.length,
                    itemBuilder: (context, index) {
                      if (remainingCount > 0 && index == maxImages - 1) {
                        // Display the remaining count on the last card
                        return InkWell(
                          //Show bottom sheet all the page
                          onTap: ( ){

                            showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const BackButton(),
                                      ImageGallery(imageUrls: images),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 50.h,
                            height: 50.h,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                '+$remainingCount',
                                style: PoppinsRegular(16, Colors.white),
                              ),
                            ),
                          ),
                        );
                      }

                      // Display individual image cards
                      return InkWell(

                        onLongPress: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(imageUrl: images[index]),
                            ),
                          );
                        },
                        onTap: () {
                          context.read<ChangeStringBloc>().add(SetImageEvent(image: images[index]));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Border radius for smooth corners
                            border: Border.all(
                              color: state.image==images[index]?SecondaryColor:textColorWhite, // Color of the border
                              width:state.image==images[index]? 4:1, // Width of the border
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5 ),
                            child: CachedNetworkImageWidget(
                              item: images[index],
                              height: 70.h, // Height of the image
                              width: 60.h,  // Width of the image
                            ),
                          ),
                        ),
                      );

                    }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 6); },
                  ),
                ),
              ),
            );
  },
),
          ),
        ),
      ),
    );
  }
}
class ImageGallery extends StatelessWidget {
  final List<String> imageUrls; // List of image URLs

  const ImageGallery({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height ,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            childAspectRatio: 1, // Aspect ratio of each child
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return _buildImageCard(imageUrls[index],context);
          },
        ),
    );
  }

  Widget _buildImageCard(String imageUrl,BuildContext context) {
    return GestureDetector(
     onTap: (){
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => FullScreenImage(imageUrl: imageUrl),
         ),
       );},
      child: Card(
        elevation: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImageWidget(
         item:    imageUrl,
            height: 200, // Height of the image
            width: 200, // Width of the image

          ),
        ),
      ),
    );
  }
}
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen image
          Positioned.fill(
            child: CachedNetworkImageWidget(
              item: imageUrl,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Header with back and download buttons
          Positioned(
            top: 40.h, // Adjust for padding
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
         BackButton(color: ColorsApp.textColorWhite,onPressed: ()=>   Navigator.pop(context)  ,),
                // Download button
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.white),
                  onPressed: () {
                    _downloadImage(imageUrl);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _downloadImage(String url) {

  }
}