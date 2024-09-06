import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/add_task_bot_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/user_provider.dart';

class TaskListItem extends StatefulWidget {
  Task task;
  TaskListItem({required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio: 0.25,

          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                var userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                FirebaseUtils.deleteTaskFromFireStore(
                        widget.task, userProvider.currentUser!.id)
                    .then((value) {
                  print('task deleted successfully');
                  listProvider
                      .getAllTasksFromFireStore(userProvider.currentUser!.id);
                }).timeout(Duration(seconds: 1), onTimeout: () {
                  print('task deleted successfully');
                  listProvider
                      .getAllTasksFromFireStore(userProvider.currentUser!.id);
                });
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
              spacing: 0,
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        AddTaskBottomSheet(task: widget.task));
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: AppLocalizations.of(context)!.edit,
              spacing: 0,
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
          ],
        ),

        child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: 4,
                    color: widget.task.isDone
                        ? AppColors.greenColor
                        : AppColors.primaryColor,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.task.title,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: widget.task.isDone
                                        ? AppColors.greenColor
                                        : AppColors.primaryColor,
                                  ),
                        ),
                        Text(
                          widget.task.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      style: IconButton.styleFrom(
                          backgroundColor: widget.task.isDone
                              ? Colors.transparent
                              : AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18))),
                      onPressed: () {
                        var userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        setState(() {
                          widget.task.isDone = !widget.task.isDone;
                          FirebaseUtils.editTaskFromFireStore(
                                  widget.task, userProvider.currentUser!.id)
                              .then((value) {
                            listProvider.getAllTasksFromFireStore(
                                userProvider.currentUser!.id);
                          }).timeout(
                            Duration(seconds: 1),
                            onTimeout: () {
                              print('task updated successfully');
                              listProvider.getAllTasksFromFireStore(
                                  userProvider.currentUser!.id);
                            },
                          );
                        });
                      },
                      icon: widget.task.isDone
                          ? Text(
                              "Done!",
                              style: TextStyle(
                                  color: AppColors.greenColor, fontSize: 18),
                            )
                          : Icon(
                              Icons.check,
                              color: AppColors.whiteColor,
                            )),
                ])),
      ),
    );
  }
}
