// Data model class
class Barcode {
  int id = 0;
  String data = "";

  static final String idField = '_id';
  static final String dataField = 'barcode';

  Barcode();

  // convenience constructor to create a Word object
  Barcode.fromMap(Map<String, dynamic> map) {
    id = map[idField];
    data = map[dataField];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      dataField: data,
    };
    if (id != null) {
      map[idField] = id;
    }
    return map;
  }

  String toString() {
    return '_id: $id, _data: $data';
  }
}
