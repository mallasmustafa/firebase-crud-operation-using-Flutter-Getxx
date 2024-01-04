import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TodoController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getTodo();
  }

  TextEditingController tittle = TextEditingController();
  TextEditingController updatedTittle = TextEditingController();
  final uId = Uuid();
  final db = FirebaseFirestore.instance;
  RxList<TodoModel> todoList = RxList<TodoModel>();

  Future<void> addTodo() async {
    String id = uId.v4();
    var newTodo = TodoModel(
      id: id,
      title: tittle.text,
    );
    await db.collection("todo").doc(id).set(
          newTodo.toJson(),
        );
    print("Todo add data base");
    tittle.clear();
    getTodo();
  }

  Future<void> getTodo() async {
    todoList.clear();
    await db.collection("todo").get().then(
      (allTodo) {
        for (var todo in allTodo.docs) {
          todoList.add(
            TodoModel.fromJson(
              todo.data(),
            ),
          );
        }
      },
    );
  }

  Future<void> deleteTodo(String id) async {
    await db.collection("todo").doc(id).delete();
    print("todo deleted");
    getTodo();
  }

  Future<void> updateTodo(TodoModel todo) async {
    var updatedTodo = TodoModel(
      id: todo.id,
      title: updatedTittle.text,
    );
    await db.collection("todo").doc(todo.id).set(updatedTodo.toJson());
    Get.back();
    getTodo();
    print("todo updated");
  }
}
