class Notes {
  final int? noteId;
  final String? noteCategory;
  final String title;
  final String noteBody;
  final String? dateCreated;
  final String? dateUpdated;

  Notes({
    this.noteId,
    this.noteCategory,
    required this.title,
    required this.noteBody,
    this.dateCreated,
    this.dateUpdated,
  });
  // Convert a Notes into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'noteCategory': noteCategory,
      'title': title,
      'noteBody': noteBody,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      noteId: map['noteId'],
      noteCategory: map['noteCategory'],
      title: map['title'],
      noteBody: map['noteBody'],
      dateCreated: map['dateCreated'],
      dateUpdated: map['dateUpdated'],
    );
  }
}
