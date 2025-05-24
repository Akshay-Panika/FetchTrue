import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  final List<Map<String, String>> customers = const [
    {"name": "Akshay Kumar", "email": "akshay@example.com", "phone": "9876543210"},
    {"name": "Rahul Verma", "email": "rahul@example.com", "phone": "9123456780"},
    {"name": "Sneha Sharma", "email": "sneha@example.com", "phone": "9988776655"},
    {"name": "Anjali Mehta", "email": "anjali@example.com", "phone": "9090909090"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Customer List', showBackButton: true, showSearchIcon: true,),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final c = customers[index];
            return CustomContainer(
              backgroundColor: CustomColor.whiteColor,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                shape: InputBorder.none,
                leading: CircleAvatar(
                  radius: 25,
                    backgroundColor: CustomColor.canvasColor,
                    child: Text(c['name']![0])),
                title: Text(c['name']!),
                subtitle: Text(c['email']!),
                childrenPadding: const EdgeInsets.only(left: 72, right: 16, bottom: 12),
                expandedAlignment: Alignment.topLeft,
                children: [
                  Divider(),
                 Align(
                   alignment: Alignment.topLeft,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text('Phone: ${c['phone']}'),
                       Text('Address: Address $index'),
                     ],
                   ),
                 )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
