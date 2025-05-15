import 'package:flutter/material.dart';
import 'package:note_app/ViewNote.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/service/dbService.dart';

class SearchNote extends StatefulWidget {
  const SearchNote({super.key});

  @override
  State<SearchNote> createState() => _SearchNoteState();
}

class _SearchNoteState extends State<SearchNote> {
  late DbService dbCalls;
  // late Future<List<Notes>> notes;

  final searchText = TextEditingController();
  List<Notes> _notes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    dbCalls = DbService.instance;
  }

  Future<void> _fetchNotes() async {
    final notes = await dbCalls.searchNotes(_searchQuery);
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Search Note")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: searchText,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchText.text = '';
                            },
                          ),
                          prefixIcon: GestureDetector(
                            onTap: () async {
                              if (searchText.text != '') {
                                setState(() {
                                  _searchQuery = searchText.text;
                                });
                                _fetchNotes();
                              }
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          ),
                          hintText: "tap on the search icon to search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    print("note is: ${note.title}");
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.noteBody),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewNote(
                                      noteTitle: note.title,
                                      noteBody: note.noteBody,
                                      noteId: note.noteId,
                                      noteCategory: note.noteCategory,
                                      dateCreated: note.dateCreated,
                                      dateUpdated: note.dateUpdated,
                                    )));
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
