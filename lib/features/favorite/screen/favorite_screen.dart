import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:bizbooster2x/core/widgets/custom_toggle_taps.dart';
import 'package:bizbooster2x/features/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Favorite',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomToggleTabs(
                labels: ['Services', 'Vendor'],
                selectedIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: selectedIndex == 0
                    ? ServiceListView(key: const ValueKey(0))
                    : VendorListView(key: const ValueKey(1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceListView extends StatelessWidget {
  const ServiceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return CustomContainer(
          border: true,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          height: 100,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  ServiceDetailsScreen(
                image: 'assets/image/thumbnail1.png',
              ),
            ),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  CustomContainer(
                    assetsImg: 'assets/image/thumbnail1.png',
                    margin: EdgeInsets.zero,
                    width:180,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Service Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children:  [
                            Text("Start from", style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            CustomAmountText(amount: '150'),
                          ],
                        ),
                        Row(
                          children:  [
                            Text("Earn up to", style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            CustomAmountText(amount: '50'),
                          ],
                        ),
                      ],
                    ),
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
      },
    );
  }
}

class VendorListView extends StatelessWidget {
  const VendorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return CustomContainer(
          border: true,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          height: 100,
          child: Stack(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage:
                    AssetImage('assets/image/Null_Profile.jpg'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 10),
                        Text(
                          "Vendor Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("Description", style: TextStyle(fontSize: 14)),
                        Text("Address", style: TextStyle(fontSize: 14)),
                      ],
                    ),
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
      },
    );
  }
}
