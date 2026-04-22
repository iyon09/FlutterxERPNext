import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _leaveTypes = ['Annual Leave', 'Leave Without Pay', 'MC'];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD32F2F),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Permohonan Cuti",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BORANG PERMOHONAN
              const Text(
                "BORANG PERMOHONAN",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Jenis Cuti
                    const Text("Jenis Cuti", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedLeaveType,
                      hint: const Text("Pilih jenis cuti", style: TextStyle(fontSize: 14)),
                      decoration: _inputDecoration(),
                      items: _leaveTypes.map((String type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLeaveType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2 & 3. Tarikh Mula & Akhir
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tarikh Mula", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: _boxDecoration(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _startDate == null ? "Mula" : DateFormat('dd/MM/yyyy').format(_startDate!),
                                        style: TextStyle(fontSize: 14, color: _startDate == null ? Colors.grey : Colors.black),
                                      ),
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tarikh Akhir", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: _boxDecoration(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _endDate == null ? "Akhir" : DateFormat('dd/MM/yyyy').format(_endDate!),
                                        style: TextStyle(fontSize: 14, color: _endDate == null ? Colors.grey : Colors.black),
                                      ),
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4. Upload MC (Hanya jika MC dipilih)
                    if (_selectedLeaveType == 'MC') ...[
                      const Text("Muat Naik MC (Gambar/PDF)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          // Logik upload gambar di sini nanti
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 30),
                              const SizedBox(height: 8),
                              const Text("Klik untuk muat naik", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 5. Reason
                    const Text("Sebab", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: _inputDecoration(hint: "Masukkan sebab permohonan"),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        // Logik hantar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Hantar Permohonan"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // REKOD CUTI TERKINI
              const Text(
                "REKOD CUTI TERKINI",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  List<Map<String, String>> mockLeaves = [
                    {"type": "MC", "date": "10 Mei 2024", "status": "Approved", "color": "green"},
                    {"type": "Annual Leave", "date": "15 Mei 2024", "status": "Pending", "color": "orange"},
                    {"type": "Leave Without Pay", "date": "01 Mei 2024", "status": "Approved", "color": "green"},
                  ];
                  var leave = mockLeaves[index];
                  Color statusColor = leave['color'] == 'green' ? Colors.green : Colors.orange;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.calendar_today, color: statusColor, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leave['type']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                leave['date']!,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            leave['status']!,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFF8FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF8FAFB),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
