import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import '../../service/model/service_model.dart';

class CheckPaymentWidget extends StatefulWidget {
  final List<ServiceModel> services;
  final VoidCallback onPaymentDone;

  const CheckPaymentWidget({
    super.key,
    required this.services,
    required this.onPaymentDone,
  });

  @override
  State<CheckPaymentWidget> createState() => _CheckPaymentWidgetState();
}

class _CheckPaymentWidgetState extends State<CheckPaymentWidget> {
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
          padding: EdgeInsets.all(10),
          child: Text("Select Payment Method", style: textStyle14(context)),
        ),
        buildDebitAndCreditOption('Debit / Credit Card'),
        buildExpandableOption("Net Banking"),
        buildExpandableOption("UPI"),
        buildExpandableOption("Payment After Consultation"),
      ],
    );
  }

  Widget buildDebitAndCreditOption(String title) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      backgroundColor: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          backgroundColor: CustomColor.whiteColor,
          iconColor: CustomColor.appColor,
          shape: InputBorder.none,
          childrenPadding: EdgeInsets.zero,
          collapsedShape: InputBorder.none,
          leading: Icon(_getIcon(title), size: 20),
          title: Text(title,
              style: textStyle14(context, fontWeight: FontWeight.w400)),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  buildTextField(
                      controller: _cardNumberController,
                      label: 'Card Number',
                      keyboardType: TextInputType.number),
                  15.height,
                  Row(
                    children: [
                      Expanded(
                          child: buildTextField(
                              controller: _cvvController,
                              label: 'CVV/CVC No.',
                              keyboardType: TextInputType.number,
                              obscure: true)),
                      15.width,
                      Expanded(
                          child: buildTextField(
                              controller: _expiryController,
                              label: 'Valid Thru',
                              keyboardType: TextInputType.datetime)),
                    ],
                  ),
                  15.height,
                  buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      keyboardType: TextInputType.name),
                  10.height,
                  Row(
                    children: [
                      Checkbox(
                        activeColor: CustomColor.appColor,
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
                  15.height,
                  CustomButton(
                    label: 'Send OTP',
                    onPressed: () {

                      widget.onPaymentDone();
                    },
                  ),
                  20.height,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: textStyle12(context,
          color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textStyle12(context,
            color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)),
      ),
    );
  }

  Widget buildExpandableOption(String title) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      backgroundColor: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          backgroundColor: CustomColor.whiteColor,
          iconColor: CustomColor.appColor,
          shape: InputBorder.none,
          childrenPadding: EdgeInsets.zero,
          collapsedShape: InputBorder.none,
          leading: Icon(_getIcon(title), size: 20),
          title: Text(title,
              style: textStyle14(context, fontWeight: FontWeight.w400)),
          children: [ListTile(title: Text('Coming Soon...'))],
        ),
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
