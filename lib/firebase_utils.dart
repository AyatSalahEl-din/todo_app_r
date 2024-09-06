import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: ((snapshot, options) =>
                Task.fromJason(snapshot.data()!)),
            toFirestore: (task, options) => task.toJson());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollection(uId); //create collection
    var taskDocRef = taskCollection.doc(); //auto id 34an mb3t4 7aga
    task.id = taskDocRef.id; //auto id
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static Future<void> editTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).update(task.toJson());
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

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var snapshot = await getUsersCollection().doc(uId).get();
    return snapshot.data();
  }
}
