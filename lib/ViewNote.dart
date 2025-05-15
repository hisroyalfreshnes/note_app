import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/home.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/service/dbService.dart';

class ViewNote extends StatefulWidget {
  final int? noteId;
  final String? noteCategory;
  final String noteTitle;
  final String noteBody;
  final String? dateCreated;
  final String? dateUpdated;
  const ViewNote(
      {super.key,
      this.noteId,
      required this.noteTitle,
      required this.noteBody,
      this.noteCategory,
      this.dateCreated,
      this.dateUpdated});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

enum Options { option1, option2, option3 }

class _ViewNoteState extends State<ViewNote> {
  late DbService dbCalls;
  final _formKey = GlobalKey<FormState>();
  final viewDate = DateTime.now();

  String? _feildValue;
  final viewTitle = TextEditingController();
  final viewBody = TextEditingController();
  var dates = "";

  late Future<List<Notes>> notes;

  @override
  void initState() {
    super.initState();
    dbCalls = DbService.instance;
    reloadNotes();
  }

  void reloadNotes() {
    setState(() {
      notes = dbCalls.displayNotes();
    });
  }

  Options? optionSelected = Options.option1;
  void showSheet() async {
    final result = await showModalBottomSheet<Options>(
      context: context,
      builder: (BuildContext context) {
        Options? selectedOption = optionSelected;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 600,
              child: Column(
                children: [
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Add new category"),
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  RadioListTile<Options>(
                    title: const Text('Important'),
                    value: Options.option1,
                    groupValue: selectedOption,
                    onChanged: (Options? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<Options>(
                    title: const Text('To-do-list'),
                    value: Options.option2,
                    groupValue: selectedOption,
                    onChanged: (Options? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<Options>(
                    title: const Text('Shopping list'),
                    value: Options.option3,
                    groupValue: selectedOption,
                    onChanged: (Options? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(255, 86, 85, 85),
                    ),
                    height: 20,
                    width: 300,
                    child: const Center(
                      child: Text("Save"),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        optionSelected = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    viewTitle.text = widget.noteTitle;
    viewBody.text = widget.noteBody;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
                onTap: () {
                  showSheet();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("add category"),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "View Notes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await dbCalls.deleteNotes(widget.noteId!);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NoteHome()));
                          // print("Note deleted");
                        },
                      ),
                    )
                  ],
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
                              decoration: InputDecoration(
                                labelText: (widget.noteCategory == null
                                    ? 'No category'
                                    : '${widget.noteCategory}'),
                                // '${widget.noteCategory}',
                                border: const OutlineInputBorder(),
                              ),
                              value: _feildValue,
                              items:
                                  ['Important', 'To-do-list', 'Shopping List']
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _feildValue = value;
                                });
                              },
                              // validator: (value) {
                              //   if (value == null) {
                              //     return 'Please select an option';
                              //   }
                              //   return null;
                              // },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: viewTitle,
                              decoration: InputDecoration(
                                hintText: "Note Title",
                                fillColor:
                                    const Color.fromARGB(255, 176, 169, 169),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 4, color: Colors.white12),
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
                              controller: viewBody,
                              decoration: InputDecoration(
                                // hintText: "Start typing something",
                                fillColor: Colors.grey,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 4, color: Colors.white12),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text("Date created:"),
                                ),
                                Text(
                                  "${widget.dateCreated}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text("Last update:"),
                                ),
                                Text(
                                  (widget.dateUpdated == null
                                      ? ''
                                      : '${widget.dateUpdated}')
                                  // "${widget.dateUpdated}"
                                  ,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                    Color.fromARGB(255, 95, 94, 102)),
                              ),
                              onPressed: () async {
                                if (viewBody.text == '' ||
                                    viewBody.text.isEmpty) {
                                  // print("catnt save");
                                } else {
                                  setState(() {
                                    final cleanDate =
                                        DateFormat.yMMMMd().format(viewDate);
                                    final cleanTime =
                                        DateFormat('jm').format(viewDate);
                                    dates = "$cleanDate $cleanTime";
                                  });

                                  await dbCalls.updateNotes(Notes(
                                    noteCategory: widget.noteCategory,
                                    title: viewTitle.text,
                                    noteBody: viewBody.text,
                                    noteId: widget.noteId,
                                    dateCreated: widget.dateCreated,
                                    dateUpdated: dates,
                                  ));

                                  // print("note Updated $dates ");

                                  // await dbCalls.update(Notes(id: student.id, name: name, age: age));
                                }
                                // _refreshStudentList();
                                // Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Update note',
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
