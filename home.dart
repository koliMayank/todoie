import 'package:flutter/material.dart';
import 'package:todo_app/provider/todo_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final todoProvider = TodoProvider();

  @override
  void initState() {
    super.initState();
    todoProvider.getListItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          ListenableBuilder(
            listenable: todoProvider,
            builder: (context, _) {
              if (todoProvider.items.length > 1) {
                return IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Clear All Task?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No")),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      todoProvider
                                          .clearAllItem(todoProvider.items);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text("Yes")),
                            ],
                          ),
                        ),
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: Colors.white,
                    ));
              } else {
                return const Center();
              }
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
        backgroundColor: const Color(0xff63B2FF),
      ),
      body: ListenableBuilder(
        listenable: todoProvider,
        builder: (context, _) {
          if (todoProvider.items.isEmpty) {
            return const Center(
              child: Text(
                "Add New Task",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, i) => todoItemWidget(context, i),
              itemCount: todoProvider.items.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) => Padding(
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 40,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _itemNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter task name',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _itemDescriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter task description',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff63B2FF)),
                        onPressed: () {
                          if (_itemNameController.text.isNotEmpty) {
                            setState(() {
                              todoProvider.addItem(
                                  _itemNameController.text.trim(),
                                  _itemDescriptionController.text.trim());
                            });
                            _itemNameController.clear();
                            _itemDescriptionController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        backgroundColor: const Color(0xff63B2FF),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  ListTile todoItemWidget(BuildContext context, int i) {
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    height: 250,
                    width: 350,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      bottom: 10,
                      right: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Task Description",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            todoProvider.items[i].desc,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
      leading: ListenableBuilder(
        listenable: todoProvider,
        builder: (context, _) => IconButton(
          highlightColor: Colors.transparent,
          icon: todoProvider.items[i].status == 1
              ? const Icon(
                  Icons.check_box_outlined,
                  color: Color(0xff63B2FF),
                )
              : const Icon(
                  Icons.check_box_outline_blank_rounded,
                  color: Colors.black87,
                ),
          onPressed: () {
            setState(() {
              todoProvider.items[i].updateStatus(
                  todoProvider.items[i].status == 1 ? 0 : 1,
                  todoProvider.items[i].id!);
            });
          },
        ),
      ),
      title: Text(
        todoProvider.items[i].title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      trailing: IconButton(
        highlightColor: Colors.transparent,
        icon: const Icon(Icons.delete),
        onPressed: () {
          setState(() {
            todoProvider.removeItem(i, todoProvider.items[i].id!);
          });
        },
      ),
    );
  }
}
