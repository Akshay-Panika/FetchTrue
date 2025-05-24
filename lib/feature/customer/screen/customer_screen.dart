import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final List<Map<String, String>> customers = const [
    {"name": "Akshay Kumar", "email": "akshay@example.com", "phone": "9876543210"},
    {"name": "Rahul Verma", "email": "rahul@example.com", "phone": "9123456780"},
    {"name": "Sneha Sharma", "email": "sneha@example.com", "phone": "9988776655"},
    {"name": "Anjali Mehta", "email": "anjali@example.com", "phone": "9090909090"},
  ];
  final Map<int, bool> _checkedCustomers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Customer List', showBackButton: true, showSearchIcon: true,),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            final isChecked = _checkedCustomers[index] ?? false;
            return CustomContainer(
              backgroundColor: CustomColor.whiteColor,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child:Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,    // disables ripple
                  highlightColor: Colors.transparent, // disables highlight
                ),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  backgroundColor: CustomColor.whiteColor,
                  iconColor: CustomColor.appColor,
                  shape: InputBorder.none,
                  childrenPadding: EdgeInsets.zero,
                  collapsedShape: InputBorder.none,
                  leading: CircleAvatar(backgroundImage: AssetImage(CustomImage.nullImage),),
                  title: Text('${customer['name']}', style: textStyle14(context),),
                  subtitle: Text('BizBooster Id : $index', style: textStyle12(context, color: CustomColor.descriptionColor),),
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Phone: ${customer['phone']}'),
                            Text('Email: ${customer['email']}'),
                            Text('Address: Address $index'),
                          ],
                        ),

                        Checkbox(
                          activeColor: CustomColor.appColor,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              _checkedCustomers[index] = value!;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
