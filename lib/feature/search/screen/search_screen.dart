import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_search_icon.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../home/widget/all_service_widget.dart';
import '../../home/widget/recommended_ervices_widget.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';
import '../../service/screen/service_details_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final bool _isSearch = false; // static value for now

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomContainer(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search here...',
              hintStyle: const TextStyle(fontSize: 16),
              prefixIcon: CustomSearchIcon(),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // /// Recent Searches
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.all(15.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: const [
            //             Text(
            //               'Recent Searches',
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //             Text(
            //               'Clear',
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.blueAccent,
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 10),
            //         Wrap(
            //           spacing: 8,
            //           children: List.generate(5, (index) {
            //             return Chip(
            //               backgroundColor: Colors.white,
            //               label: Text('Search $index'),
            //               deleteIcon: const Icon(Icons.close, size: 16),
            //             );
            //           }),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            /// Non-search UI
            if (!_isSearch)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    AllServiceWidget(headline: 'Popular Services'),
                    const SizedBox(height: 20),
                    RecommendedServicesWidget(headline: 'Requirement Services'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

            /// Search Result List
            if (_isSearch)
              SliverToBoxAdapter(
                child: BlocProvider(
                  create: (_) =>
                  ModuleServiceBloc(ApiService())..add(GetModuleService()),
                  child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
                    builder: (context, state) {
                      if (state is ModuleServiceLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ModuleServiceLoaded) {
                        final services = state.serviceModel;
                        if (services.isEmpty) {
                          return const Center(child: Text('No Service found.'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final data = services[index];
                            return CustomContainer(
                              border: false,
                              color: Colors.white,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailsScreen(
                                    serviceId: data.id,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomContainer(
                                    height: 200,
                                    networkImg: data.thumbnailImage ?? '',
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.favorite_border),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                              color: CustomColor.blackColor
                                                  .withOpacity(0.3),
                                            ),
                                            child: Text(
                                              '⭐ ${data.averageRating} (${data.totalReviews} Reviews)',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.serviceName ?? '',
                                          style: textStyle12(context),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CustomAmountText(
                                                  amount: '${data.price}',
                                                  color: CustomColor
                                                      .descriptionColor,
                                                  isLineThrough: true,
                                                ),
                                                const SizedBox(width: 10),
                                                CustomAmountText(
                                                  amount:
                                                  '${(data.discountedPrice ?? 0).toInt()}',
                                                  color: CustomColor
                                                      .descriptionColor,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Earn up to ',
                                                  style: textStyle12(
                                                    context,
                                                    color: CustomColor
                                                        .descriptionColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                CustomAmountText(
                                                  amount:
                                                  '${data.franchiseDetails?.commission ?? ''}',
                                                  color: CustomColor
                                                      .descriptionColor,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        if (data.keyValues.isNotEmpty)
                                          ...data.keyValues.map(
                                                (entry) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${entry.key} :',
                                                    style: textStyle12(
                                                      context,
                                                      color: CustomColor
                                                          .descriptionColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                      entry.value,
                                                      style: textStyle12(
                                                        context,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: CustomColor
                                                            .descriptionColor,
                                                      ),
                                                      overflow:
                                                      TextOverflow.ellipsis,
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
                      } else if (state is ModuleServiceError) {
                        return Center(child: Text(state.errorMessage));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
