import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OvertimePage extends StatefulWidget {
  const OvertimePage({super.key});

  @override
  State<OvertimePage> createState() => _OvertimePageState();
}

class _OvertimePageState extends State<OvertimePage> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _activityController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked; else _endTime = picked;
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
          "Permohonan Overtime",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "BORANG TUNTUTAN OT",
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
                  // Tarikh
                  const Text("Tarikh", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: _buildPickerBox(
                      _selectedDate == null ? "Pilih Tarikh" : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Masa Mula & Tamat
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Masa Mula", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectTime(context, true),
                              child: _buildPickerBox(
                                _startTime == null ? "Mula" : _startTime!.format(context),
                                Icons.access_time,
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
                            const Text("Masa Tamat", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectTime(context, false),
                              child: _buildPickerBox(
                                _endTime == null ? "Tamat" : _endTime!.format(context),
                                Icons.access_time,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Aktiviti/Sebab
                  const Text("Aktiviti / Sebab", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _activityController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Nyatakan kerja yang dilakukan",
                      filled: true,
                      fillColor: const Color(0xFFF8FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Hantar Tuntutan"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "REKOD OT TERKINI",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            _buildOTRecord("20 Mei 2024", "2 Jam", "Approved"),
            _buildOTRecord("18 Mei 2024", "1.5 Jam", "Pending"),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
          Icon(icon, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildOTRecord(String date, String duration, String status) {
    Color statusColor = status == "Approved" ? Colors.green : Colors.orange;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
