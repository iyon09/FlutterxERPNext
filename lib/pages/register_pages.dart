import 'package:flutter/material.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  // Pembolehubah (Variables) untuk tema dan keadaan (state)
  final Color primaryRed = const Color(0xFFD32F2F); // Warna utama aplikasi
  bool _obscureText = true; // Untuk sorok/papar kata laluan (Password visibility)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Warna latar belakang cerah (off-white)
      
      // AppBar: Bar di bahagian atas skrin
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0, // Buang bayang (shadow) bawah AppBar supaya nampak rata (flat)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Fungsi untuk kembali ke skrin sebelumnya (Login)
        ),
      ),
      
      // SingleChildScrollView: Supaya skrin boleh di-scroll jika keyboard muncul atau skrin kecil
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Container(
              width: double.infinity, // Ambil lebar penuh skrin
              padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60), // Buat lengkungan cantik di bawah kiri
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Susun teks ke kiri
                children: [
                  Text(
                    "Daftar Akaun",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sila isi maklumat anda di bawah",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30), // Jarak antara header dan borang

            // --- FORM SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Margin kiri & kanan
              child: Column(
                children: [
                  // Nama Penuh
                  _buildInputLabel("Nama Penuh"),
                  _buildTextField(hint: "Nama mengikut IC", icon: Icons.person_outline),
                  
                  const SizedBox(height: 15),
                  
                  // ID Pekerja
                  _buildInputLabel("ID Pekerja / Emel"),
                  _buildTextField(hint: "contoh: staff123", icon: Icons.badge_outlined),
                  
                  const SizedBox(height: 15),
                  
                  // Kata Laluan
                  _buildInputLabel("Kata Laluan"),
                  _buildTextField(
                    hint: "Minimum 6 aksara",
                    icon: Icons.lock_outline,
                    isPassword: true, // Set true untuk aktifkan fungsi sorok teks
                    
                  ),

                  const SizedBox(height: 15),

                  _buildInputLabel("Maklumat"),
                  // _buildTextField(hint: "OWOWOW", icon: icon : Icons.badgest_outline),
                  _buildTextField(hint: "contoh: staff123", icon: Icons.search_off),

                  const SizedBox(height: 30),

                  // --- SUBMIT BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Di sini nanti anda akan letak logik untuk simpan data ke database
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Bucu butang bulat sedikit
                        ),
                      ),
                      child: const Text(
                        "DAFTAR SEKARANG",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // --- NAVIGATION LINK ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Susun teks di tengah
                    children: [
                      const Text("Sudah ada akaun? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context), // Kembali ke skrin Login
                        child: Text(
                          "Log Masuk",
                          style: TextStyle(
                            color: primaryRed, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Ruang ekstra di bawah skrin
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS (Fungsi untuk kurangkan kod berulang) ---

  // Fungsi untuk buat Label di atas kotak input
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          label, 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
      ),
    );
  }

  // Fungsi untuk buat Kotak Input (TextField) yang cantik
  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          // Tambah bayang halus supaya kotak nampak 'timbul'
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 5)
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword ? _obscureText : false, // Logik sorok/papar teks
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryRed), // Ikon di sebelah kiri
          suffixIcon: isPassword 
            ? IconButton(
                // Ikon mata di sebelah kanan (hanya untuk password)
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () {
                  // Tukar status _obscureText bila ikon ditekan
                  setState(() => _obscureText = !_obscureText);
                },
              )
            : null,
          border: InputBorder.none, // Buang garisan bawah default TextField
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}