import 'package:firebase_crud/controllers/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TodoController todoController = Get.put(TodoController());
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Firebase Crud Operation",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: todoController.tittle,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      hintText: "Enter Tittle",
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    todoController.addTodo();
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text("All Notes"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(
                () => ListView(
                    children: todoController.todoList
                        .map(
                          (element) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              onTap: () {},
                              title: Text(element.title.toString()),
                              trailing: SizedBox(
                                  width: 60,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          todoController.deleteTodo(
                                              element.id.toString());
                                        },
                                        child: const Icon(Icons.delete),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                          onTap: () {
                                            todoController.updatedTittle.text =
                                                element.title.toString();
                                            Get.defaultDialog(
                                              title: "update todo",
                                              content: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: todoController
                                                          .updatedTittle,
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor: Colors.white,
                                                        hintText:
                                                            "Enter Tittle",
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      todoController
                                                          .updateTodo(element);
                                                    },
                                                    child: Container(
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.deepPurple,
                                                      ),
                                                      child: const Icon(
                                                        Icons.done,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Icon(Icons.edit)),
                                    ],
                                  )),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
