import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_pages.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final Color primaryRed = const Color(0xFFD32F2F);
  final Color bgColor = const Color(0xFFF4F7F9);
  bool _obscureText = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sila masukkan e-mel dan kata laluan")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 1. Login to get User session
    final user = await _apiService.login(email, password);

    if (user != null) {
      // 2. Get Employee ID by email
      final employeeId = await _apiService.getEmployeeIdByEmail(email);
      
      if (employeeId != null) {
        // 3. Get full Employee details
        final employee = await _apiService.getEmployeeDetails(employeeId);
        
        if (employee != null) {
          if (!mounted) return;
          
          // Save to Provider
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);
          userProvider.setEmployee(employee);

          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Selamat Datang, ${employee.employeeName}!")),
          );
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePages()),
          );
          return;
        }
      }
    }

    setState(() => _isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Log masuk gagal. Sila semak semula e-mel atau kata laluan anda.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Icon(Icons.business_center_rounded, size: 60, color: primaryRed),
              ),
              const SizedBox(height: 24),
              const Text(
                "Kehadiran Desk",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Text(
                "Log masuk ke akaun ERPNext anda",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("E-MEL / ID"),
                    _buildInputField(
                      controller: _emailController,
                      hint: "nama@syarikat.com", 
                      icon: Icons.person_outline
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("KATA LALUAN"),
                    _buildInputField(
                      controller: _passwordController,
                      hint: "••••••••", 
                      icon: Icons.lock_outline, 
                      isPassword: true
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Text("LOG MASUK", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint, 
    required IconData icon, 
    bool isPassword = false
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        suffixIcon: isPassword 
          ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            )
          : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFB),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryRed.withOpacity(0.5)),
        ),
      ),
    );
  }
}
