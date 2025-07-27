import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Activity_Global.dart';
import '../../bloc/PageIndex/page_index_bloc.dart';
import '../../bloc/Poll/cubit/poll_cubit.dart';
import '../../bloc/Poll/poll_bloc.dart';
import '../Functions/ActivityDetailsFunctions.dart';

class AddPollDialog extends StatefulWidget {
  final String ActivityId;

  const AddPollDialog({Key? key, required this.ActivityId}) : super(key: key);

  @override
  _AddPollDialogState createState() => _AddPollDialogState();
}

class _AddPollDialogState extends State<AddPollDialog> {
  // Controllers
  final PageController _pageController = PageController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController optionController = TextEditingController();
final _formKey = GlobalKey<FormState>();
  // Method to switch between pages
  void switchPage(int page) {
    context.read<PageIndexBloc>().add(SetSectionEvent(section: page));
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        return BlocBuilder<PollBloc, PollState>(
  builder: (context, sta) {
    return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          title: _buildDialogTitle(state,sta), // Dialog Title
          content: _buildDialogContent(), // Dialog Content
          actions: _buildDialogActions(state), // Dialog Actions
        );
  },
);
      },
    );
  }

  /// Builds the dialog title with a switch button.
  Widget _buildDialogTitle(PageIndexState state,PollState pollstate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          state.section == 0 ? 'Create Poll' : 'Select Template',
          style: PoppinsRegular(16.sp, ColorsApp.textColorBlack),
        ),
        Row(
          children: [
            Visibility(
              visible: state.section == 0,
              child: IconButton(
                icon: Icon(
                  pollstate.isSelected ? Icons.bookmark : Icons.bookmark_border, // Conditional icon
                  color: pollstate.isSelected ? ColorsApp.SecondaryColor : ColorsApp.ThirdColor,
                ),
                onPressed: () {
                  context.read<PollBloc>().add(
                    ChangeIsSelected(isSelected: !pollstate.isSelected),
                  );
                },
              ),
            ).animate(
              effects: [
                const FadeEffect(
                  duration: Duration(milliseconds: 300),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                switchPage(state.section == 0 ? 1 : 0);
                if (state.section == 0) {
                  titleController.clear();
                  optionController.clear();
                }
              },
              icon: Icon(
                state.section == 0
                    ? Icons.drive_file_move
                    : Icons.add_circle_outline,
                color: ColorsApp.ThirdColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the main dialog content with two pages (Create Poll and Select Template).
  Widget _buildDialogContent() {
    return SizedBox(
      width: double.maxFinite,
      height: 400, // Adjust as needed
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: [
          _buildPollCreationPage(context), // Page 1: Create Poll
          _buildPollTemplatesPage(context), // Page 2: Select Template
        ],
      ),
    );
  }

  /// Builds the dialog actions (Cancel and Submit buttons).
  List<Widget> _buildDialogActions(PageIndexState state) {
    return [
      // Cancel button
      TextButton(
        onPressed: () {
          context.read<PollBloc>().add(CancelPollEvent());
          Navigator.of(context).pop();
        },
        child: Text(
          'Cancel',
          style: PoppinsSemiBold(
              13.sp, ColorsApp.ThirdColor, TextDecoration.none),
        ),
      ),
      // Submit button (only shown on Create Poll page)
      if (state.section == 0)
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate() ||
                context.read<PollBloc>().state.options.isEmpty) {
              return;
            }
            ActivityDetailsFunctions.AddPollDFunction(
              context,
              widget.ActivityId,
              titleController,
              optionController,
              context.read<PollBloc>().state.isSelected,
            );
          },
          child: Text(
            'Submit Poll',
            style: PoppinsSemiBold(
                13.sp, ColorsApp.PrimaryColor, TextDecoration.none),
          ),
        ),
    ];
  }

  /// Builds the Create Poll page with inputs for poll title and options.
  Widget _buildPollCreationPage(BuildContext context) {
    return BlocBuilder<PollBloc, PollState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poll Title Input
              Form(
                key: _formKey,
                child: TextFormField(
                  style: PoppinsRegular(16.sp, ColorsApp.textColorBlack),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },

                  controller: titleController,
                  decoration: PollInput("Poll Title"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Poll Options',
                  style: PoppinsRegular(16.sp, ColorsApp.textColorBlack),
                ),
              ),
              // Save as Template Checkbox

              // Add Option Input
              TextField(
                controller: optionController,
                decoration: PollInput(
                  "Add an Option",
                  optionController: optionController,
                  iconExisted: true,
                  AddOption: () {
                    ActivityDetailsFunctions.AddOption(
                        context, optionController);
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Display List of Options
              if (state.options.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: AutoSizeText(
                              "${index + 1}-${state.options[index].title}",
                              style: PoppinsRegular(
                                  14.sp, ColorsApp.textColorBlack),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: ThirdColor,size: 20,),
                            onPressed: () {
                              context.read<PollBloc>().add(
                                  DeleteOptionEvent(
                                      pollOptions: state.options[index]));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the Select Template page with a list of templates.
  Widget _buildPollTemplatesPage(BuildContext context) {
    return BlocBuilder<PollBloc, PollState>(
      builder: (context, state) {
        final templates = state
            .Templates; // Assume state has a list of templates
        if (templates.isEmpty) {
          return Center(
            child: Text(
              "No templates available",
              style: PoppinsRegular(16.sp, ColorsApp.textColorBlack),
            ),
          );
        }

        return BlocProvider(
          create: (_) => PollCubit(),
          child: BlocBuilder<PollCubit, Map<int,bool>>(
            builder: (context, expandedState) {
              return ListView.builder(
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final isExpanded = expandedState[index] ?? false;

                  return Column(
                    children: [
                      ListTile(
                        title: AutoSizeText("${index+1}-${templates[index].title}",
                          style: PoppinsRegular(
                              14.sp, ColorsApp.textColorBlack),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: ColorsApp.PrimaryColor,
                          ),
                          onPressed: () {
                            context.read<PollCubit>().toggleExpand(index);
                          },
                        ),
                        onTap: () {
                          context.read<PollBloc>().add(
                              CancelPollEvent());
                          for (var option in templates[index].options) {
                            context.read<PollBloc>().add(
                              AddOptionEvent(pollOptions: option),
                            );
                          }
                          titleController.text = templates[index].title;
                          context.read<PollBloc>().add(
                            ChangeIsSelected(isSelected: false),

                          );
                          switchPage(0);



                          // Handle template selection
                          //  context.read<PollBloc>().add(
                          //  LoadTemplateEvent(template: templates[index]),
                          //);
                          // Close dialog after selection
                        },
                      ),
                      if (isExpanded)
                        SizedBox(
                          height: templates[index].options.length * 50.0,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.separated(itemCount: templates[index].options.length, separatorBuilder: (ctx,index)=>const SizedBox(height: 2,), itemBuilder: (BuildContext context, int ind) {
                              return ListTile(
                                title: Text("${ind+1}- ${templates[index].options[ind].title}",
                                  style: PoppinsRegular(
                                      14.sp, ColorsApp.textColorBlack),
                                ),
                              );
                            }, ),
                          ),
                        ),
                      const Divider(), // To separate each template
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
