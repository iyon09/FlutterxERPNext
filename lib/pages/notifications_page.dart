import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          // Contoh data notifikasi
          List<Map<String, String>> mockNotifications = [
            {
              "title": "Cuti Diluluskan",
              "desc": "Permohonan cuti tahunan anda pada 15 Mei telah diluluskan.",
              "time": "2 jam yang lalu",
              "type": "success"
            },
            {
              "title": "Peringatan Check-in",
              "desc": "Jangan lupa untuk melakukan check-in sebelum jam 09:00 AM.",
              "time": "5 jam yang lalu",
              "type": "warning"
            },
            {
              "title": "Overtime Disahkan",
              "desc": "Tuntutan OT anda untuk tarikh 20 Mei telah disahkan oleh HR.",
              "time": "Semalam",
              "type": "info"
            },
            {
              "title": "Kemaskini Profil",
              "desc": "Sila pastikan maklumat peribadi anda adalah yang terkini.",
              "time": "2 hari lepas",
              "type": "info"
            },
            {
              "title": "Cuti Umum",
              "desc": "Syarikat akan ditutup pada 3 Jun sempena Hari Keputeraan Agong.",
              "time": "3 hari lepas",
              "type": "info"
            },
          ];

          var notif = mockNotifications[index % mockNotifications.length];
          
          IconData icon;
          Color iconColor;
          
          switch (notif['type']) {
            case 'success':
              icon = Icons.check_circle_outline;
              iconColor = Colors.green;
              break;
            case 'warning':
              icon = Icons.error_outline;
              iconColor = Colors.orange;
              break;
            default:
              icon = Icons.info_outline;
              iconColor = Colors.blue;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              title: Text(
                notif['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notif['desc']!,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notif['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
