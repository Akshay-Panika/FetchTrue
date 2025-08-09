
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../../../helper/Contact_helper.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Help & Support', showBackButton: true,),

      body: SafeArea(
          child:
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 20.height,
                 Image.asset(CustomImage.inviteImage),
                 50.height,
                 Text('Contact us through email',style: textStyle16(context),),
                 Text('You can send us email though',style: textStyle12(context, color: CustomColor.descriptionColor),),
                 InkWell(
                     onTap: () {
                       CustomUrlLaunch('https://www.fetchtrue.com');
                     },
                     child: Text('info@fetchtrue.com',style: textStyle14(context, color: CustomColor.appColor),)),
                 Text('Typically the support team send you any feedback in 2 hours', style: textStyle14(context, fontWeight: FontWeight.w400),),
                 20.height,

                 Text('Contact us through phone',style: textStyle16(context),),
                 Text('Contest us through our customer care number',style: textStyle12(context, color: CustomColor.descriptionColor),),
                 Text('+91 8989207770',style: textStyle14(context, color: CustomColor.appColor),),
                 Text('Talk with our customer support executive at any time', style: textStyle14(context, fontWeight: FontWeight.w400),),
                 20.height,

                 Row(
                   children: [
                     Expanded(
                       child: CustomContainer(
                         color: CustomColor.appColor.withOpacity(0.2),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.email, color: CustomColor.appColor,),
                             8.width,
                             Text('Email', style: textStyle14(context, color: CustomColor.appColor),),
                           ],
                         ),

                       ),
                     ),
                     Expanded(
                       child: CustomContainer(
                         onTap: () {
                           ContactHelper.call('918989207770');
                         },
                         color: CustomColor.appColor.withOpacity(0.2),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.call, color: CustomColor.appColor,),
                             8.width,
                             Text('Call', style: textStyle14(context, color: CustomColor.appColor),),
                           ],
                         ),
                       ),
                     ),

                   ],
                 )
               ],
             ),
           )),
    );
  }
}


