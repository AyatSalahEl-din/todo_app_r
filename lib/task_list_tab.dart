import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/task_list_item.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<Task> tasksList = [];

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore();
    }
    return Column(
      children: [
        EasyDateTimeLine(
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            listProvider.changeSelectDate(selectedDate);
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
          ),
          dayProps: const EasyDayProps(
            dayStructure: DayStructure.dayStrDayNumMonth,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 232, 57, 191),
                    Color.fromARGB(255, 39, 181, 188),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: listProvider.tasksList.isEmpty
              ? Text('No Tasks Added')
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return TaskListItem(
                      task: listProvider.tasksList[index],
                    );
                  },
                  itemCount: listProvider.tasksList.length,
                ),
        )
      ],
    );
  }
}
