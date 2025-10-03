import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../model/live_webinar_model.dart';

class EnrollNowScreen extends StatefulWidget {
  final LiveWebinar webinar;
  const EnrollNowScreen({super.key, required this.webinar});

  @override
  State<EnrollNowScreen> createState() => _EnrollNowScreenState();
}

class _EnrollNowScreenState extends State<EnrollNowScreen> {
  bool _itEnroll = false;


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Webinar', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
          child: Column(
            children: [
              CustomContainer(
                border: true,
                color: CustomColor.whiteColor,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
                child: Column(
                  children: [
                    CustomContainer(
                      margin: EdgeInsets.zero,
                      networkImg: widget.webinar.imageUrl,
                      height: dimensions.screenHeight * 0.18
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.webinar.name,
                                style: textStyle12(context),
                              ),
                              Text(
                                widget.webinar.description,
                                style: textStyle12(context,
                                    color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)
                              ),
                            ],
                          ),
                          5.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: ${widget.webinar.date}',
                                style: textStyle12(context, fontWeight: FontWeight.w400),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start: ${widget.webinar.startTime}',
                                    style: textStyle12(context,fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: dimensions.screenWidth * 0.03,
                                  ),
                                  Text(
                                    'End: ${widget.webinar.endTime}',
                                    style: textStyle12(context, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              20.height,
              CustomContainer(
                border: true,
                width: double.infinity,
                margin: EdgeInsets.zero,
                color: CustomColor.whiteColor,
                onTap: () {
                  setState(() {
                    _itEnroll = !_itEnroll;
                  });
                },
                child: Column(
                  children: [
                    !_itEnroll
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        20.height,
                        Text(
                          'Test webinar description',
                          style: textStyle14(context,
                              color: CustomColor.descriptionColor),
                        ),
                        10.height,
                        Text(
                          'Enroll Now',
                          style: textStyle20(context,
                              color: CustomColor.appColor),
                        ),
                        20.height,
                      ],
                    )
                        : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Icon(Icons.videocam_outlined,
                                color: CustomColor.appColor),
                            5.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: widget
                                    .webinar.displayVideoUrls
                                    .map(
                                      (link) => Text(
                                    link,
                                    style: textStyle14(context,
                                        color: CustomColor.appColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        20.height,
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            _card(
                              context,
                              label: 'Copy',
                              icon: Icons.copy,
                              onTap: () {
                                if (widget.webinar.displayVideoUrls
                                    .isNotEmpty) {
                                  CopyUrl(widget
                                      .webinar.displayVideoUrls.first);
                                }
                              },
                            ),
                            _card(
                              context,
                              label: 'Join',
                              icon: Icons.phonelink_rounded,
                              onTap: () {
                                if (widget.webinar.displayVideoUrls
                                    .isNotEmpty) {
                                  CustomUrlLaunch(widget
                                      .webinar.displayVideoUrls.first);
                                }
                              },
                            ),
                          ],
                        ),
                        20.height,
                        Text(
                          'Time Remaining',
                          style: textStyle14(context,
                              color: CustomColor.descriptionColor),
                        ),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '00.0',
                                      style: textStyle20(context)),
                                  TextSpan(
                                      text: 'hr',
                                      style: textStyle16(context)),
                                ],
                              ),
                            ),
                            10.width,
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '00.0',
                                      style: textStyle20(context)),
                                  TextSpan(
                                      text: 'min',
                                      style: textStyle16(context)),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _card(BuildContext context,
    {VoidCallback? onTap,
      required String label,
      required IconData icon}) {
  return CustomContainer(
    border: true,
    color: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: Row(
      children: [
        Text(
          label,
          style: textStyle14(context, color: CustomColor.appColor),
        ),
        10.width,
        Icon(icon, size: 16, color: CustomColor.appColor),
      ],
    ),
  );
}
