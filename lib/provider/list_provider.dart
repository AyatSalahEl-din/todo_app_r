import 'package:flutter/material.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  var selectDate = DateTime.now();

  //get all tasks
  void getAllTasksFromFireStore() async {
    //get btgeb kol 7aga mawgoda gwa el collection = doc w gwah eldata ely ana 3ayzaha
    var querySnapshot = await FirebaseUtils.getTasksCollection().get();
    //docs = list of query of tasks
    //List<Task> => List<QueryDocumentSnapshot<Task>>
    tasksList = querySnapshot.docs.map(
      (doc) {
        return doc.data();
      },
    ).toList();

    /*for (int i = 0; i < tasksList.length; i++) {
      print(tasksList[i].title);
    }*/
////////////////////////////////////////////////////////////////
    ///filter tasks => select date (user)
    //where ht3dy 3la kol taksaya mawgoda w trg3 boolean
    tasksList = tasksList.where((task) {
      if (selectDate.day == task.datetime.day &&
          selectDate.month == task.datetime.month &&
          selectDate.year == task.datetime.year) {
        return true;
      }
      return false;
    }).toList();
///////////////////////////////////////////////////////////////
    ///Sorting
    ///3ayzen nktb elno3 aw la mafe4 moshkla
    tasksList.sort((/*Task*/ task1, /*Task*/ task2) {
      return task1.datetime.compareTo(task2.datetime);
    });

    notifyListeners();
  }

  void changeSelectDate(DateTime newDate) {
    selectDate = newDate;
    getAllTasksFromFireStore();
    //notifyListeners();
  }
}
