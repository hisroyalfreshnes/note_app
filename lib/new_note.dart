import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/home.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/service/dbService.dart';

class NewNotes extends StatefulWidget {
  const NewNotes({super.key});

  @override
  State<NewNotes> createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  late DbService dbCalls;
  final _formKey = GlobalKey<FormState>();
  String? _feildValue;
  final noteTitle = TextEditingController();
  final noteBody = TextEditingController();
  String? noteCategory;
  final viewDate = DateTime.now();
  var dates = "";

  @override
  void initState() {
    super.initState();
    dbCalls = DbService.instance;
  }

  @override
  void dispose() {
    super.dispose();
    noteBody.dispose();

    noteTitle.dispose();
  }

  void cleanText() {
    noteBody.clear();
    noteTitle.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Add new Notes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'No category',
                                border: OutlineInputBorder(),
                              ),
                              value: _feildValue,
                              items:
                                  ['Important', 'To-do-list', 'Shopping List']
                                      .map((option) => DropdownMenuItem(
                                            // onTap: () {
                                            //   setState(() {
                                            //     noteCategory = _feildValue;
                                            //   });
                                            // },
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  noteCategory = value;
                                });
                                // print("category ${noteCategory} ");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: noteTitle,
                              decoration: InputDecoration(
                                hintText: "Note Title",
                                fillColor: Colors.grey,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              maxLines: 10,
                              textAlignVertical: TextAlignVertical.top,
                              controller: noteBody,
                              decoration: InputDecoration(
                                hintText: "Start typing something",
                                fillColor: Colors.grey,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                    Color.fromARGB(255, 97, 89, 168)),
                              ),
                              onPressed: () async {
                                if (noteBody.text == '' ||
                                    noteBody.text.isEmpty) {
                                  // print("catnt save");
                                } else {
                                  setState(() {
                                    final cleanDate =
                                        DateFormat.yMMMMd().format(viewDate);
                                    final cleanTime =
                                        DateFormat('jm').format(viewDate);
                                    dates = "$cleanDate $cleanTime";
                                  });
                                  await dbCalls.createNotes(Notes(
                                    noteCategory: noteCategory,
                                    title: noteTitle.text,
                                    noteBody: noteBody.text,
                                    dateCreated: dates,
                                  ));

                                  cleanText();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NoteHome()));
                                  // print("note created $dates ");
                                }
                              },
                              child: const Text(
                                'Add a new note',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
