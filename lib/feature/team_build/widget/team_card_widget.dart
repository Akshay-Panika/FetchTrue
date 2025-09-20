

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../../lead/bloc/lead/lead_state.dart';
import '../../lead/bloc/team_lead/team_lead_bloc.dart';
import '../../lead/bloc/team_lead/team_lead_event.dart';
import '../../lead/bloc/team_lead/team_lead_state.dart';
import '../../lead/repository/lead_repository.dart';

class TeamCardWidget extends StatefulWidget {
 final ImageProvider<Object>? backgroundImage;
 final double? radius;
 final String? name;
 final String? phone;
 final String? id;
 final String? memberId;
 final String? level;
 final bool? status;
 final String? address;
 final String? earning;
 final VoidCallback? onTap;
  const TeamCardWidget({super.key, this.backgroundImage, this.name, this.phone, this.id, this.level, this.radius, this.address, this.earning, this.memberId, this.onTap, this.status,
  });

  @override
  State<TeamCardWidget> createState() => _TeamCardWidgetState();
}

class _TeamCardWidgetState extends State<TeamCardWidget> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return CustomContainer(
      border: false,
      borderColor: CustomColor.appColor,
      color: Colors.white,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: dimensions.screenHeight*0.01),
      onTap: widget.onTap,
      child: Stack(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: dimensions.screenHeight*0.03, bottom: dimensions.screenHeight*0.015, left: dimensions.screenHeight*0.015, right: dimensions.screenHeight*0.01),
            child: Column(
              children: [
               Row(
                 spacing: dimensions.screenHeight*0.01,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   CircleAvatar(
                     radius:widget.radius?? 30,
                     backgroundColor: CustomColor.whiteColor,
                     backgroundImage: widget.backgroundImage,
                   ),

                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow(context, 'ID:', widget.memberId ?? '#XXXXX'),
                        _buildRow(context, 'Name:', widget.name?? 'Guest'),
                        if(widget.address != null && widget.address != '')
                        _buildRow(context, 'Address:', widget.address!),

                      ],
                   )
                 ],
               ),
                Divider(),
                5.height,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Leads
                    Expanded(flex: 2,
                      child: BlocProvider(
                        create: (context) => TeamLeadBloc(LeadRepository())..add(GetTeamLeadsByUser(widget.id!)),
                        child: BlocBuilder<TeamLeadBloc, TeamLeadState>(
                          builder: (context, state) {
                            if (state is TeamLeadLoading) {
                              return _leadShimmer();
                            } else if (state is TeamLeadLoaded) {
                              final allLeads = state.leadModel ?? [];

                              final acceptedLeads = allLeads.where((e) => e.isAccepted == true && e.isCompleted == false && e.isCanceled == false).toList();
                              final completedLeads = allLeads.where((e) => e.isCompleted == true).toList();


                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${allLeads.length}\nLeads', textAlign: TextAlign.center,style: textStyle12(context, color: Color(0xff3B82F6)),),
                                  Text('${acceptedLeads.length}\nActive', textAlign: TextAlign.center,style: textStyle12(context, color: Color(0xff22C55E)),),
                                  Text('${completedLeads.length}\nCompleted', textAlign: TextAlign.center,style: textStyle12(context, color: Color(0xffFF9A55)),),
                                ],
                              );

                            } else if (state is TeamLeadError) {
                              print('"❌ ${state.message}"');
                              return SizedBox.shrink();
                              // return Center(child: Text("❌ ${state.message}"));
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ),

                    30.width,
                    Container(width: 1,height:dimensions.screenHeight*0.03, color: Colors.grey,),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () => ContactHelper.call(widget.phone!),
                              child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),


                          InkWell(
                              onTap: () => ContactHelper.whatsapp(widget.phone!, 'Hello ${widget.name}!'),
                              child: Image.asset(CustomIcon.whatsappIcon, height: 25,color: CustomColor.greenColor,)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: widget.status == true ? Colors.grey :CustomColor.appColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              ),
              padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.01),
              child: Text(widget.level!, style: textStyle12(context, color: CustomColor.whiteColor,fontWeight: FontWeight.w400),)),

          Positioned(
              right: 10,top: 10,
              child:  Text(widget.level == 'Non-GP' ? 'Earning Opportunity\n\u20b9 ${widget.earning}' : 'My Earning\n₹ ${widget.earning}', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),textAlign: TextAlign.end,))
        ],
      ),
    );
  }
}


Widget _buildRow(BuildContext context ,String key, String value){
  return Row(
    children: [
      Text(key, style: textStyle12(context, fontWeight: FontWeight.w400),),
      10.width,
      Text(value, style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
    ],
  );
}



Widget _leadShimmer(){
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ShimmerBox(height: 10, width: 15),
           8.height,
           ShimmerBox(height: 10, width: 50),
         ],
       ) ,
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ShimmerBox(height: 10, width: 15),
           8.height,
           ShimmerBox(height: 10, width: 50),
         ],
       ) ,
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ShimmerBox(height: 10, width: 15),
           8.height,
           ShimmerBox(height: 10, width: 50),
         ],
       ) ,
      ],
    ),
  );
}