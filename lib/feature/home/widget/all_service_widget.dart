import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../../core/widgets/custom_ratting_and_reviews.dart';
import '../../favorite/CustomFavoriteButton.dart'; // ✅ Check file name case-sensitive on Linux/macOS
import '../../favorite/model/favorite_services_model.dart';
import '../../favorite/repository/favorite_service.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';
import '../../service/screen/service_details_screen.dart';

class AllServiceWidget extends StatefulWidget {
  final String headline;

  const AllServiceWidget({super.key, required this.headline});

  @override
  State<AllServiceWidget> createState() => _AllServiceWidgetState();
}

class _AllServiceWidgetState extends State<AllServiceWidget> {
  late Future<FavoriteServicesModel?> _favoriteServicesFuture;
  List<String> _favoriteServiceIds = [];

  @override
  void initState() {
    super.initState();
    _favoriteServicesFuture = fetchFavoriteServices('684bf1fdea0d1a913e3cfa83');
    _loadFavoriteIds();
  }

  void _loadFavoriteIds() async {
    final response = await _favoriteServicesFuture;
    if (response != null) {
      setState(() {
        _favoriteServiceIds = response.favoriteServices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
      child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
        builder: (context, state) {
          if (state is ModuleServiceLoading) {
            return const Center(child: LinearProgressIndicator());
          } else if (state is ModuleServiceLoaded) {
            final services = state.serviceModel;

            if (services.isEmpty) {
              return const Center(child: Text('No Service found.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeadline(headline: widget.headline),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final data = services[index];
                      final isFavorite = _favoriteServiceIds.contains(data.id);

                      return CustomContainer(
                        border: false,
                        width: 300,
                        backgroundColor: Colors.white,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(serviceId: data.id),
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Image + Favorite
                            Expanded(
                              child: CustomContainer(
                                networkImg: data.thumbnailImage,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FavoriteButton(
                                        userId: '684bf1fdea0d1a913e3cfa83',
                                        serviceId: data.id,
                                        isInitiallyFavorite: isFavorite,
                                        onChanged: (isNowFavorite) {
                                          setState(() {
                                            if (isNowFavorite) {
                                              _favoriteServiceIds.add(data.id);
                                            } else {
                                              _favoriteServiceIds.remove(data.id);
                                            }
                                          });
                                        },
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: CustomColor.blackColor.withOpacity(0.3),
                                        ),
                                        child: CustomRattingAndReviews(color: CustomColor.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            10.height,

                            /// Details
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.serviceName, style: textStyle12(context)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomAmountText(
                                            amount: data.price.toString(),
                                            color: CustomColor.descriptionColor,
                                            isLineThrough: true,
                                          ),
                                          10.width,
                                          CustomAmountText(
                                            amount: data.discountedPrice.toString(),
                                            color: CustomColor.descriptionColor,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Earn up to ', style: textStyle12(
                                            context,
                                            color: CustomColor.descriptionColor,
                                            fontWeight: FontWeight.w400,
                                          )),
                                          CustomAmountText(
                                            amount: data.franchiseDetails.commission.toString(),
                                            color: CustomColor.descriptionColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  5.height,

                                  if (data.keyValues.isNotEmpty)
                                    ...data.keyValues.map((entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                          5.width,
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is ModuleServiceError) {
            return Center(child: Text(state.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
