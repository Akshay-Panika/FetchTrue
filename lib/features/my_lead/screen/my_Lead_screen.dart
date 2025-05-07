import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_amount_text.dart';
import 'lead_details_screen.dart';

class MyLeadScreen extends StatefulWidget {
  final String? isBack;
  const MyLeadScreen({super.key, this.isBack});

  @override
  State<MyLeadScreen> createState() => _MyLeadScreenState();
}

class _MyLeadScreenState extends State<MyLeadScreen> {
  final List<Map<String, dynamic>> allBookings = [
    {
      'id': '100300',
      'bookingDate': '30 Apr,2025 06:16 PM',
      'serviceDate': '30 Apr,2025 06:15 AM',
      'status': 'Completed',
      'amount': '24,999.00'
    },
    {
      'id': '100299',
      'bookingDate': '30 Apr,2025 04:42 PM',
      'serviceDate': '30 Apr,2025 04:42 AM',
      'status': 'Completed',
      'amount': '49,999.00'
    },
    {
      'id': '100298',
      'bookingDate': '30 Apr,2025 02:08 PM',
      'serviceDate': '30 Apr,2025 02:08 AM',
      'status': 'Pending',
      'amount': '5,999.00'
    },
    {
      'id': '100297',
      'bookingDate': '30 Apr,2025 12:26 PM',
      'serviceDate': '30 Apr,2025 12:26 PM',
      'status': 'Accepted',
      'amount': '9,999.00'
    },
    {
      'id': '100296',
      'bookingDate': '30 Apr,2025 10:00 AM',
      'serviceDate': '30 Apr,2025 11:00 AM',
      'status': 'Ongoing',
      'amount': '19,999.00'
    },
    {
      'id': '100297',
      'bookingDate': '30 Apr,2025 12:26 PM',
      'serviceDate': '30 Apr,2025 12:26 PM',
      'status': 'Accepted',
      'amount': '9,999.00'
    },
  ];

  String selectedFilter = 'All';

  List<Map<String, dynamic>> get filteredBookings {
    if (selectedFilter == 'All') return allBookings;
    return allBookings.where((b) => b['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Leads',
        showBackButton: widget.isBack =='isBack'?true:false, showNotificationIcon: true,),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildFilterChips(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  return _buildBookingCard(filteredBookings[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Accepted', 'Ongoing', 'Completed'];

    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilter == filters[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filters[index];
              });
            },
            child: CustomContainer(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
             // color: isSelected ? Colors.blueAccent : Colors.white,
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.blueAccent : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadDetailsScreen(),)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Name',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              //const Icon(Icons.more_vert, color: Colors.black54),
              _buildStatusBadge(booking['status']),
            ],
          ),
          Text(
            'Booking# ${booking['id']}',
            style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          Text('Booking Date : ${booking['bookingDate']}', style: const TextStyle(fontSize: 12)),
          Text('Service Date : ${booking['serviceDate']}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                spacing: 5,
                children: [
                  Text("Amount :",style: TextStyle(fontSize: 12,),),
                  CustomAmountText(amount:  booking['amount']),
                ],
              ),
              Text("Cashback : 00.0",style: TextStyle(fontSize: 12,),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'Completed') color = Colors.green;
    if (status == 'Pending') color = Colors.orange;
    if (status == 'Accepted') color = Colors.purple;
    if (status == 'Ongoing') color = Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(5),
        color: color.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 6),
          Text(
            status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
}
