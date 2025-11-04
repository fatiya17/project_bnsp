import 'package:flutter/material.dart';
import '../../core/routes/routes.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async'; // Untuk StreamSubscription

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? user;
  bool isLoading = true;

  // Variabel untuk Info Perangkat & Koneksi
  String _deviceName = 'Memuat...';
  String _osVersion = 'Memuat...';
  String _connectionStatus = 'Memuat...';
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Variabel untuk Sensor
  Color _sensorColor = Colors.white; // Warna default
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    // 1. Muat data user
    user = await _authService.getCurrentUser();

    // Muat Info Perangkat
    await _loadDeviceInfo();

    // 3. Setup listener Koneksi
    _checkInitialConnection();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectionStatus);

    // Setup listener Sensor
    _initSensor();

    setState(() => isLoading = false);
  }

  // Fungsi untuk Sensor Accelerometer
  void _initSensor() {
    _accelerometerSubscription =
        accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
            .listen((AccelerometerEvent event) {
      // Ambil nilai x (kanan/kiri)
      double x = event.x;

      Color newColor =
          // ignore: use_build_context_synchronously
          Theme.of(context).scaffoldBackgroundColor; // default

      // "Jika dimiringkan ke kiri/kanan makan ubah warna latar"
      if (x > 2.0) {
        // Miring ke kiri
        newColor = Colors.blue.shade100;
      } else if (x < -2.0) {
        // Miring ke kanan
        newColor = Colors.green.shade100;
      } else {
        // Posisi tengah
        if (mounted) {
          newColor = Theme.of(context).scaffoldBackgroundColor;
        }
      }

      if (_sensorColor != newColor) {
        setState(() {
          _sensorColor = newColor;
        });
      }
    });
  }

  // Fungsi untuk Info Perangkat
  Future<void> _loadDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown';
    String osVersion = 'Unknown';
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model; // Nama Perangkat
        osVersion = 'Android ${androidInfo.version.release}'; // Versi OS
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      }
    } catch (e) {
      deviceName = 'Gagal memuat';
      osVersion = 'Gagal memuat';
    }

    if (mounted) {
      setState(() {
        _deviceName = deviceName;
        _osVersion = osVersion;
      });
    }
  }

  // Fungsi untuk Info Koneksi (saat awal)
  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  // Fungsi untuk Info Koneksi (listener)
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    String status;
    if (results.contains(ConnectivityResult.mobile)) {
      status = 'Terhubung (Seluler)';
    } else if (results.contains(ConnectivityResult.wifi)) {
      status = 'Terhubung (Wi-Fi)';
    } else if (results.contains(ConnectivityResult.none)) {
      status = 'Offline'; // (Sesuai PDF) "Deteksi status offline"
    } else {
      status = 'Tidak Diketahui';
    }
    
    if (mounted) {
      setState(() {
        _connectionStatus = status;
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); // Hentikan listener
    _accelerometerSubscription?.cancel(); // Hentikan listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Latar belakang berubah berdasarkan sensor
    return Scaffold(
      backgroundColor: _sensorColor,
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileBody(theme),
    );
  }

  Widget _buildProfileBody(ThemeData theme) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Gagal memuat data pengguna.')),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // --- Foto Profil ---
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.secondary.withAlpha(50),
              child: Icon(
                Icons.person,
                size: 60,
                color: theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Nama & Email ---
          Text(
            user!.username, // Ganti dari name ke username
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user!.email,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),

          // --- Info Akun (Sesuaikan) ---
          _buildInfoItem(
            icon: Icons.badge_outlined,
            label: 'ID Pengguna',
            value: user!.id.toString(),
            context: context,
          ),
          _buildInfoItem(
            icon: Icons.account_circle_outlined,
            label: 'Username',
            value: user!.username,
            context: context,
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // --- Info Perangkat ---
          Text(
            'Info Perangkat & Jaringan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            icon: Icons.smartphone,
            label: 'Nama Perangkat', 
            value: _deviceName,
            context: context,
          ),
          _buildInfoItem(
            icon: Icons.settings_system_daydream,
            label: 'Versi OS', // (Sesuai PDF)
            value: _osVersion,
            context: context,
          ),
          _buildInfoItem(
            icon: _connectionStatus == 'Offline'
                ? Icons.signal_wifi_off
                : Icons.signal_wifi_4_bar,
            label: 'Koneksi Internet', 
            value: _connectionStatus,
            context: context,
          ),
          if (_connectionStatus == 'Offline')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Peringatan: Tidak ada koneksi internet!', // (Sesuai PDF)
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),

          const SizedBox(height: 32),

          // --- Tombol Aksi ---
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.error),
                foregroundColor: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (Widget helper untuk info item)
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // (Fungsi dialog logout)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Simpan navigator dan auth service sebelum async gap
              final navigator = Navigator.of(context);
              final authService = _authService;
              
              await authService.logout(); // Panggil API logout

              if (!mounted) return; // Cek mounted setelah await
              
              navigator.pop(); // Gunakan navigator yang disimpan
              navigator.pushReplacementNamed(AppRoutes.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}