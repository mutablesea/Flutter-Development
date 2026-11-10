class KhatianRecord {
  final int? id; // SQLite will automatically generate an ID
  final String khatianType; // CS, RS, SA, BRS, BDS, Kharij
  final String khatianNo; // Khatian number
  final String dagNo; // Dag (plot) number
  final String division; // Division (বিভাগ)
  final String district; // District / Jela (জেলা)
  final String upazila; // Upazila / Circle (উপজেলা / সার্কেল)
  final String mouza; // Mouza name
  final String ownershipType; // 'নিজস্ব মালিকানা' or 'উত্তরাধিকার সূত্রে'
  final double totalLandArea; // Total land area (in decimals)
  final String? imagePath; // Local path of the saved image
  final bool isTaxPaid; // Whether land development tax (খাজনা) is paid

  KhatianRecord({
    this.id,
    required this.khatianType,
    required this.khatianNo,
    required this.dagNo,
    this.division = 'ঢাকা (Dhaka)',
    this.district = '',
    this.upazila = '',
    required this.mouza,
    this.ownershipType = 'নিজস্ব মালিকানা',
    required this.totalLandArea,
    this.imagePath,
    this.isTaxPaid = false,
  });

  KhatianRecord copyWith({
    int? id,
    String? khatianType,
    String? khatianNo,
    String? dagNo,
    String? division,
    String? district,
    String? upazila,
    String? mouza,
    String? ownershipType,
    double? totalLandArea,
    String? imagePath,
    bool? isTaxPaid,
  }) {
    return KhatianRecord(
      id: id ?? this.id,
      khatianType: khatianType ?? this.khatianType,
      khatianNo: khatianNo ?? this.khatianNo,
      dagNo: dagNo ?? this.dagNo,
      division: division ?? this.division,
      district: district ?? this.district,
      upazila: upazila ?? this.upazila,
      mouza: mouza ?? this.mouza,
      ownershipType: ownershipType ?? this.ownershipType,
      totalLandArea: totalLandArea ?? this.totalLandArea,
      imagePath: imagePath ?? this.imagePath,
      isTaxPaid: isTaxPaid ?? this.isTaxPaid,
    );
  }

  // Method to convert the Object into a Map for saving in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'khatianType': khatianType,
      'khatianNo': khatianNo,
      'dagNo': dagNo,
      'division': division,
      'district': district,
      'upazila': upazila,
      'mouza': mouza,
      'ownershipType': ownershipType,
      'totalLandArea': totalLandArea,
      'imagePath': imagePath,
      'isTaxPaid': isTaxPaid ? 1 : 0,
    };
  }

  // Method to convert a Map from SQLite back into an Object
  factory KhatianRecord.fromMap(Map<String, dynamic> map) {
    return KhatianRecord(
      id: map['id'] as int?,
      khatianType: (map['khatianType'] as String?) ?? 'RS',
      khatianNo: (map['khatianNo'] as String?) ?? '',
      dagNo: (map['dagNo'] as String?) ?? '',
      division: (map['division'] as String?) ?? 'ঢাকা (Dhaka)',
      district: (map['district'] as String?) ?? '',
      upazila: (map['upazila'] as String?) ?? '',
      mouza: (map['mouza'] as String?) ?? '',
      ownershipType: (map['ownershipType'] as String?) ?? 'নিজস্ব মালিকানা',
      // Using num so both int and double values can be safely converted to double
      totalLandArea: ((map['totalLandArea'] as num?) ?? 0).toDouble(),
      imagePath: map['imagePath'] as String?,
      isTaxPaid: (map['isTaxPaid'] == 1 || map['isTaxPaid'] == true),
    );
  }
}
