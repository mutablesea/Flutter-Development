class KhatianRecord {
  final int? id; // SQLite will automatically generate an ID
  final String khatianType; // CS, RS, SA, BRS, Kharij
  final String khatianNo; // Khatian number
  final String dagNo; // Dag (plot) number
  final String mouza; // Mouza name
  final double totalLandArea; // Total land area (in decimals)
  final String? imagePath; // Local path of the saved image

  KhatianRecord({
    this.id,
    required this.khatianType,
    required this.khatianNo,
    required this.dagNo,
    required this.mouza,
    required this.totalLandArea,
    this.imagePath,
  });

  // Method to convert the Object into a Map for saving in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'khatianType': khatianType,
      'khatianNo': khatianNo,
      'dagNo': dagNo,
      'mouza': mouza,
      'totalLandArea': totalLandArea,
      'imagePath': imagePath,
    };
  }

  // Method to convert a Map from SQLite back into an Object
  factory KhatianRecord.fromMap(Map<String, dynamic> map) {
    return KhatianRecord(
      id: map['id'] as int?,
      khatianType: map['khatianType'] as String,
      khatianNo: map['khatianNo'] as String,
      dagNo: map['dagNo'] as String,
      mouza: map['mouza'] as String,
      // Using num so both int and double values can be safely converted to double
      totalLandArea: (map['totalLandArea'] as num).toDouble(),
      imagePath: map['imagePath'] as String?,
    );
  }
}
