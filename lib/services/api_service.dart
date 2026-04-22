import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/employee_model.dart';
import '../models/branch_model.dart';
import '../core/constants/app_constants.dart';

/// Kelas ApiService menguruskan semua komunikasi rangkaian antara aplikasi dan ERPNext.
class ApiService {
  // Menggunakan tetapan dari AppConfig (Clean Code)
  final String baseUrl = AppConfig.baseUrl;
  final String apiToken = AppConfig.apiToken;

  /// Melakukan log masuk menggunakan e-mel dan kata laluan.
  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/method/login");
    
    print("--- DEBUG LOGIN START ---");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "usr": email,
          "pwd": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == "Logged In") {
          return UserModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  /// Mengambil butiran lengkap pekerja.
  Future<EmployeeModel?> getEmployeeDetails(String employeeId) async {
    final url = Uri.parse("$baseUrl/api/method/frappe.client.get");
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": apiToken,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "doctype": "Employee",
          "name": employeeId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EmployeeModel.fromJson(data['message']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Mencari ID Pekerja berdasarkan e-mel.
  Future<String?> getEmployeeIdByEmail(String email) async {
    final url = Uri.parse("$baseUrl/api/method/frappe.client.get_value");
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": apiToken,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "doctype": "Employee",
          "filters": {"user_id": email},
          "fieldname": "name"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] != null) {
          if (data['message'] is Map) {
            return data['message']['name'];
          }
          return data['message'].toString();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Mengambil senarai cawangan atau cawangan spesifik dengan koordinat custom.
  Future<List<BranchModel>> getBranches({String? branchName}) async {
    String fields = jsonEncode(["name", "custom_latitude", "custom_longitude", "custom_radius_meter"]);
    String urlString = "$baseUrl/api/resource/Branch?fields=$fields";
    
    // Aktifkan semula filter jika mahu tapis spesifik, tapi default ambil semua jika null
    if (branchName != null && branchName.isNotEmpty) {
      String filters = jsonEncode([["name", "=", branchName]]);
      urlString += "&filters=$filters";
    }

    final url = Uri.parse(urlString);
    
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": apiToken,
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = data['data'] ?? [];
        return list.map((item) => BranchModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Error Fetch Branches: $e");
      return [];
    }
  }

  /// Menghantar data Check-in atau Check-out ke ERPNext.
  /// [employeeId] - ID pekerja (cth: HR-EMP-00002)
  /// [isCheckIn] - true untuk "IN", false untuk "OUT"
  Future<bool> postAttendance({
    required String employeeId,
    required bool isCheckIn,
  }) async {
    final url = Uri.parse("$baseUrl/api/resource/Employee Checkin");
    
    // Format masa sekarang ke YYYY-MM-DD HH:mm:ss
    DateTime now = DateTime.now();
    String formattedTime = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": apiToken,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "employee": employeeId,
          "log_type": isCheckIn ? "IN" : "OUT",
          "time": formattedTime,
          "device_id": "Flutter_App_EKehadiran",
        }),
      );

      print("--- DEBUG POST ATTENDANCE ---");
      print("Payload: ${isCheckIn ? 'IN' : 'OUT'} for $employeeId at $formattedTime");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error Post Attendance: $e");
      return false;
    }
  }
}
