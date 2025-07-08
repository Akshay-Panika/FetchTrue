import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../model/recorded_webinar_model.dart';
import '../repository/recorded_webinar_service.dart';

class RecordedWebinarScreen extends StatefulWidget {
  const RecordedWebinarScreen({super.key});

  @override
  State<RecordedWebinarScreen> createState() => _RecordedWebinarScreenState();
}

class _RecordedWebinarScreenState extends State<RecordedWebinarScreen> {

  late Future<RecordedWebinarModel?> _webinarFuture;

  @override
  void initState() {
    super.initState();
    _webinarFuture = RecordedWebinarService().fetchRecordedWebinars();
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Recorded Webinar', showBackButton: true,),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
          child:  FutureBuilder<RecordedWebinarModel?>(
            future: _webinarFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No data available.'));
              }

              final webinars = snapshot.data!.data;

              return Column(
                children: [
                  ListView.builder(
                    itemCount: webinars.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final webinar = webinars[index];
                      return  CustomContainer(
                        border: true,
                        backgroundColor: CustomColor.whiteColor,
                        padding: EdgeInsets.zero,
                        height: dimensions.screenHeight*0.25,
                        margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Text(webinar.name, style: textStyle14(context),),
                                      Text(webinar.description, style: textStyle12(context,color: CustomColor.descriptionColor),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),


                  SizedBox(height: dimensions.screenHeight*0.02,),
                  CustomHeadline(headline: 'Attend at least 3 live webinar to move forward', viewSeeAll: false,),
                  ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    // padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
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
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Name', style: textStyle14(context),),
                                              Text('Distribution', style: textStyle12(context,color: CustomColor.descriptionColor),),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Date:', style: textStyle12(context),),
                                                  SizedBox(width: dimensions.screenWidth*0.03,),
                                                  Text('Time:', style: textStyle12(context),),
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
                                )
                              ],
                            ),
                          ),

                          Positioned(
                              top: 20,right: 20,
                              child: Icon(Icons.share, color: CustomColor.appColor,))
                        ],
                      );
                    },
                  ),
                ],
              );
            },),
        ),
      ),
    );
  }
}
