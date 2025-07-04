import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../../core/widgets/custom_ratting_and_reviews.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_service.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: true,),

      body:  BlocProvider(
        create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
        child:  BlocBuilder<ProviderBloc, ProviderState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            }

            else if(state is ProviderLoaded){

              final provider = state.providerModel;
              // final provider = state.providerModel.where((moduleService) =>
              // moduleService.id == widget.
              // ).toList();

              if (provider.isEmpty) {
                return const Center(child: Text('No provider found.'));
              }


              return  ListView.builder(
                  itemCount: provider.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                final data = provider[index];

                ImageProvider _getProfileImage(String? logoUrl) {
                  if (logoUrl == null || logoUrl.isEmpty || logoUrl == 'null') {
                    return const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');
                  }
                  return NetworkImage(logoUrl);
                }

                return CustomContainer(
                  width: double.infinity,
                  backgroundColor: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id, storeName: data.storeInfo!.storeName,),)),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFFF2F2F2),
                                backgroundImage: _getProfileImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                              ),
                              10.width,

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.fullName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text('Onboarding Service', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                                  5.height,
                                  CustomRattingAndReviews()
                                ],
                              )
                            ],
                          ),
                          15.height,

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(4, (index) {
                              return CustomContainer(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: Text('type of tag', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),));
                            }),
                          ),
                        ],
                      ),
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: CustomFavoriteButton(),
                      ),
                    ],
                  ),
                );
              });

            }

            else if (state is ProviderError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
