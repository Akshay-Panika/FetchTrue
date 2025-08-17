import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_by_id_service.dart';
import '../repository/provider_repository.dart';

class ProviderGalleryWidget extends StatelessWidget {
  final String providerId;
  const ProviderGalleryWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) => ProviderBloc(ProviderRepository())..add(GetProviderById(providerId!)),
        child: BlocBuilder<ProviderBloc, ProviderState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProviderLoaded) {
              final provider = state.provider.galleryImages;

              return GridView.builder(
                itemCount: provider.length,
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullSizeImage(
                            galleryImages: provider,
                            initialSelectedImage: provider[index],
                          ),
                        ),
                      );

                    },
                    child: CustomContainer(
                      border: true,
                      color: Colors.white,
                      networkImg: provider[index],
                    ),
                  );
                },
              );

            } else if (state is ProviderError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


class FullSizeImage extends StatefulWidget {
  final List<String> galleryImages;
  final String initialSelectedImage;

  const FullSizeImage({
    super.key,
    required this.galleryImages,
    required this.initialSelectedImage,
  });

  @override
  State<FullSizeImage> createState() => _FullSizeImageState();
}

class _FullSizeImageState extends State<FullSizeImage> {
  late String selectedImageUrl;

  @override
  void initState() {
    super.initState();
    selectedImageUrl = widget.initialSelectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Gallery', showBackButton: true,),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Image.network(
                  selectedImageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                        child:
                        Icon(Icons.broken_image, size: 60, color: Colors.grey));
                  },
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.galleryImages.length,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemBuilder: (context, index) {
                final imageUrl = widget.galleryImages[index];
                final isSelected = imageUrl == selectedImageUrl;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageUrl = imageUrl;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: isSelected ? EdgeInsets.all(3) : EdgeInsets.all(0),
                    decoration: isSelected
                        ? BoxDecoration(
                      border: Border.all(color: CustomColor.appColor, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    )
                        : null,
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 40);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          50.height,
        ],
      ),
    );
  }
}
