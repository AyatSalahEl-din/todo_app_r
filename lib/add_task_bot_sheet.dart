import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  Task? task;

  AddTaskBottomSheet({this.task});
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  String title = '';

  String description = '';

  var selectDate = DateTime.now();

  var formKey = GlobalKey<FormState>();

  late ListProvider listProvider;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      selectDate = widget.task!.datetime;
    } else {
      selectDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(children: [
          Text(
            widget.task != null
                ? AppLocalizations.of(context)!.edit_task
                : AppLocalizations.of(context)!.add_new_task,
            style: TextStyle(fontSize: 22),
          ),
          Form(
              key: formKey, //refrence 3la ay 7aga gwaha
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        initialValue: title,
                        style: TextStyle(
                          color: AppColors.backgroundDarkColor,
                        ),
                        onChanged: (text) {
                          title = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter task title';
                          }
                          return null; ////valid
                        },
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.enter_task_title,
                          labelStyle: TextStyle(fontSize: 15),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: description,
                      style: TextStyle(
                        color: AppColors.backgroundDarkColor,
                      ),
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task description';
                        }
                        return null; /////valid
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .enter_task_description,
                          labelStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.select_date,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showCalender();
                      },
                      child: Text(
                          "${selectDate.day}/"
                          "${selectDate.month}/"
                          "${selectDate.year}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.blackColor,
                          )),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (widget.task != null) {
                          editTask();
                        } else {
                          addTask();
                        }
                      },
                      child: Text(
                          widget.task != null
                              ? AppLocalizations.of(context)!.edit
                              : AppLocalizations.of(context)!.add,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          )))
                ],
              ))
        ]),
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Task task = Task(
        title: title,
        description: description,
        datetime: selectDate,
      );
      FirebaseUtils.addTaskToFireStore(task).timeout(
        Duration(seconds: 1),
        onTimeout: () {
          print('task added successfully');
          listProvider.getAllTasksFromFireStore();
          Navigator.pop(context);
        },
      );
    }
  }

//////////////////////////////////////////////////////////////
  void editTask() {
    if (formKey.currentState?.validate() == true) {
      Task updatedTask = Task(
        id: widget.task!.id,

        ///el ID zay ma hwa
        title: title,
        description: description,
        datetime: selectDate,
      );
      FirebaseUtils.editTaskFromFireStore(updatedTask).timeout(
        Duration(seconds: 1),
        onTimeout: () {
          print('task edited successfully');
          listProvider.getAllTasksFromFireStore();
          Navigator.pop(context);
        },
      );
    }
  }

//////////////////////////////////////////////////////////////
  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    /*if (chosenDate != null) {
      selectDate = chosenDate;
    }*/
    selectDate = chosenDate ?? selectDate;
    setState(() {});
  }
}
