class EmployeeModel {
  final String name; // ERPNext Employee ID (e.g., EMP/001)
  final String employeeName;
  final String department;
  final String designation;
  final String? image;
  final String userId; // Email
  final String status;
  final String dateOfJoining;
  final String branch;

  EmployeeModel({
    required this.name,
    required this.employeeName,
    required this.department,
    required this.designation,
    this.image,
    required this.userId,
    required this.status,
    required this.dateOfJoining,
    required this.branch,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      name: json['name'] ?? '',
      employeeName: json['employee_name'] ?? '',
      department: json['department'] ?? 'N/A',
      designation: json['designation'] ?? 'N/A',
      image: json['image'],
      userId: json['user_id'] ?? '',
      status: json['status'] ?? '',
      dateOfJoining: json['date_of_joining'] ?? '',
      branch: json['branch'] ?? 'N/A',
    );
  }
}
