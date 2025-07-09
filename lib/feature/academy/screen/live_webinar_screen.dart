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
      appBar: CustomAppBar(title: 'Live Webinar', showBackButton: true,),

      body: SafeArea(
          child: SingleChildScrollView(
            child:  FutureBuilder<LiveWebinarModel?>(
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
                      itemCount:  webinars.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final webinar = webinars[index];
                        return CustomContainer(
                          backgroundColor: CustomColor.whiteColor,
                          padding: EdgeInsets.zero,
                          height: dimensions.screenHeight*0.25,
                          margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${webinar.name}', style: textStyle14(context),),
                                            Text('Date: ${webinar.date}', style: textStyle12(context),),
                                          ],
                                        ),
                                        Text('${webinar.description}', style: textStyle12(context,color: CustomColor.descriptionColor),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Date: ${webinar.startTime}', style: textStyle12(context),),
                                            SizedBox(width: dimensions.screenWidth*0.03,),
                                            Text('Time: ${webinar.endTime}', style: textStyle12(context),),
                                          ],
                                        ),
                                        CustomContainer(
                                          backgroundColor: CustomColor.appColor,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                          child: Text('Enroll Now', style: textStyle12(context, color: CustomColor.whiteColor),),)
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EnrollNowScreen(webinar: webinars[index]),)),
                        );
                      },
                    ),

                    SizedBox(height: dimensions.screenHeight*0.02,),
                    CustomHeadline(headline: 'Attend at least 3 live webinar to move forward', viewSeeAll: false,),
                    ListView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            CustomContainer(
                              border: true,
                              backgroundColor: CustomColor.whiteColor,
                              padding: EdgeInsets.zero,
                              height: dimensions.screenHeight*0.1,
                              margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                              child: Row(
                                children: [
                                  CustomContainer(
                                    width: dimensions.screenWidth*0.35,
                                    margin: EdgeInsets.zero,
                                    assetsImg: CustomImage.thumbnailImage,
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Name', style: textStyle14(context),),
                                          Text('Distribution', style: textStyle12(context,color: CustomColor.descriptionColor),),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Positioned(
                                top: 20,right: 20,
                                child: Icon(Icons.library_add_check_outlined, color: CustomColor.appColor,))
                          ],
                        );
                      },
                    ),
                  ],
                );
              },),
          )
      ),
    );
  }
}


Widget _buildLiveWebinarShimmer(BuildContext context){
  Dimensions dimensions = Dimensions(context);
  return ListView.builder(
    itemCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
    itemBuilder: (context, index) {
      return CustomContainer(
        backgroundColor: CustomColor.whiteColor,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              // Top image shimmer
              CustomContainer(
                  height: dimensions.screenHeight * 0.15,
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  backgroundColor: Colors.grey[300]
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Title + Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(height: 10, width: 100, backgroundColor: Colors.grey[300], margin: EdgeInsets.zero,),
                        CustomContainer(height: 10, width: 80, backgroundColor: Colors.grey[300], margin: EdgeInsets.zero),
                      ],
                    ),
                    10.height,

                    CustomContainer(height: 10, width: double.infinity, backgroundColor: Colors.grey[300], margin: EdgeInsets.zero),
                    10.height,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomContainer(height: 10, width: 60, backgroundColor: Colors.grey[300], margin: EdgeInsets.zero),
                            10.width,
                            CustomContainer(height: 10, width: 60, backgroundColor: Colors.grey[300], margin: EdgeInsets.zero),
                          ],
                        ),
                        CustomContainer(height: 25, width: 90, backgroundColor: Colors.grey[300], margin: EdgeInsets.zero),
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
