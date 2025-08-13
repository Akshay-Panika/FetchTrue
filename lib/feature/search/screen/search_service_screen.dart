import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../../service/model/service_model.dart';


class SearchServiceScreen extends StatelessWidget {
  final String headline;
  final List<ServiceModel> services;
  const SearchServiceScreen({super.key, required this.headline, required this.services});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: services.length,
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final data = services[index];
        return CustomContainer(
          border: false,
          color: Colors.white,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsScreen(serviceId: data.id),
            ),
          ),
          padding: EdgeInsets.zero,
          margin:  EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                height: 200,
                networkImg: '${data.thumbnailImage}',
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (state is UserLoaded) {
                            final favorites = state.user.favoriteServices ?? [];
                            final isFavorite = favorites.contains(data.id);
                            final userId = state.user.id;

                            return FavoriteServiceButtonWidget(
                              userId: userId,
                              serviceId: data.id,
                              isInitiallyFavorite: isFavorite,
                              onChanged: (newFavoriteStatus) {
                                context.read<UserBloc>().add(UserFavoriteChangedEvent(
                                  serviceId: data.id,
                                  isFavorite: newFavoriteStatus,
                                ));
                              },
                            );
                          }

                          if (state is UserError) {
                            return const Icon(Icons.favorite_border, color: Colors.grey);
                          }

                          return const SizedBox.shrink();
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
                        child: Text(
                          '⭐ ${data.averageRating} (${data.totalReviews} ${'Reviews'})',
                          style: TextStyle(fontSize: 12, color:CustomColor.whiteColor ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              10.height,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data.serviceName}', style: textStyle12(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomAmountText(
                              amount: '${data.price}',
                              color: CustomColor.descriptionColor,
                              isLineThrough: true,
                            ),
                            10.width,
                            CustomAmountText(
                              amount: '${(data.discountedPrice ?? 0).toInt()}',
                              color: CustomColor.descriptionColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Earn up to ',
                              style: textStyle12(
                                context,
                                color: CustomColor.descriptionColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            CustomAmountText(
                              amount: '${data.franchiseDetails.commission}',
                              color: CustomColor.descriptionColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    5.height,
                    if (data.keyValues.isNotEmpty)
                      ...data.keyValues.map(
                            (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                              5.width,
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: textStyle12(
                                    context,
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.descriptionColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
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
  }
}
