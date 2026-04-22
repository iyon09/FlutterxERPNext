import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/employee_model.dart';

/// UserProvider menguruskan 'state' atau data pengguna secara global.
/// Ia membolehkan data pekerja diakses dari mana-mana skrin tanpa perlu dihantar secara manual.
class UserProvider with ChangeNotifier {
  UserModel? _user;
  EmployeeModel? _employee;

  // Getter untuk mendapatkan data pengguna dan pekerja.
  UserModel? get user => _user;
  EmployeeModel? get employee => _employee;

  /// Menetapkan data user (selepas login berjaya).
  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // Memberitahu semua UI yang mendengar (listening) supaya dikemaskini.
  }

  /// Menetapkan butiran profil pekerja dari ERPNext.
  void setEmployee(EmployeeModel employee) {
    _employee = employee;
    notifyListeners();
  }

  /// Mengosongkan data apabila pengguna log keluar.
  void logout() {
    _user = null;
    _employee = null;
    notifyListeners();
  }
}
