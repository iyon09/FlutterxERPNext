import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final employee = userProvider.employee;

    // Get initials for Avatar
    String initials = "??";
    if (employee != null && employee.employeeName.isNotEmpty) {
      List<String> names = employee.employeeName.split(" ");
      if (names.length >= 2) {
        initials = (names[0][0] + names[1][0]).toUpperCase();
      } else {
        initials = names[0][0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Profil Saya",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFD32F2F),
                    child: Text(
                      initials, 
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    employee?.employeeName ?? "Memuatkan...", 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    employee?.userId ?? "---", 
                    style: const TextStyle(color: Colors.grey)
                  ),
                  const SizedBox(height: 24),
                  _buildProfileRow("ID Pekerja", employee?.name ?? "---"),
                  _buildProfileRow("Jawatan", employee?.designation ?? "---"),
                  _buildProfileRow("Jabatan", employee?.department ?? "---"),
                  _buildProfileRow("Cawangan", employee?.branch ?? "---"),
                  _buildProfileRow("Tarikh Sertai", employee?.dateOfJoining ?? "---"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                userProvider.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text("LOG KELUAR"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}
