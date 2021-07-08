class CategoryFields {
  static final List<String> values = [
    /// Add all fields
    categoryID,
    categoryName,
    categoryImage,
    display
  ];

  static final String categoryID = 'categoryID';
  static final String categoryName = 'categoryName';
  static final String categoryImage = 'categoryImage';
  static final String display = 'display';
}

class Category {
  String categoryID;
  String categoryName;
  String categoryImage;
  String display;

  Category(
      {this.categoryID, this.categoryImage, this.categoryName, this.display});

  static Category fromJson(Map<String, Object> json) => Category(
        categoryID: json[CategoryFields.categoryID] as String,
        categoryName: json[CategoryFields.categoryName] as String,
        categoryImage: json[CategoryFields.categoryImage] as String,
        display: json[CategoryFields.display] as String,
      );

  Map<String, Object> toJson() => {
        CategoryFields.categoryID: categoryID,
        CategoryFields.categoryName: categoryName,
        CategoryFields.categoryImage: categoryImage,
        CategoryFields.display: display
      };
}
