import 'package:fetchtrue/feature/academy/screen/play_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/training_tutorial_model.dart';
import '../repository/training_tutorial_service.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {

  late Future<List<TrainingTutorialModel>> _futureTutorial;

  @override
  void initState() {
    super.initState();
    _futureTutorial = TrainingTutorialService().fetchTrainingTutorial();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Certificate', showBackButton: true,),

      body:FutureBuilder(
          future: _futureTutorial,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No certifications found"));
            }

            final tutorialCard = snapshot.data!;

            return SafeArea(
              child: ListView.builder(
                itemCount: tutorialCard.length,
                padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                itemBuilder: (context, index) {
                  final tutorial = tutorialCard[index];

                  return CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer(
                          networkImg: tutorial.imageUrl,
                          height: dimensions.screenHeight*0.18,
                          margin: EdgeInsets.zero,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayVideoScreen(
                                name: tutorial.name,
                                videoList: tutorial.videoList,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${tutorial.name}', style: textStyle14(context),),
                                  Text('${tutorial.description}', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.play_circle, size: 14,color: CustomColor.appColor,),
                                      5.width,
                                      Text(' Video', style: textStyle12(context, color: CustomColor.appColor),),

                                    ],
                                  ),
                                  Text('Completed', style: textStyle12(context, color: CustomColor.appColor),)
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
      )
    );
  }
}
