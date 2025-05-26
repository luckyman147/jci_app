import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';

import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../widgets/Activity/BodyAddActivity.dart';
import '../widgets/Functions/AddUpdateFunctions.dart';
import '../widgets/Functions/Listeners.dart';


class CreateUpdateActivityPage extends StatefulWidget {
  final String id;
  final String work;
  final String activity;
  final List<String> particpants;

  const CreateUpdateActivityPage(
      {Key? key, required this.id, required this.activity, required this.work, required this.particpants})
      : super(key: key);

  @override
  State<CreateUpdateActivityPage> createState() =>
      _CreateUpdateActivityPageState();
}


class _CreateUpdateActivityPageState extends State<CreateUpdateActivityPage> {

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ProfesseurName = TextEditingController();
  final TextEditingController _LocationController = TextEditingController(
      text: "Local JCI Hammam Sousse Menchia");
  final TextEditingController _Points = TextEditingController();
  final TextEditingController _price = TextEditingController();


  @override
  void initState() {
    AddUpdateFunctions.checkActivity(
        widget.work,
        widget.activity,
        context,
        widget.id,
        _price,
        widget.particpants,
        _LocationController,
        _Points,
        _namecontroller,
        _descriptionController,
        _ProfesseurName,
        mounted


    );

    context.read<MembersBloc>().add(const GetAllMembersEvent(false));
    context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    // TODO: implement initState
    super.initState();
  }

  //Form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);


    return Scaffold(

      body: SafeArea(
        child:  BlocListener<AddDeleteUpdateBloc,AddDeleteUpdateState>(
          listener: (context, state) {
            Listeners.Listener(state, context);
            // TODO: implement listener
          },

          child: BlocBuilder<AcivityFBloc, AcivityFState>(
            builder: (context, state) {
              return BlocBuilder<ActivityCubit, ActivityState>(
                builder: (context, sta) {
                  return BodyWidget(
                    id: widget.id,
                    formKey: _formKey,
                    nameController: _namecontroller,
                    descriptionController: _descriptionController,
                    professeurName: _ProfesseurName,
                    locationController: _LocationController,
                    pointsController: _Points,
                    priceController: _price,
                    work: widget.work,
                    participants: widget.particpants,
                    activityState: sta,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}




