import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class TeamLeadDetailsScreen extends StatelessWidget {
  const TeamLeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Name', showBackButton: true,),

      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              /// Custom App Bar Section
              CustomContainer(
                backgroundColor: CustomColor.whiteColor,
                child: _buildProfileHeader(context),
              ),

              /// Tab Bar
              TabBar(
                tabs: const [
                  Tab(text: 'Lead - 253'),
                  Tab(text: 'Team - 457'),
                ],
                dividerColor: Colors.transparent,
                indicatorColor: CustomColor.appColor,
                labelColor: CustomColor.appColor,
                unselectedLabelColor: CustomColor.descriptionColor,
              ),

              /// Tab View
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(child: _buildLead(context)),
                    _buildTeam(),
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


Widget _buildProfileHeader(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(CustomImage.nullImage),
              ),
              CustomContainer(
                backgroundColor: Colors.amber.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Text('SGP', style: textStyle14(context)),
              ),
            ],
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Frenchise Name :- Devraj Kadam'),
              Text('Frenchise Code :- SK07357HP'),
              Text('Joining Date :- 14/03/2025'),
              10.height,
              CustomContainer(
                margin: EdgeInsets.zero,
                backgroundColor: Colors.amber.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Text('My Earning - 12253',
                    style: textStyle14(context, fontWeight: FontWeight.w400)),
              )
            ],
          )
        ],
      ),
      10.height,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Self Follow Up',
                style: textStyle16(context,
                    fontWeight: FontWeight.w400, color: CustomColor.appColor)),
            Row(
              children: [
                Image.asset(CustomIcon.phoneIcon,
                    height: 25, color: CustomColor.appColor),
                50.width,
                Image.asset(CustomIcon.whatsappIcon, height: 25),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}


Widget _buildLead(BuildContext context){
  return Column(
    children: [
      CustomContainer(
        backgroundColor: CustomColor.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _lead(context,icon: Icons.check_circle, value: '0',header: 'Completed' ,iconColor: CustomColor.greenColor),
            _lead(context,icon: Icons.timelapse, value: '1',header: 'In Progress' ,iconColor: CustomColor.amberColor),
            _lead(context,icon: Icons.info, value: '0',header: 'Rejected' ,iconColor: CustomColor.redColor),
            _lead(context,icon: Icons.whatshot, value: '0',header: 'Expired' ,iconColor: CustomColor.redColor),
          ],
        ),
      ),

      CustomContainer(
        backgroundColor: CustomColor.whiteColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: CustomColor.appColor,
                      backgroundImage: AssetImage(CustomImage.nullImage),
                    ),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name'),
                        Text('Franchise code'),
                      ],
                    ),
                  ],
                ),


                CustomContainer(
                  margin: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  child: Text(' 3 Day / 12:30 Hrs\nExpired',style: textStyle12(context, color: CustomColor.appColor),textAlign: TextAlign.center,),),
              ],
            ),
            10.height,
            
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(icon: Icon(Icons.timelapse, color: CustomColor.amberColor,),label: Text('In Progress', style: textStyle14(context, color: CustomColor.amberColor),), onPressed: () => null,),
                    Text(' Earning Opportunity - 5643')
                  ],
                ),
                Text('Follow up with the customer to completed the application it can take up 7 days to it tracked.')
              ],
            ),
            20.height,

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
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text('Lead Date', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                       Text('18-09-2024',style: textStyle14(context),)
                     ],
                   ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text('Update Date', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                       Text('19-09-2024',style: textStyle14(context),)
                     ],
                   ),
                 ],
               ),),
            10.height,

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' Self Follow Up', style: textStyle16(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                  Row(
                    children: [
                      Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,),
                      50.width,
                      Image.asset(CustomIcon.whatsappIcon, height: 25,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}


Widget _lead(BuildContext context, {IconData? icon, Color? iconColor, String? value, String? header}){
  return Column(
    children: [
       Row(
         children: [
           Icon(icon, color: iconColor,size: 16,),
           5.width,
           Text(value!, style: textStyle16(context, color: iconColor),)
         ],
       ),
       Text(header!,style: textStyle12(context,fontWeight: FontWeight.w400),)
    ],
  );
}

Widget _buildTeam(){
  return ListView.builder(
    itemCount: 5,
    padding: EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            backgroundColor: CustomColor.whiteColor,
            margin: EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColor.appColor,
                          backgroundImage: AssetImage(CustomImage.nullImage),
                        ),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name'),
                            Text('Franchise code'),
                          ],
                        ),
                      ],
                    ),


                    CustomContainer(
                      margin: EdgeInsets.zero,
                      child: Text('My Earning\n500',style: textStyle12(context, color: CustomColor.appColor),textAlign: TextAlign.center,),)
                  ],
                ),
                Divider(),

                CustomContainer(
                  backgroundColor: CustomColor.whiteColor,
                  margin: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(' Total Lead\n25',style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),textAlign: TextAlign.center,),
                      Text(' Active Lead\n25',style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.amberColor),textAlign: TextAlign.center,),
                      Text(' Complete Lead\n25',style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.greenColor),textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                10.height,

              ],
            ),
          )
        ],
      );
    },);
}