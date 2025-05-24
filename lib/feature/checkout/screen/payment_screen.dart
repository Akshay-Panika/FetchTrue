import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  bool _saveDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Select Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
        ),

        buildCardPaymentForm(),
        10.height,
        buildExpandableOption("Net Banking"),
        buildExpandableOption("UPI"),
        buildExpandableOption("Payment After Consultation"),
      ],
    );
  }

  Widget buildCardPaymentForm() {
    return CustomContainer(
      border: true,
      backgroundColor: CustomColor.whiteColor,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.credit_card),
              10.width,
              Text("Debit / Credit Card", style: textStyle14(context)),
            ],
          ),
         10.height,
          TextField(
            controller: _cardNumberController,
            decoration: InputDecoration(labelText: 'Card Number'),
            keyboardType: TextInputType.number,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  decoration: InputDecoration(labelText: 'CVV/CVC No.'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
             20.width,
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  decoration: InputDecoration(labelText: 'Valid Thru'),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ],
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Full Name'),
          ),

          20.height,
          Row(
            children: [
              Checkbox(
                value: _saveDetails,
                onChanged: (value) {
                  setState(() {
                    _saveDetails = value!;
                  });
                },
              ),
              Text("Save details for future"),
            ],
          ),
         CustomButton(text: 'Send OTP',),
          20.height,
        ],
      ),
    );
  }

  Widget buildExpandableOption(String title) {
    return CustomContainer(
      border: true,
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      backgroundColor: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        backgroundColor: CustomColor.whiteColor,
        iconColor: CustomColor.appColor,
        shape: InputBorder.none,
        childrenPadding: EdgeInsets.zero,
        leading: Icon(_getIcon(title)),
        title: Text(title),
        children: [ListTile(title: Text('Coming Soon...'))],
      ),
    );
  }

  IconData _getIcon(String title) {
    switch (title) {
      case "Net Banking":
        return Icons.account_balance;
      case "UPI":
        return Icons.currency_rupee;
      case "Payment After Consultation":
        return Icons.people;
      default:
        return Icons.payment;
    }
  }
}

class StepperHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StepCircle(label: "Details", isActive: false),
        StepCircle(label: "Payment", isActive: true),
        StepCircle(label: "Complete", isActive: false),
      ],
    );
  }
}

class StepCircle extends StatelessWidget {
  final String label;
  final bool isActive;

  const StepCircle({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
          child: Icon(
            label == "Details"
                ? Icons.list
                : label == "Payment"
                ? Icons.account_balance_wallet
                : Icons.check,
            color: isActive ? Colors.white : Colors.black54,
          ),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
