class Category {
  final int? cateId;
  final String? categoryName;
  final String? dateCreated;

  Category({
    this.cateId,
    this.categoryName,
    this.dateCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'cateId': cateId,
      'categoryName': categoryName,
      'dateCreated': dateCreated,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      cateId: map['cateId'],
      categoryName: map['categoryName'],
      dateCreated: map['dateCreated'],
    );
  }
}
