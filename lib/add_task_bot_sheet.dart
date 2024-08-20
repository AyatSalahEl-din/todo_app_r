import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskBottomSheet extends StatelessWidget {
  String title = '';
  String description = '';
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(children: [
          Text(
            AppLocalizations.of(context)!.add_new_task,
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
                    child: Text("7/8/2024",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.blackColor,
                        )),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(AppLocalizations.of(context)!.add,
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
    if (formKey.currentState?.validate() == true) {}
  }
}
