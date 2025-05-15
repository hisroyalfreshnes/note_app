import 'package:flutter/material.dart';
import 'package:note_app/ViewNote.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/new_note.dart';
import 'package:note_app/search_note.dart';
import 'package:note_app/service/dbService.dart';
import 'package:note_app/theme/theme_provider.dart';
import 'package:note_app/wigets/category_card.dart';
import 'package:note_app/wigets/date_card.dart';
import 'package:note_app/wigets/note_cards.dart';
import 'package:note_app/wigets/sidebar.dart';
import 'package:provider/provider.dart';

class NoteHome extends StatefulWidget {
  const NoteHome({super.key});

  @override
  State<NoteHome> createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  late Future<List<Notes>> notes;
  late DbService dbCalls;

  @override
  void initState() {
    super.initState();
    dbCalls = DbService.instance;
    reloadNotes();
  }

  void reloadNotes() {
    if (mounted) {
      setState(() {
        notes = dbCalls.displayNotes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final searchText = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.light_mode),
                Switch(
                  activeColor: isDarkMode ? Colors.grey[850] : Colors.white,
                  value: isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(value),
                ),
                const Icon(Icons.dark_mode),
              ],
            ),
          ],
        ),
        drawer: const SideBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "2025",
                          style: TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            "May",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchNote()));
                  },
                  controller: searchText,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "search for notes",
                    fillColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DateCard(
                      isDarkMode: isDarkMode,
                      dateDay: "Sun",
                      dateWeek: "11",
                    ),
                    DateCard(
                      isDarkMode: isDarkMode,
                      dateDay: "Mon",
                      dateWeek: "12",
                    ),
                    DateCard(
                      isDarkMode: isDarkMode,
                      dateDay: "Tue",
                      dateWeek: "13",
                    ),
                    DateCard(
                      isDarkMode: isDarkMode,
                      dateDay: "Wed",
                      dateWeek: "14",
                    ),
                    DateCard(
                      isDarkMode: isDarkMode,
                      dateDay: "Thur",
                      dateWeek: "15",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "All",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CategoryCard(
                        isDarkMode: isDarkMode,
                        categoryText: "Important",
                      ),
                      CategoryCard(
                        isDarkMode: isDarkMode,
                        categoryText: "To-do-list",
                      ),
                      CategoryCard(
                        isDarkMode: isDarkMode,
                        categoryText: "Shopping list",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<Notes>>(
                  future: notes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No note saved'));
                    }
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final notes = snapshot.data![index];
                        // Notes model = Notes.fromMap(
                        //     snapshot.data![index] as Map<String, dynamic>);

                        return Padding(
                            padding: const EdgeInsets.only(left: 14, top: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewNote(
                                              noteId: notes.noteId!,
                                              noteCategory: notes.noteCategory,
                                              noteBody: notes.noteBody,
                                              noteTitle: notes.title,
                                              dateCreated: notes.dateCreated,
                                              dateUpdated: notes.dateUpdated,
                                            )));
                              },
                              child: NoteCard(
                                cardTitle: notes.title,
                                cardBody: notes.noteBody,
                                cardCreated: '${notes.dateCreated}',
                                // DateFormat.yMMMEd().format(
                                //     DateTime.parse(
                                //         notes.dateCreated.toString()))),
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
            tooltip: "Add Note",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewNotes()));
            },
            child: const Icon(
              Icons.add,
              size: 30,
            )),
      ),
    );
  }
}
