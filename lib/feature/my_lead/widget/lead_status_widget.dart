import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/my_lead/model/lead_status_model.dart';
import 'package:fetchtrue/feature/my_lead/repository/lead_status_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';

class LeadStatusWidget extends StatefulWidget {
  final String bookingId;
  const LeadStatusWidget({super.key, required this.bookingId});

  @override
  State<LeadStatusWidget> createState() => _LeadStatusWidgetState();
}

class _LeadStatusWidgetState extends State<LeadStatusWidget> {
  bool isLoading = true;
  List<LeadData> leadStatus = [];

  @override
  void initState() {
    super.initState();
    getLeadStatusData();
  }

  Future<void> getLeadStatusData() async {
    try {
      final response = await LeadStatusService.fetchLeadStatus();

      // ✅ Correct matching with bookingId
      LeadStatusModel? filtered;
      for (var element in response) {
        if (element.checkout != null &&
            element.checkout!.id == widget.bookingId) {
          filtered = element;
          break;
        }
      }

      if (filtered != null) {
        leadStatus = filtered.leads;
      } else {
        print("❌ No matching bookingId found: ${widget.bookingId}");
      }
    } catch (e) {
      print('❌ Error fetching lead status: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LinearProgressIndicator(
        backgroundColor: CustomColor.appColor,
        color: Colors.white,
        minHeight: 2.5,
      );
    }

    if (leadStatus.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 300.0),
        child: Text("Not Update: ${widget.bookingId}"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: leadStatus.length,
      itemBuilder: (context, index) {
        final data = leadStatus[index];
        return _header(
          context,
          header: data.statusType,
          desc: data.description ?? 'No description',
          dateTime:
          DateFormat('dd-MM-yyyy, hh:mm a').format(data.createdAt),
          isMeet: data.zoomLink != null && data.zoomLink!.isNotEmpty,
          isPayment: data.statusType.toLowerCase().contains("payment"),
          endData: index == leadStatus.length - 1,
        );
      },
    );
  }
}

Widget _header(
    BuildContext context, {
      String? header,
      String? desc,
      bool isMeet = false,
      bool isPayment = false,
      String? meetMSG,
      bool endData = false,
      String? dateTime,
    }) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade300,
              ),
            ),
            if (!endData)
              Expanded(
                child: CustomContainer(
                  width: 2,
                  backgroundColor: Colors.grey.shade300,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                ),
              )
          ],
        ),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('$header,', style: textStyle14(context)),
                  10.width,
                  Text(
                    '( $dateTime )',
                    style: textStyle12(context, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Text(desc ?? '', style: textStyle14(context)),
              if (isMeet)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: CustomColor.whiteColor,
                              child: Icon(Icons.g_mobiledata_outlined,
                                  color: CustomColor.appColor)),
                          10.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Google Meet (12:30 PM, 02/08/25)',
                                  style: textStyle14(context),
                                ),
                                Text(
                                  'https://meet.google.com',
                                  style: textStyle14(context,
                                      color: CustomColor.appColor),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      CustomUrlLaunch(
                                          'https://meet.google.com/landing');
                                    },
                                    child: Text('Join Now',
                                        style: textStyle14(context,
                                            color: CustomColor.greenColor)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      10.height,
                      Text(meetMSG ??
                          'The scheduled meeting has been successfully conducted')
                    ],
                  ),
                ),
              if (isPayment)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: CustomColor.whiteColor,
                              child: Icon(Icons.currency_rupee,
                                  color: CustomColor.appColor)),
                          10.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Payment Request',
                                    style: textStyle14(context)),
                                InkWell(
                                  onTap: () =>
                                      CustomUrlLaunch('https://zeropls.com'),
                                  child: Text('paymentlink.com',
                                      style: textStyle14(context,
                                          color: CustomColor.appColor)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        CustomUrlLaunch(
                                            'https://checkout.rocketpay.co.in/md/684e8cc5d9c45b89310b8e01');
                                      },
                                      child: Text('Pay Now',
                                          style: textStyle14(context,
                                              color:
                                              CustomColor.greenColor)),
                                    ),
                                    30.width,
                                    InkWell(
                                      onTap: () {
                                        CustomUrlLaunch(
                                            'https://checkout.rocketpay.co.in/md/684e8cc5d9c45b89310b8e01');
                                      },
                                      child: Text('Share To Pay',
                                          style: textStyle14(context,
                                              color:
                                              CustomColor.appColor)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      10.height,
                      Text(meetMSG ??
                          'You have successfully made a payment. Awaiting verification from admin')
                    ],
                  ),
                ),
              20.height
            ],
          ),
        ),
      ],
    ),
  );
}
