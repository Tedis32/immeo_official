// Data model class
class BarcodeEntity {
  int id = -1;
  String data = "0000";
  String title = "New Barcode";
  bool featured = false;

  static final String idField = '_id';
  static final String dataField = 'barcode';
  static final String titleField = 'title';
  static final String featuredField = 'featured';

  BarcodeEntity();

  // convenience constructor to create a Word object
  BarcodeEntity.fromMap(Map<String, dynamic> map) {
    id = map[idField];
    data = map[dataField];
    title = map[titleField] != null ? map[titleField] : title;
    featured = map[featuredField] != null ? map[featuredField] == 1 : featured;
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      dataField: data,
      titleField: title,
      featuredField: featured,
    };
    if (id != -1) {
      map[idField] = id;
    }
    return map;
  }

  String toString() {
    return '_id: $id, _data: $data, title: $title, featured: $featured';
  }
}
