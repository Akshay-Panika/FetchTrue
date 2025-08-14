import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import '../../service/model/service_model.dart';
import '../repsitory/search_service.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_search_icon.dart';

class ServiceSearchScreen extends StatefulWidget {
  const ServiceSearchScreen({super.key});

  @override
  State<ServiceSearchScreen> createState() => _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  List<ServiceModel> originalServices = []; // <-- original list
  List<ServiceModel> displayedServices = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  bool isLoading = true;
  bool isLoadingMore = false;
  int perPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadServices();
    scrollController.addListener(_scrollListener);

    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        onSearch();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void loadServices() async {
    try {
      originalServices = await fetchServices();
      _loadNextPage(originalServices);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching services: $e");
    }
  }

  void _loadNextPage(List<ServiceModel> source) {
    final start = currentPage * perPage;
    final end = start + perPage;
    if (start >= source.length) return;

    setState(() {
      displayedServices.addAll(
          source.sublist(start, end > source.length ? source.length : end));
      currentPage++;
      isLoadingMore = false;
    });
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore) {
        final query = searchController.text.trim().toLowerCase();
        List<ServiceModel> source = query.isEmpty ? originalServices : filterServicesByTag(originalServices, query);
        if (displayedServices.length < source.length) {
          setState(() {
            isLoadingMore = true;
          });
          _loadNextPage(source);
        }
      }
    }
  }

  void onSearch([String? query]) {
    final searchQuery = (query ?? searchController.text).trim().toLowerCase();

    // reset pagination & displayed list
    currentPage = 0;
    displayedServices.clear();

    List<ServiceModel> filteredList = searchQuery.isEmpty
        ? originalServices
        : filterServicesByTag(originalServices, searchQuery);

    _loadNextPage(filteredList);
  }

  List<ServiceModel> filterServicesByTag(List<ServiceModel> services, String query) {
    if (query.trim().isEmpty) return services;

    final lowerQuery = query.trim().toLowerCase();

    return services.where((service) {
      return service.tags.any((tag) => tag.trim().toLowerCase().contains(lowerQuery));
    }).toList();
  }

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
            controller: searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search here...',
              hintStyle: const TextStyle(fontSize: 16),
              prefixIcon: CustomSearchIcon(),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onSubmitted: onSearch,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : displayedServices.isEmpty
          ? const Center(child: Text("No services found"))
          : SafeArea(
            child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: displayedServices.length + 1,
                    itemBuilder: (context, index) {
            if (index == displayedServices.length) {
              return isLoadingMore
                  ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
                  : const SizedBox.shrink();
            }
            
            final service = displayedServices[index];
            return CustomContainer(
              margin: const EdgeInsets.only(bottom: 10),
              color: CustomColor.whiteColor,
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  CustomContainer(
                    height: 80,
                    width: 150,
                    networkImg: service.thumbnailImage,
                    margin: EdgeInsets.zero,
                  ),
                  10.width,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.serviceName),
                        Text(
                          '⭐ ${service.averageRating} (${service.totalReviews} Reviews)',
                          style: textStyle12(context),
                        ),
                        5.height,
                        Row(
                          children: [
                            CustomAmountText(
                                amount: '${service.price}', isLineThrough: true),
                            10.width,
                            CustomAmountText(amount: '${service.discountedPrice}'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: service.id),)),
            );
                    },
                  ),
          ),
    );
  }
}
