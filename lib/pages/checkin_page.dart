import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/branch_model.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  // State Data
  List<BranchModel> _branches = [];
  BranchModel? _selectedBranch;
  double _slideValue = 0.0;
  bool isCheckedIn = false;
  final Color primaryRed = const Color(0xFFD32F2F);

  // Map & Location State
  LatLng _currentPosition = const LatLng(3.1390, 101.6869);
  bool _isLoading = true;
  final MapController _mapController = MapController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  /// Memulakan data cawangan dan lokasi pengguna
  Future<void> _initData() async {
    setState(() => _isLoading = true);
    
    // 1. Dapatkan lokasi semasa dahulu
    await _determinePosition();
    
    // 2. Ambil SEMUA data cawangan dari API
    final branches = await _apiService.getBranches();
    
    setState(() {
      _branches = branches;
      if (_branches.isNotEmpty) {
        // Secara default, pilih cawangan pertama atau yang sepadan dengan profil
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final employeeBranchName = userProvider.employee?.branch;
        
        _selectedBranch = _branches.firstWhere(
          (b) => b.branchName == employeeBranchName,
          orElse: () => _branches[0],
        );
      }
      _isLoading = false;
    });

    // Gerakkan peta ke cawangan yang terpilih
    if (_selectedBranch != null) {
      _mapController.move(LatLng(_selectedBranch!.latitude, _selectedBranch!.longitude), 14.0);
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  /// Mengira jika pengguna berada dalam radius cawangan
  bool _isInsideRadius() {
    if (_selectedBranch == null) return false;
    
    double distance = Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      _selectedBranch!.latitude,
      _selectedBranch!.longitude,
    );

    return distance <= _selectedBranch!.radius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text("Check-in Kehadiran", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // 1. MAP DENGAN BULATAN RADIUS
                Container(
                  height: 280,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(initialCenter: _currentPosition, initialZoom: 14),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.zne.ekehadiran.app',
                        ),
                        if (_selectedBranch != null)
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: LatLng(_selectedBranch!.latitude, _selectedBranch!.longitude),
                                radius: _selectedBranch!.radius,
                                useRadiusInMeter: true,
                                color: Colors.blue.withValues(alpha: 0.15),
                                borderColor: Colors.blue.withValues(alpha: 0.4),
                                borderStrokeWidth: 2,
                              ),
                            ],
                          ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentPosition,
                              child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                            ),
                            if (_selectedBranch != null)
                              Marker(
                                point: LatLng(_selectedBranch!.latitude, _selectedBranch!.longitude),
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. PILIHAN CAWANGAN (DINAMIK DARI API)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "PILIH LOKASI KEHADIRAN",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 16),
                        // Menggunakan Wrap untuk menyusun butang di tengah (Center)
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12, // Jarak mendatar antara butang
                          runSpacing: 10, // Jarak menegak jika butang turun ke baris baru
                          children: _branches.map((branch) {
                            bool isSelected = _selectedBranch?.branchName == branch.branchName;
                            
                            return AnimatedScale(
                              scale: isSelected ? 1.08 : 1.0, // Animasi membesar sedikit bila dipilih
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutBack,
                              child: ChoiceChip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(branch.branchName),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedBranch = branch;
                                      _mapController.move(LatLng(branch.latitude, branch.longitude), 14.0);
                                    });
                                  }
                                },
                                backgroundColor: Colors.grey.shade50,
                                selectedColor: primaryRed.withValues(alpha: 0.12),
                                labelStyle: TextStyle(
                                  color: isSelected ? primaryRed : Colors.black54,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(
                                    color: isSelected ? primaryRed : Colors.grey.shade300,
                                    width: isSelected ? 1.8 : 1,
                                  ),
                                ),
                                elevation: isSelected ? 2 : 0,
                                pressElevation: 4,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 3. STATUS RADIUS
                if (_selectedBranch != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_isInsideRadius() ? Icons.check_circle : Icons.cancel, color: _isInsideRadius() ? Colors.green : Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isInsideRadius() 
                                ? "Anda berada dalam zon ${_selectedBranch?.branchName}" 
                                : "Di luar zon ${_selectedBranch?.branchName} (Radius: ${_selectedBranch?.radius.toInt()}m)",
                              style: TextStyle(color: _isInsideRadius() ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // 4. SLIDER PENGESAHAN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isInsideRadius() ? Colors.white : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [if (_isInsideRadius()) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double maxSlide = constraints.maxWidth - 70;
                        return Stack(
                          children: [
                            Center(
                              child: Text(
                                !_isInsideRadius() ? "LOKASI TIDAK SAH" : (isCheckedIn ? "SLIDE UNTUK CHECK-OUT" : "SLIDE UNTUK CHECK-IN"),
                                style: TextStyle(fontWeight: FontWeight.bold, color: _isInsideRadius() ? Colors.grey : Colors.red.shade300),
                              ),
                            ),
                            Positioned(
                              left: _slideValue * maxSlide,
                              child: GestureDetector(
                                onHorizontalDragUpdate: _isInsideRadius() ? (details) {
                                  setState(() {
                                    _slideValue += details.delta.dx / maxSlide;
                                    if (_slideValue < 0) _slideValue = 0;
                                    if (_slideValue > 1) _slideValue = 1;
                                  });
                                } : null,
                                onHorizontalDragEnd: (details) async {
                                  if (_slideValue > 0.8) {
                                    // Ambil Employee ID dari Provider
                                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                                    final employeeId = userProvider.employee?.name; // 'name' adalah ID seperti HR-EMP-00002

                                    if (employeeId == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Ralat: ID Pekerja tidak dijumpai. Sila login semula.")),
                                      );
                                      setState(() => _slideValue = 0.0);
                                      return;
                                    }

                                    // Tunjukkan loading sekejap
                                    setState(() => _isLoading = true);

                                    // Hantar ke API (isCheckIn adalah !isCheckedIn kerana kita nak tukar status)
                                    bool success = await _apiService.postAttendance(
                                      employeeId: employeeId,
                                      isCheckIn: !isCheckedIn, 
                                    );

                                    setState(() {
                                      _slideValue = 0.0;
                                      _isLoading = false;
                                      if (success) {
                                        isCheckedIn = !isCheckedIn;
                                      }
                                    });

                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(isCheckedIn ? "Berjaya Check-in di ${_selectedBranch?.branchName}!" : "Berjaya Check-out!"),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: isCheckedIn ? Colors.green : Colors.orange,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Gagal menghantar kehadiran ke server. Sila cuba lagi."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    setState(() => _slideValue = 0.0);
                                  }
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: !_isInsideRadius() ? Colors.grey : (isCheckedIn ? Colors.orange : primaryRed),
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                                  ),
                                  child: Icon(isCheckedIn ? Icons.logout : Icons.arrow_forward_ios, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }
}
