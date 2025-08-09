import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';

class WalletCardWidget extends StatefulWidget {
  const WalletCardWidget({super.key});

  @override
  State<WalletCardWidget> createState() => _WalletCardWidgetState();
}

class _WalletCardWidgetState extends State<WalletCardWidget> {

  bool isWalletApplied = false;

  @override
  Widget build(BuildContext context) {
    return  CustomContainer(
      color: CustomColor.whiteColor,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CustomAmountText(
                amount: '00.00',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: CustomColor.appColor,
              ),
              Text(
                'Wallet Balance',
                style: textStyle14(
                  context,
                  color: CustomColor.descriptionColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isWalletApplied = !isWalletApplied;
              });
            },
            child: Text(
              isWalletApplied ? 'Remove' : 'Apply',
              style: textStyle16(
                context,
                color: isWalletApplied
                    ? CustomColor.redColor
                    : CustomColor.greenColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
