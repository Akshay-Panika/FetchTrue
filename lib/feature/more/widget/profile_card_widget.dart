import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_state.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_state.dart';

class ProfileCardWidget extends StatefulWidget {
  const ProfileCardWidget({super.key,});


  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    if(!userSession.isLoggedIn){
      return CustomContainer(
        color: CustomColor.whiteColor,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                      backgroundImage: AssetImage(CustomImage.nullImage) as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guest',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'guest@test.com',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatus(value: '00', valueType: 'Joining date'),
                _buildStatus(value: '00', valueType: 'Lead Completed'),
                _buildStatus(value: '00', valueType: 'Total Earning'),
              ],
            ),
          ],
        ),
      );
    }

    return CustomContainer(
      color: CustomColor.whiteColor,
      padding: const EdgeInsets.all(15),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {

          if (state is UserInitial) {
            context.read<UserBloc>().add(GetUserById(userSession.userId!));
            return   _buildShimmerEffect();
          }
          else if(state is UserLoading){
            return   _buildShimmerEffect();
          }
          else if (state is UserLoaded) {
            final user = state.user;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                          backgroundImage: (user.profilePhoto != null && user.profilePhoto!.isNotEmpty)
                              ? NetworkImage(user.profilePhoto!)
                              : AssetImage(CustomImage.nullImage),

                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.fullName}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),

                            Text('${user.email}', style: const TextStyle(color: Colors.grey),),
                            Text('ID: ${user.userId}', style: const TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ],
                    ),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PackageScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomColor.appColor, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  Row(
                            children: [
                              Icon(Icons.verified_outlined, size: 16),
                              SizedBox(width: 5),
                              Text(user.packageActive == true ? 'GP' :'Package', style: textStyle12(context,fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatus(
                      value: (user.createdAt != null && user.createdAt.toString().isNotEmpty)
                          ? DateFormat('dd MMM yyyy').format(user.createdAt is DateTime
                          ? user.createdAt as DateTime
                          : DateTime.parse(user.createdAt.toString()))
                          : 'Not available',
                      valueType: 'Joining date',
                    ),

                    BlocBuilder<LeadBloc, LeadState>(
                      builder: (context, state) {
                        if (state is LeadLoading) {
                           return  _buildStatus(value: '00', valueType: 'Lead Completed');
                        } else if (state is LeadLoaded) {
                          final allLeads = state.leadModel.data ?? [];
                          final completedLeads = allLeads.where((e) => e.isCompleted == true).toList();


                          return  _buildStatus(value: '${completedLeads.length}', valueType: 'Lead Completed');

                        } else if (state is LeadError) {
                          return  _buildStatus(value: '00', valueType: 'Lead Completed');
                        }
                        return  _buildStatus(value: '00', valueType: 'Lead Completed');
                      },
                    ),


                    BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        if (state is WalletLoading) {
                         return  _buildStatus(value: '00', valueType: 'Total Earning');
                        } else if (state is WalletLoaded) {
                          final wallet = state.wallet;
                          return  _buildStatus(value: '${wallet.balance == 0? 0 :wallet.balance}', valueType: 'Total Earning');
                        } else if (state is WalletError) {
                          return  _buildStatus(value: '00', valueType: 'Total Earning');
                        }
                        return const SizedBox();
                      },
                    ),


                  ],
                ),
              ],
            );
          } else if (state is UserError) {
            print('Error: ${state.massage}');
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                          backgroundImage: AssetImage(CustomImage.nullImage) as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Guest',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'guest@test.com',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),

                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatus(value: '00', valueType: 'Joining date'),
                    _buildStatus(value: '00', valueType: 'Lead Completed'),
                    _buildStatus(value: '00', valueType: 'Total Earning'),
                  ],
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatus({required String value, required String valueType}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          valueType,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: CustomColor.descriptionColor,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (_) {
              return Column(
                children: [
                  Container(
                    height: 12,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 10,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
