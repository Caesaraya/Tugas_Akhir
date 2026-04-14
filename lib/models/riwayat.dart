class RiwayatModel {
  final String id;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final DateTime date;

  RiwayatModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
  });
}