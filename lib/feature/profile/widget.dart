// import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
// import 'package:flutter/material.dart';
//
// class IndiaStateCityPicker extends StatefulWidget {
//   const IndiaStateCityPicker({super.key, required bool direction});
//
//   @override
//   State<IndiaStateCityPicker> createState() => _IndiaStateCityPickerState();
// }
//
// class _IndiaStateCityPickerState extends State<IndiaStateCityPicker> {
//   final bool _direction = false; // true = horizontal, false = vertical
//
//   String selectedState = "State";
//   String selectedCity = "City";
//
//   // ✅ India states (28)
//   final List<String> states = [
//     "Andhra Pradesh",
//     "Arunachal Pradesh",
//     "Assam",
//     "Bihar",
//     "Chhattisgarh",
//     "Goa",
//     "Gujarat",
//     "Haryana",
//     "Himachal Pradesh",
//     "Jharkhand",
//     "Karnataka",
//     "Kerala",
//     "Madhya Pradesh",
//     "Maharashtra",
//     "Manipur",
//     "Meghalaya",
//     "Mizoram",
//     "Nagaland",
//     "Odisha",
//     "Punjab",
//     "Rajasthan",
//     "Sikkim",
//     "Tamil Nadu",
//     "Telangana",
//     "Tripura",
//     "Uttar Pradesh",
//     "Uttarakhand",
//     "West Bengal",
//   ];
//
//   // ✅ Cities map (sample for demo)
//   final Map<String, List<String>> cities = {
//     "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Nashik"],
//     "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot"],
//     "Karnataka": ["Bengaluru", "Mysuru", "Mangaluru"],
//     "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Noida"],
//     "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior"],
//     "Rajasthan": ["Jaipur", "Udaipur", "Jodhpur", "Ajmer"],
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Flex(
//       direction: _direction ? Axis.horizontal : Axis.vertical,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _direction
//             ? Expanded(child: _buildPicker(selectedState, _selectState))
//             : _buildPicker(selectedState, _selectState),
//         SizedBox(width: _direction ? 10 : 0, height: _direction ? 0 : 10),
//         _direction
//             ? Expanded(child: _buildPicker(selectedCity, _selectCity))
//             : _buildPicker(selectedCity, _selectCity),
//       ],
//     );
//   }
//
//   // ✅ Picker widget
//   Widget _buildPicker(String label, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(5),
//       child: Container(
//         width: _direction ? null : double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: Colors.black),
//         ),
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label),
//             const Icon(Icons.arrow_drop_down),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ✅ Select State (with search)
//   void _selectState() async {
//     final state = await showDialog<String>(
//       context: context,
//       builder: (context) => _SearchableDialog(
//         title: "Select State",
//         items: states,
//       ),
//     );
//
//     if (state != null) {
//       setState(() {
//         selectedState = state;
//         selectedCity = "City"; // reset city when state changes
//       });
//     }
//   }
//
//   // ✅ Select City (with search)
//   void _selectCity() async {
//     if (selectedState == "State") {
//       showCustomToast('Please select a State first');
//       return;
//     }
//
//     final availableCities = cities[selectedState] ?? ["No cities found"];
//
//     final city = await showDialog<String>(
//       context: context,
//       builder: (context) => _SearchableDialog(
//         title: "Select City ($selectedState)",
//         items: availableCities,
//       ),
//     );
//
//     if (city != null) {
//       setState(() {
//         selectedCity = city;
//       });
//     }
//   }
// }
//
// /// ✅ Reusable Searchable Dialog (with Not Found message)
// class _SearchableDialog extends StatefulWidget {
//   final String title;
//   final List<String> items;
//
//   const _SearchableDialog({required this.title, required this.items});
//
//   @override
//   State<_SearchableDialog> createState() => _SearchableDialogState();
// }
//
// class _SearchableDialogState extends State<_SearchableDialog> {
//   late List<String> filteredItems;
//   String query = "";
//
//   @override
//   void initState() {
//     super.initState();
//     filteredItems = widget.items;
//   }
//
//   void _filter(String value) {
//     setState(() {
//       query = value;
//       filteredItems = widget.items
//           .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.title),
//       content: SizedBox(
//         width: double.maxFinite,
//         height: 400,
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(
//                 hintText: "Search...",
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: _filter,
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: filteredItems.isEmpty
//                   ? const Center(
//                 child: Text(
//                   "No results found",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: filteredItems.length,
//                 itemBuilder: (context, index) {
//                   final item = filteredItems[index];
//                   return ListTile(
//                     title: Text(item),
//                     onTap: () => Navigator.pop(context, item),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
