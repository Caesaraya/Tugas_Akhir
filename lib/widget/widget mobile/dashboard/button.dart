// import 'package:flutter/material.dart';
// import 'package:tugas_akhir/controller/dashboard_controller.dart';
// import 'package:get/get.dart';

// class LoadMoreButton extends StatelessWidget {
//   final DashboardController ctrl;

//   const LoadMoreButton({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (!ctrl.hasMore) return const SizedBox.shrink();
//       if (ctrl.isLoadingMore.value) {
//         return const Padding(
//           padding: EdgeInsets.symmetric(vertical: 12),
//           child: CircularProgressIndicator(color: Colors.orange),
//         );
//       }
//       return SizedBox(
//         width: double.infinity,
//         child: OutlinedButton(
//           onPressed: ctrl.loadMore,
//           style: OutlinedButton.styleFrom(
//             side: const BorderSide(color: Colors.orange),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 12),
//           ),
//           child: const Text(
//             'Muat Lebih Banyak',
//             style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
//           ),
//         ),
//       );
//     });
//   }
// }
