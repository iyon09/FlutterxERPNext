import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkin_page.dart';
import 'leave_page.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'overtime_pages.dart';
import 'notifications_page.dart';
import '../providers/user_provider.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final employee = userProvider.employee;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "E-Kehadiran",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFD32F2F)),
              accountName: Text(employee?.employeeName ?? "Memuatkan...", style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(employee?.userId ?? "---"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  employee != null && employee.employeeName.isNotEmpty ? employee.employeeName.substring(0, 1).toUpperCase() : "?", 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F))
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text("Utama"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text("Check-in"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text("Permohonan Cuti"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LeavePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.more_time_outlined),
              title: const Text("Permohonan Overtime"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OvertimePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Profil Saya"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log Keluar", style: TextStyle(color: Colors.red)),
              onTap: () {
                userProvider.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GREETING DYNAMIC
            Text(
              "SELAMAT DATANG, ${employee?.employeeName.toUpperCase() ?? 'PENGGUNA'}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              "${employee?.designation ?? '---'} | ${employee?.department ?? '---'}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // 1. ANNOUNCEMENT BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFEF5350)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.campaign, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PENGUMUMAN HR",
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sila kemaskini maklumat profil anda sebelum 31 Mei.",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. KAD STATUS DINAMIK
            const Text(
              "STATUS HARI INI",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Masa Bekerja", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        SizedBox(height: 4),
                        Text("08:30 AM - Sekarang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Check-out", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. RINGKASAN & CUTI UMUM
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "RINGKASAN MEI",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Cuti Seterusnya: 3 Jun",
                    style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard("Hadir", "20", Colors.green),
                const SizedBox(width: 12),
                _buildStatCard("Lewat", "02", Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard("Cuti", "01", Colors.blue),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              "MENU UTAMA",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            _buildMenuTile(
              context,
              "Check-in Kehadiran",
              "Sahkan lokasi dan waktu kerja anda",
              Icons.qr_code_scanner,
              const Color(0xFFD32F2F),
              const CheckInPage(),
            ),
            _buildMenuTile(
              context,
              "Permohonan Cuti",
              "Mohon cuti tahunan, sakit atau kecemasan",
              Icons.calendar_month,
              Colors.orange,
              const LeavePage(),
            ),
            _buildMenuTile(
              context,
              "Permohonan Overtime",
              "Tuntut elaun kerja lebih masa anda",
              Icons.more_time_outlined,
              Colors.blueGrey,
              const OvertimePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, String subtitle, IconData icon, Color color, Widget targetPage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        },
      ),
    );
  }
}
