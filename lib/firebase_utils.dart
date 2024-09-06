import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection() {
    return FirebaseFirestore.instance.collection('tasks').withConverter<Task>(
        fromFirestore: ((snapshot, options) =>
            Task.fromJason(snapshot.data()!)),
        toFirestore: (task, options) => task.toJson());
  }

  static Future<void> addTaskToFireStore(Task task) {
    var taskCollection = getTasksCollection(); //create collection
    var taskDocRef = taskCollection.doc(); //auto id 34an mb3t4 7aga
    task.id = taskDocRef.id; //auto id
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task) {
    return getTasksCollection().doc(task.id).delete();
  }

  static Future<void> editTaskFromFireStore(Task task) {
    return getTasksCollection().doc(task.id).update(task.toJson());
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: ((snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!)),
            toFirestore: ((user, options) => user.toFireStore()));
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }
}
