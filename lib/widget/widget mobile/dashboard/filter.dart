// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tugas_akhir/controller/dashboard_controller.dart';

// class FilterBottomSheet extends StatefulWidget {
//   const FilterBottomSheet({super.key});

//   @override
//   State<FilterBottomSheet> createState() => FilterBottomSheetState();
// }

// class FilterBottomSheetState extends State<FilterBottomSheet> {
//   final DashboardController controller = Get.find<DashboardController>();

//   late SortType selected;

//   @override
//   void initState() {
//     super.initState();
//     selected = controller.selectedSort.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [

//           const Text(
//             "Urutkan Berdasarkan",
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           const SizedBox(height: 20),

//           RadioListTile<SortType>(
//             title: const Text("Harga Terendah ke Tertinggi"),
//             value: SortType.lowToHigh,
//             groupValue: selected,
//             onChanged: (value) {
//               setState(() {
//                 selected = value!;
//               });
//             },
//           ),

//           RadioListTile<SortType>(
//             title: const Text("Harga Tertinggi ke Terendah"),
//             value: SortType.highToLow,
//             groupValue: selected,
//             onChanged: (value) {
//               setState(() {
//                 selected = value!;
//               });
//             },
//           ),

//           const SizedBox(height: 20),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 controller.setSortType(selected);
//                 Get.back();
//               },
//               child: const Text("Terapkan"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }