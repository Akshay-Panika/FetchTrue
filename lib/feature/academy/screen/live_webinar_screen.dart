import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../model/live_webinar_model.dart';
import '../repository/live_webinar_service.dart';
import 'enroll_now_screen.dart';

class LiveWebinarScreen extends StatefulWidget {
  const LiveWebinarScreen({super.key});

  @override
  State<LiveWebinarScreen> createState() => _LiveWebinarScreenState();
}

class _LiveWebinarScreenState extends State<LiveWebinarScreen> {
  late Future<LiveWebinarModel?> webinarFuture;

  @override
  void initState() {
    super.initState();
    webinarFuture = LiveWebinarService().fetchLiveWebinars();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Live Webinar', showBackButton: true),

      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<LiveWebinarModel?>(
            future: webinarFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLiveWebinarShimmer(context);
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Failed to load webinars.'));
              }

              final webinars = snapshot.data!.data;

              return Column(
                children: [
                  ListView.builder(
                    itemCount: webinars.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final webinar = webinars[index];

                      final List<dynamic> userList = webinar.user;

                      return CustomContainer(
                        color: CustomColor.whiteColor,
                        padding: EdgeInsets.zero,
                        height: dimensions.screenHeight * 0.25,
                        margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
                        child: Column(
                          children: [
                            Expanded(
                              child: CustomContainer(
                                margin: EdgeInsets.zero,
                                networkImg: webinar.imageUrl,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          webinar.name,
                                          style: textStyle14(context),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text('Date: ${webinar.date}', style: textStyle12(context)),
                                    ],
                                  ),
                                  Text(webinar.description, style: textStyle12(context, color: CustomColor.descriptionColor)),

                                  const SizedBox(height: 8),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Start: ${webinar.startTime}', style: textStyle12(context)),
                                          SizedBox(width: dimensions.screenWidth * 0.03),
                                          Text('End: ${webinar.endTime}', style: textStyle12(context)),
                                        ],
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => EnrollNowScreen(webinar: webinar),
                                            ),
                                          );
                                        },
                                        child: CustomContainer(
                                          color: CustomColor.appColor,
                                          margin: EdgeInsets.zero,
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                          child: Text('Enroll Now', style: textStyle12(context, color: CustomColor.whiteColor)),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // // Optional: Show number of users enrolled or status summary
                                  // if (userList.isNotEmpty)
                                  //   Text(
                                  //     'Users enrolled: ${userList.length}',
                                  //     style: textStyle12(context, color: Colors.grey),
                                  //   ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                   30.height,

                   Text('-: Attend at least 3 live webinar to move forward :-', style: textStyle16(context),),
                  ListView.builder(
                    itemCount: 3,
                    // itemCount: webinars.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {

                      final data = webinars[index];

                      return Stack(
                        children: [
                          CustomContainer(
                            border: false,
                            color: CustomColor.whiteColor,
                            padding: EdgeInsets.zero,
                            height: dimensions.screenHeight * 0.1,
                            margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
                            child: Row(
                              children: [
                                CustomContainer(
                                  width: dimensions.screenWidth * 0.35,
                                  margin: EdgeInsets.zero,
                                  networkImg: data.imageUrl,
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${data.name}', style: textStyle14(context)),
                                        Text('${data.description}', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                      ],
                                    ),
                                  ),
                                ),

                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Date: ${data.date}', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                    )),

                              ],
                            ),
                          ),

                           Positioned(
                            top: 20,
                            right: 20,
                            child: Icon(Icons.library_add_check_outlined, color: CustomColor.appColor),
                          )
                        ],
                      );
                    },
                  ),
                  20.height,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildLiveWebinarShimmer(BuildContext context) {
  Dimensions dimensions = Dimensions(context);
  return ListView.builder(
    itemCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
    itemBuilder: (context, index) {
      return CustomContainer(
        color: CustomColor.whiteColor,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              CustomContainer(
                height: dimensions.screenHeight * 0.15,
                width: double.infinity,
                margin: EdgeInsets.zero,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(height: 10, width: 100, color: Colors.grey[300], margin: EdgeInsets.zero),
                        CustomContainer(height: 10, width: 80, color: Colors.grey[300], margin: EdgeInsets.zero),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomContainer(height: 10, width: double.infinity, color: Colors.grey[300], margin: EdgeInsets.zero),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomContainer(height: 10, width: 60, color: Colors.grey[300], margin: EdgeInsets.zero),
                            const SizedBox(width: 10),
                            CustomContainer(height: 10, width: 60, color: Colors.grey[300], margin: EdgeInsets.zero),
                          ],
                        ),
                        CustomContainer(height: 25, width: 90, color: Colors.grey[300], margin: EdgeInsets.zero),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
