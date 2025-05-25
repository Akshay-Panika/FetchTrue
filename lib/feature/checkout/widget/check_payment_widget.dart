import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class CheckPaymentWidget extends StatefulWidget {
  @override
  _CheckPaymentWidgetState createState() => _CheckPaymentWidgetState();
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
          padding:  EdgeInsets.all(10),
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
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      backgroundColor: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,    // disables ripple
          highlightColor: Colors.transparent, // disables highlight
        ),
        child: ExpansionTile(
          backgroundColor: CustomColor.whiteColor,
          iconColor: CustomColor.appColor,
          shape: InputBorder.none,
          childrenPadding: EdgeInsets.zero,
          collapsedShape: InputBorder.none,
          leading: Icon(_getIcon(title), size: 20,),
          title: Text(title,style: textStyle14(context, fontWeight: FontWeight.w400),),
          children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [

                TextField(
                  controller: _cardNumberController,
                  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      labelText: 'Card Number',
                    labelStyle: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.grey.shade400)
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                15.height,

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cvvController,
                        style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(labelText: 'CVV/CVC No.',
                          labelStyle: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.grey.shade400)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                    15.width,
                    Expanded(
                      child: TextField(
                        controller: _expiryController,
                        style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(labelText: 'Valid Thru',
                          labelStyle: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.grey.shade400)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400)
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                15.height,

                TextField(
                  controller: _nameController,
                  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(labelText: 'Full Name',
                    labelStyle: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.grey.shade400)
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                  ),
                ),
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

                CustomButton(text: 'Send OTP',),
                20.height,
              ],
            ),
          )],
        ),
      ),
    );
  }

  Widget buildExpandableOption(String title) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      backgroundColor: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,    // disables ripple
          highlightColor: Colors.transparent, // disables highlight
        ),
        child: ExpansionTile(
          backgroundColor: CustomColor.whiteColor,
          iconColor: CustomColor.appColor,
          shape: InputBorder.none,
          childrenPadding: EdgeInsets.zero,
          collapsedShape: InputBorder.none,
          leading: Icon(_getIcon(title), size: 20,),
          title: Text(title,style: textStyle14(context, fontWeight: FontWeight.w400),),
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
