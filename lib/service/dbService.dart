import 'package:note_app/model/category_model.dart';
import 'package:note_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService instance = DbService._init();
  static Database? _database;

  DbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initnuma('notes.db');
    return _database!;
  }
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.

  Future<Database> _initnuma(String filePath) async {
    final numaPath = await getDatabasesPath();
    final path = join(numaPath, filePath);

// Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createnuma,
    );
  }
  // When the database is first created, create a table to store notes.

  Future _createnuma(Database numa, int version) async {
    // Run the CREATE TABLE statement on the database.
    await numa.execute('''
    CREATE TABLE IF NOT EXISTS notes (
      noteId INTEGER PRIMARY KEY AUTOINCREMENT,
      noteCategory TEXT,
      title TEXT NOT NULL,
      noteBody TEXT NOT NULL,
      dateCreated TEXT,
      dateUpdated TEXT
    )
    ''');
    await numa.execute('''
    CREATE TABLE IF NOT EXISTS category (
      cateId INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryName TEXT,
      dateCreated TEXT
    
    )
    ''');
  }

// Define a function that inserts notes into the database
  Future<Notes> createNotes(Notes notes) async {
    final numa = await instance.database;
    final noteId = await numa.insert('notes', notes.toMap());
    return Notes(
        noteId: noteId,
        noteCategory: notes.noteCategory,
        title: notes.title,
        noteBody: notes.noteBody,
        dateCreated: notes.dateCreated,
        dateUpdated: notes.dateUpdated);
  }

// Define a function that inserts category into the database
  Future<Category> creatCategory(Category category) async {
    final numa = await instance.database;
    final cateId = await numa.insert('category', category.toMap());
    return Category(
      cateId: cateId,
      categoryName: category.categoryName,
      dateCreated: category.dateCreated,
    );
  }

// A method that retrieves all the notes from the dogs table.
  Future<List<Notes>> displayNotes() async {
    final numa = await instance.database;
    final result = await numa.query('notes');

    return result.map((json) => Notes.fromMap(json)).toList();
  }

  Future<List<Notes>> displayCategory() async {
    final numa = await instance.database;
    final result = await numa.query('category');

    return result.map((json) => Notes.fromMap(json)).toList();
  }

// update note fucntion where noteid matches
  Future<int> updateNotes(Notes notes) async {
    final numa = await instance.database;

    return numa.update(
      'notes',
      notes.toMap(),
      // Use a `where` clause to Update a specific Note.
      where: 'noteId = ?',
      // Pass  noteId as a whereArg to prevent SQL injection.
      whereArgs: [notes.noteId],
    );
  }

// function to search through column title and noteBody
  Future<List<Notes>> searchNotes(String searchText) async {
    final numa = await instance.database;
    final result = await numa.query(
      'notes',
      where: 'title LIKE ? OR noteBody LIKE ?',
      whereArgs: ['%$searchText%'],
    );

    return result.map((json) => Notes.fromMap(json)).toList();
  }

  Future<int> deleteNotes(int noteId) async {
    final numa = await instance.database;

    return await numa.delete(
      'notes',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
  }

  Future close() async {
    final numa = await instance.database;

    numa.close();
  }
}
