import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';

import '../../../Activity_Global.dart';
import '../../../domain/entities/Category.dart';
import '../../../../../core/widgets/StandardTextFieldWidget.dart';
import '../components/SearchTextField.dart';
import 'CategoryButton.dart';

class CategoryBottomSheet extends StatelessWidget {

final TextEditingController controller = TextEditingController();
   CategoryBottomSheet({
    Key? key,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: mediaQuery.size.height * 0.9,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: BlocBuilder<CategoryBloc,CategoryState>(

          builder: (context, state) {
            return PageView(
              scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              context.read<CategoryBloc>().add(CategoryNameChanged(name: ""));
              context.read<CategoryBloc>().add(ChangeIndex(index: index));

            },
              children:[
                state.PageIndex==0?
                FetchCategories(mediaQuery: mediaQuery):
               AddCAtegorieWidget(context, mediaQuery, state)
              ]
            );
          }
        ),
      ),
    );
  }

  Animate AddCAtegorieWidget(BuildContext context, MediaQueryData mediaQuery, CategoryState state) {
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButton(
          onPressed: (){
            context.read<CategoryBloc>().add(CategoryNameChanged(name: ""));
            controller.clear();
            context.read<CategoryBloc>().add(ChangeIndex(index: 0));

          },
                ),
                Padding(
          padding: paddingSemetricHorizontal(),
          child: Text(
            "Add Category",
            style: PoppinsSemiBold(
              mediaQuery.devicePixelRatio * 7,
              ColorsApp.textColorBlack,
              TextDecoration.none,
            ),
          ),
                ),
              ],
            ),
            StandardTextFieldWidget(context: context, name: 'Category Name', hintText: ' Enter Categorie Name', controller: controller, onChanged: (String ) {   if (controller.text.isEmpty) {
              context.read<CategoryBloc>().add(CategoryNameChanged(name: ""));
            }
            else {
              context.read<CategoryBloc>().add(CategoryNameChanged(name: controller.text));
            }

            },)
          ,Padding(
            padding:paddingSemetricVertical(),
            child: SizedBox(
              width: mediaQuery.size.width*0.9
                ,
              height: 54.h,
              child:  ElevatedButton(

          style: styleFrom(state.CategoryName.isNotEmpty),

          onPressed: (){
            if (state.CategoryName.isNotEmpty) {
              Category category = Category(CategoryName: controller.text, CategoryId: '', Priority: 1, NumberOfActivities: 0, ActivityIds: []);
              context.read<CategoryBloc>().add(CreateCategoryEvent(category: category));
              context.read<CategoryBloc>().add(CategoryNameChanged(name: ""));
              context.read<CategoryBloc>().add(ChangeIndex(index: 0));
              context.read<CategoryBloc>().add(GetAllCategoriesEvent());
              controller.clear();
            }

          }, child:
              state.isLoading?const CircularProgressIndicator():


              Text('Submit'.tr(context),
                style: PoppinsSemiBold(16, ColorsApp.textColorWhite, TextDecoration.none) ,))

          ),
            ),

          ]

             ).animate(
                effects: [
                  const FadeEffect(
                    duration: Duration(milliseconds:500),
                  )
                ]
             );
  }
}

class FetchCategories extends StatelessWidget {
  const FetchCategories({
    super.key,
    required this.mediaQuery,
  });

  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Choose A category".tr(context),
          style: PoppinsSemiBold(
            mediaQuery.devicePixelRatio * 7,
            textColorBlack,
            TextDecoration.none,
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: mediaQuery.size.width * 0.7,
              child: SearchTextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    context.read<CategoryBloc>().add( ResetCategoryEvent());
                  }
                  else {
                    context.read<CategoryBloc>().add(GetCategoryByNameEvent(name: value));
                  }
                },
                hintText: "Search for a Category".tr(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50.h,
                width: 50.w,

                  decoration: BoxDecoration(
                      border: Border.all(color: ColorsApp.ThirdColor,width: 2),
                      borderRadius: BorderRadius.circular(10)),

                  child: InkWell(
                    onTap: (){
                      context.read<CategoryBloc>().add(ChangeIndex(index: 1));

                    },
                      splashColor: ColorsApp.PrimaryColor,
                      child: const Icon( Icons.add,))),
            )
          ],
        ),
        const MainCategoryComponent()
      ],
    ).animate(
      effects: [
        const FadeEffect(
          duration: Duration(milliseconds: 500),
        )
      ]

    );
  }
}

class MainCategoryComponent extends StatelessWidget {
  const MainCategoryComponent({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: mediaQuery.size.height / 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state.isLoading || state.Clonecategories.isEmpty) {
                  return const LoadingWidget();
                }
                else if (state.error.isNotEmpty) {
                  return const Center(
                    child: Text('No Categories Found'),
                  );
                }

                return CategoryDetails(state.Clonecategories,mediaQuery);




              },
            ),
          ),
        ),
      ),
    );
  }
  Widget CategoryDetails(List<Category> category,mediaQuery)=>ListView.separated(
    scrollDirection: Axis.vertical,

    itemCount: category.length,
    itemBuilder: (context, index) {
      return CategoryWidgetButton(category:  category[index]);
    },
    separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,);  },

  );
}
