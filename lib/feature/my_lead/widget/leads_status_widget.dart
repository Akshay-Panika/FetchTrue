import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/lead_status_model.dart';
import '../model/leads_model.dart';
import '../repository/checkout_service_buy_repository.dart';
import '../repository/lead_status_service.dart';

class LeadsStatusWidget extends StatefulWidget {
  final String checkoutId;
  final LeadsModel lead;
  const LeadsStatusWidget({super.key, required this.checkoutId, required this.lead});

  @override
  State<LeadsStatusWidget> createState() => _LeadsStatusWidgetState();
}

class _LeadsStatusWidgetState extends State<LeadsStatusWidget> {
  LeadStatusModel? leadData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeadStatus();
  }

  Future<void> fetchLeadStatus() async {
    final data = await LeadStatusService().fetchLeadStatusByCheckout(widget.checkoutId);
    setState(() {
      leadData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Booking Status :', style: textStyle14(context),),
                  10.width,
                  Text(
                    '[ ${getLeadStatus(widget.lead)} ]',
                    style: textStyle12(context, fontWeight: FontWeight.bold, color: getStatusColor(widget.lead)),
                  )
                ],
              ),
              5.height,

              _iconText(context,icon: Icons.calendar_month, text: 'Booking Date : ${formatDate(widget.lead.createdAt)}'),
              _iconText(context,icon: Icons.calendar_month, text: 'Schedule Date: ${formatDate(widget.lead.acceptedDate)}'),
            ],
          ),
        ),

        /// Status
        isLoading
            ?  LinearProgressIndicator(color: CustomColor.appColor,minHeight: 2,)
            : leadData == null
            ? SizedBox.shrink()
            : Expanded(
              child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: leadData!.leads.length,
                        itemBuilder: (context, index) {
              final lead = leadData!.leads[index];
              final isLast = index == leadData!.leads.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 18,),
                        // if (!isLast)
                        if(lead.statusType != 'Lead completed')
                          Expanded(
                            child: Container(
                              width: 3,
                              decoration: BoxDecoration(
                                color: CustomColor.appColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                          ),
                      ],
                    ),
                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead.statusType, style: textStyle12(context)),

                          Row(
                            children: [
                              Text(
                                "Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(lead.createdAt.toLocal())}",
                                style: textStyle12(context, color: CustomColor.descriptionColor),
                              ),
                              10.width,

                              Text('( Provider )', style: textStyle12(context, color: CustomColor.descriptionColor,fontWeight: FontWeight.w400)),
                            ],
                          ),
                          5.height,

                          if (lead.description != null && lead.description!.isNotEmpty)
                            Text(lead.description!, style: const TextStyle(fontSize: 14)),


                          if (lead.zoomLink.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                final url = lead.zoomLink;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                              child: CustomContainer(
                                width: 300,
                                child: Row(
                                  children: [
                                    Icon(Icons.videocam, color: CustomColor.appColor),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        "Zoom: ${lead.zoomLink}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          5.height,

                          if (lead.paymentLink != null && lead.paymentLink!.isNotEmpty)
                            CustomContainer(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.payment, color: Colors.green),
                                      10.width,
                                      Text("Payment: ${lead.paymentType ?? ''}"),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentWebViewScreen(
                                            url: lead.paymentLink!,
                                          ),
                                        ),
                                      );
                                    },
                                    child:  Text("Pay Now", style: textStyle14(context, color: CustomColor.appColor),),
                                  ),
                                ],
                              ),
                            ),

                          15.height
                        ],
                      ),
                    ),
                  ],
                ),
              );
                        },
                      ),
            ),
      ],
    );
  }

  /// Lead Status
  String getLeadStatus(lead) {
    if (lead.isCanceled == true) return 'Cancel';
    if (lead.isCompleted == true) return 'Completed';
    if (lead.isAccepted == true) return 'Accepted';
    return 'Pending';
  }

  /// Status Color
  Color getStatusColor(lead) {
    if (lead.isCanceled == true) return Colors.red;
    if (lead.isCompleted == true) return Colors.green;
    if (lead.isAccepted == true) return Colors.orange;
    return Colors.grey;
  }

  /// Format Date
  String formatDate(String? rawDate) {
    if (rawDate == null) return 'N/A';
    final date = DateTime.tryParse(rawDate);
    if (date == null) return 'Invalid Date';
    return DateFormat('dd MMM yyyy').format(date);
  }
}

Widget _iconText(BuildContext context,{IconData? icon, double? iconSize,Color? iconColor, String? text, Color? textColor,FontWeight? fontWeight}){
  return Row(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon!, size: iconSize ?? 16,color: iconColor ?? Colors.grey,),
      Expanded(child: Text(text!, style: textStyle14(context, color: textColor ?? CustomColor.descriptionColor,fontWeight: FontWeight.w400),))
    ],
  );
}


class PaymentWebViewScreen extends StatelessWidget {
  final String url;

  const PaymentWebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Payment Now', showBackButton: true,),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url),  // <-- FIX here
        ),
        onLoadError: (controller, url, code, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load payment page')),
          );
        },
      )
    );
  }
}
