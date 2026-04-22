class BranchModel {
  final String branchName;
  final double latitude;
  final double longitude;
  final double radius; // Dalam meter

  BranchModel({
    required this.branchName,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchName: json['name'] ?? '', 
      latitude: double.tryParse(json['custom_latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['custom_longitude']?.toString() ?? '0.0') ?? 0.0,
      radius: double.tryParse(json['custom_radius_meter']?.toString() ?? '500.0') ?? 500.0,
    );
  }
}
