import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';

class TeamLeadScreen extends StatelessWidget {
  const TeamLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Lead', showBackButton: true,),

      body: SafeArea(
        child: ListView.builder(// To allow outer scroll
          itemCount: 5,
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          itemBuilder: (context, index) {

            return CustomContainer(
              border: false,
              margin: EdgeInsetsGeometry.only(top: 10),
              color: CustomColor.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name', style: textStyle12(context),),
                          Text('Lead Id:', style: textStyle12(context, fontWeight: FontWeight.w400),),
                          Row(
                            children: [
                              Text('Amount:', style: textStyle12(context, fontWeight: FontWeight.w400),),
                              10.width,
                              CustomAmountText(amount: '00', isLineThrough: true),
                              10.width,
                              CustomAmountText(amount: '00'),
                            ],
                          ),
                        ],
                      ),
                      Text('[ Peanding ]', style: textStyle12(context, color: CustomColor.descriptionColor),)
                    ],
                  ),
                  5.height,

                  Text('Exacted Earning: 5643',style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.greenColor),),
                  5.height,

                  DottedBorder(
                    padding: EdgeInsets.all(15),
                    color: CustomColor.greyColor,
                    dashPattern: [10, 5], // 6px line, 3px gap
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Lead Date',
                                style: textStyle14(context, color: CustomColor.descriptionColor),
                              ),
                              Text('00/00/25', style: textStyle14(context)),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Update Date',
                                style: textStyle14(context, color: CustomColor.descriptionColor),
                              ),
                              Text('00/00/25', style: textStyle14(context)),
                            ],
                          ),
                        ],
                      ),),
                  10.height,

                ],
              ),
            );
          },
        ),
      )
    );
  }
}

