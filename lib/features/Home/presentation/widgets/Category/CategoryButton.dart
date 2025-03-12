import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';
import '../../../../../core/app_theme.dart';
import '../../../domain/entities/Category.dart';
import '../../../domain/enums/ActionImage.dart';

class CategoryWidgetButton extends StatelessWidget {
  final Category category;



  const CategoryWidgetButton({
    Key? key,
    required this.category,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width / 40),
          child: InkWell(
            onLongPress: (){
              showDialog(context: context, builder:
              (BuildContext context){
                return AlertDialog(
                  title: Text("Delete ${category.CategoryName}",style:
                  PoppinBold(18.sp,textColorBlack,TextDecoration.none)

                    ,),
                  content: Text("Are you sure you want to delete this category?",style: PoppinsNorml(14.sp,textColorBlack)),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel" ,style: PoppinBold(14.sp,ThirdColor,TextDecoration.none)),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        context.read<CategoryBloc>().add(DeleteCategoryEvent(id: category.CategoryId));
                        context.read<CategoryBloc>().add(GetAllCategoriesEvent());
                      },
                      child: Text("Delete",style: PoppinBold(14.sp,Colors.red,TextDecoration.none),
                    )),
                  ],
                );
              });


            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "#${category.CategoryName}",
                      style: PoppinBold(
                          18.sp,
                          textColorBlack,
                          TextDecoration.none),
                    ),Text(
                      category.NumberOfActivities.toString(),
                      style: PoppinsNorml(
                          14.sp,
                          textColorBlack,
                         ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.SelectedCategories .contains(category)
                        ? PrimaryColor
                        : Colors.white,
                    foregroundColor: state.SelectedCategories .contains(category)
                        ? textColorWhite
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    if (state.SelectedCategories .contains(category)) {
                      context
                          .read<CategoryBloc>()
                          .add(SelectCategoryEvent(ActionImage.DELETE, category: category));
                    } else {
                      context
                          .read<CategoryBloc>()
                          .add(SelectCategoryEvent(ActionImage.ADD, category: category));
                    }
                  },
                  child: Text(
                    'Select',
                    style: PoppinBold(
                      mediaQuery.size.width / 22,
                      state.SelectedCategories .contains(category)
                          ? textColorWhite
                          : textColorBlack,
                      TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
