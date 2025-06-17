import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
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

                return Stack(
                  children: [
                    CustomContainer(
                      border: false,
                      backgroundColor: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(CustomImage.nullImage),
                          ),
                          10.width,

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("${data.fullName ?? 'Provider Name'}", style: textStyle16(context),),
                                Text( "Phone: ${data.phoneNo ?? 'Phone'}", style: textStyle14(context, fontWeight: FontWeight.w400)),
                                Text( "Email: ${data.email ?? 'Email'}", style: textStyle14(context, fontWeight: FontWeight.w400)),
                                // Text("Address: ${data.storeInfo.address ?? ''},", style: textStyle14(context, fontWeight: FontWeight.w400),maxLines: 2,overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id,storeName: data.fullName,),)),
                    ),
                    
                    Positioned(
                        right: 0,top: 10,
                        child: CustomFavoriteButton())
                  ],
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
