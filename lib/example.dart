import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  Box? notepad;

  @override
  void initState() {
    notepad = Hive.box('notepad');
    super.initState();
  }

  TextEditingController _textController = TextEditingController();
  TextEditingController _textUpdateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: "write something"),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final userInput = _textController.text;
                      await notepad!.add(userInput);
                      print("Data added successfully");
                      print("text is : ${userInput}");
                      _textController.clear();
                    } catch (e) {
                      print("Error: ${e.toString()}");
                    }
                  },
                  child: Text("Add Data"),
                )),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: Hive.box('notepad').listenable(),
                    builder: (context, box, widget) {
                      return ListView.builder(
                          itemCount: notepad!.keys.toList().length,
                          itemBuilder: (_, index) {
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(notepad!.getAt(index).toString()),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return Dialog(
                                                    child: Container(
                                                      height: 150,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(20.0),
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              controller:
                                                                  _textUpdateController,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "write something"),
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: () async {
                                                                  final updatedDate= _textUpdateController.text;
                                                                  notepad!.putAt(index, updatedDate);
                                                                  _textUpdateController.clear();
                                                                  Navigator.pop(context);
                                                                },
                                                                child:
                                                                    Text("Update"))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            await notepad!.deleteAt(index);
                                            print("deleted ${index}");
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }))
          ],
        ),
      ),
    );
  }
}
