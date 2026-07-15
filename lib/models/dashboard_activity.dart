class DashboardActivity {
  final String jenisAktivitas;
  final String deskripsi;
  final String waktu;
  final String icon;

  DashboardActivity({
    required this.jenisAktivitas,
    required this.deskripsi,
    required this.waktu,
    required this.icon,
  });

  factory DashboardActivity.fromJson(Map<String, dynamic> json) {
    return DashboardActivity(
      jenisAktivitas: json['jenis_aktivitas'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      waktu: json['waktu'] ?? '',
      icon: json['icon'] ?? '📋',
    );
  }

  DashboardActivity copyWith({
    String? jenisAktivitas,
    String? deskripsi,
    String? waktu,
    String? icon,
  }) {
    return DashboardActivity(
      jenisAktivitas: jenisAktivitas ?? this.jenisAktivitas,
      deskripsi: deskripsi ?? this.deskripsi,
      waktu: waktu ?? this.waktu,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jenis_aktivitas': jenisAktivitas,
      'deskripsi': deskripsi,
      'waktu': waktu,
      'icon': icon,
    };
  }

  // Helper untuk format waktu
  String formatWaktu() {
    try {
      final dateTime = DateTime.parse(waktu);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Baru saja';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} menit lalu';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} jam lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari lalu';
      } else {
        // Format tanggal lengkap
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return waktu;
    }
  }

  // Helper untuk format waktu jam
  String formatJam() {
    try {
      final dateTime = DateTime.parse(waktu);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  // Helper untuk format tanggal
  String formatTanggal() {
    try {
      final dateTime = DateTime.parse(waktu);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return '';
    }
  }
}
