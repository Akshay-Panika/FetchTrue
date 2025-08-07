import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../profile/bloc/all_user_bloc/all_user_bloc.dart';
import '../../profile/bloc/all_user_bloc/all_user_event.dart';
import '../../profile/bloc/all_user_bloc/all_user_state.dart';
import '../../profile/model/user_model.dart';
import '../../profile/repository/all_user_repository.dart';
import '../model/non_gp_model.dart';
import '../repository/fetch_referred_user_service.dart';

class NonGpWidget extends StatelessWidget {
  final String teamId;
  const NonGpWidget({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllUserBloc(AllUserRepository())..add(AllFetchUsers()),
      child: BlocBuilder<AllUserBloc, AllUserState>(
        builder: (context, state) {
          if (state is AllUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllUserLoaded) {
            final users = state.users;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// User Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                backgroundImage: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                                    ? NetworkImage(user.profilePhoto!)
                                    : AssetImage(CustomImage.nullImage),
                              ),

                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${user.fullName}', style: textStyle14(context, fontWeight: FontWeight.w400)),
                                  Text('Id: ${user.userId}', style: textStyle14(context, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),

                          Text('Earning\nOpportunity ₹ 500', style: textStyle12(context, color: CustomColor.appColor), textAlign: TextAlign.end,),

                        ],
                      ),

                      const Divider(thickness: 0.4,),

                      /// Follow-up Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.green,size: 20,),
                                      5.width,
                                      Text('Registration', style: textStyle12(context, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                              
                                  Row(
                                    children: [
                                       Icon(Icons.check_circle,size: 20, color: user.packageActive == true ? CustomColor.greenColor : Colors.grey.shade500),
                                       5.width,
                                       Text('Active GP', style: textStyle12(context, fontWeight: FontWeight.w400)),
                                      30.width,
                                    ],
                                  )
                                ],
                              ),
                            ),

                            // Text(' Self Follow Up', style: textStyle14(context, color: CustomColor.appColor),),

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      ContactHelper.call(user.mobileNumber);
                                    },
                                    child: Image.asset(
                                      CustomIcon.phoneIcon,
                                      height: 25,
                                      color: CustomColor.appColor,
                                    ),
                                  ),
                                  50.width,
                                  InkWell(
                                    onTap: () {
                                      ContactHelper.whatsapp(user.mobileNumber, 'Hello, ${user.fullName}');
                                    },
                                    child: Image.asset(CustomIcon.whatsappIcon, height: 25),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is AllUserError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
