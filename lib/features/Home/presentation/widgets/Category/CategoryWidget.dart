import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/features/Home/domain/entities/Category.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Category/CategoryButton.dart';

import '../../../Activity_Global.dart';
import 'CategoryBottomSheet.dart';


class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key, required this.vis,
  });

  final ActivityState vis;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            "Category".tr(context),
            style: PoppinsRegular(18, textColorBlack),
          ),
        ),
        SizedBox(
            width: mediaQuery.size.width * 1.2,
            child: const CategoryField(
            )),
      ],
    );
  }
}

class CategoryField extends StatelessWidget {


  const CategoryField({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () {
          context.read<CategoryBloc>().add(throwError(message: ""));
          context.read<CategoryBloc>().add(GetAllCategoriesEvent());

          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return CategoryBottomSheet(); // Pass necessary parameters if needed
            },
          );
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryInputFieldf(state),
                Visibility(visible: state.error.isNotEmpty,child: Text(state.error,style: ErrorStyle(18, Colors.red),),)
                ,
              ],
            );
          },
        ),
      ),
    );
  }

  Container CategoryInputFieldf(CategoryState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color:state.error.isEmpty? ThirdColor:Colors.red,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: SizedBox(
          width: double.infinity,
          height: 30.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child:
            (state.SelectedCategories.isEmpty) ?

            Text(
              "Select Categories",
              style: PoppinsNorml(18, ThirdColor),
            ) :


            ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Text(
                  "#${state.SelectedCategories[index].CategoryName}",
                  style: PoppinsSemiBold(18, PrimaryColor, TextDecoration.none),
                );
              },
              separatorBuilder: (context, _) => const SizedBox(width: 10.0),
              // Adjusted to use a fixed width
              itemCount: state.SelectedCategories.length,
            ),
          ),
        ),
      ),
    );
  }
}

