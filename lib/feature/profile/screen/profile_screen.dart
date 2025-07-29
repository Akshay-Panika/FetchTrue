import 'dart:io';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/profile/screen/update_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../auth/repository/user_service.dart';
import '../model/user_model.dart';
import '../widget/address_widget.dart';
import 'add_address_screen.dart';
import 'additional_details_screen.dart';


class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  final userService = UserService();
  UserModel? user;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      getUserData(widget.userId.toString());
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> getUserData(String userId) async {
    user = await userService.fetchUserById(userId);
    setState(() => isLoading = false);
  }


  File? selectedImage;

  // Future<void> pickImageFromGallery() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() {
  //       selectedImage = File(picked.path);
  //     });
  //   }
  // }

  Future<void> pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      File imageFile = File(picked.path);
      setState(() {
        selectedImage = imageFile;
      });

      // 🔁 Immediately upload image after selection
      if (widget.userId != null) {
        var request = http.MultipartRequest(
          'PATCH',
          Uri.parse('https://biz-booster.vercel.app/api/users/update-profile-photo/${widget.userId}'),
        );

        request.files.add(await http.MultipartFile.fromPath(
          'profilePhoto',
          imageFile.path,
        ));

        try {
          var response = await request.send();

          if (response.statusCode == 200) {
            print("✅ Profile photo updated");
            // Optionally, refresh user data from server
            await getUserData(widget.userId!);
          } else {
            print("❌ Failed to upload: ${response.statusCode}");
          }
        } catch (e) {
          print("❌ Upload error: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('______________user id ${widget.userId}');
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', showBackButton: true,),

      body:
      isLoading
          ? shimmerProfileView(context)
          :Stack(
        alignment: AlignmentDirectional.topStart,
        children: [

          Container(
            height: 280,
            width: double.infinity,
            color: Colors.grey,
          //   child: selectedImage != null ? Image.file(selectedImage!, fit: BoxFit.cover,)
          //       : Image.asset(CustomImage.nullImage, fit: BoxFit.cover,),
          // ),
            child: selectedImage != null
                ? Image.file(selectedImage!, fit: BoxFit.cover)
                : (user?.profilePhoto != null
                ? Image.network(user!.profilePhoto!, fit: BoxFit.cover)
                : Image.asset(CustomImage.nullImage, fit: BoxFit.cover)),
          ),

          Container(
            child:  SingleChildScrollView(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  250.height,
                  CustomContainer(
                    border: false,
                    backgroundColor: Colors.white,
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Personal Details', style: textStyle16(context),),
              
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (widget.userId != null) {
                                      bool? updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateInfoScreen(user: user!),
                                        ),
                                      );

                                      if (updated == true) {
                                        await getUserData(widget.userId!);
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.mode_edit_outline_outlined),
                                ),

                                IconButton( onPressed: () async{
                                  if(widget.userId != null)
                                    await pickImageFromGallery();
                                }, icon: Icon(Icons.camera_alt_outlined)),
                              ],
                            )
                          ],
                        ),
                        10.height,
              
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user?.fullName ?? 'Guest', style: textStyle18(context)),
                                    Text( user?.mobileNumber != null
                                        ? '+91 ${user!.mobileNumber}'
                                        : 'Mobile Number', style: textStyle14(context, color: CustomColor.descriptionColor)),
                                    Text(user?.email ?? 'Email ID', style: textStyle14(context, color: CustomColor.descriptionColor)),
                                  ],
                                ),
                              ],
                            ),
              
                            CustomContainer(
                              border: true,
                              backgroundColor: CustomColor.whiteColor,
                              margin: EdgeInsets.zero,padding: EdgeInsetsGeometry.symmetric(horizontal: 30,vertical: 5),
                              child: Row(
                                children: [
                                  Icon(Icons.verified, size: 20,color: Colors.grey,),10.width,
                                  Text('KYC', style: textStyle14(context,color: CustomColor.greyColor),),
                                ],
                              ),)
                          ],
                        )
                      ],
                    ),
                  ),
                  10.height,

                  /// Additional Details
                  CustomContainer(
                      border: false,
                      backgroundColor: CustomColor.whiteColor,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        minVerticalPadding: 0,
                        minTileHeight: 0,
                        contentPadding: EdgeInsets.all(0),
                        title: Text('Additional Details'),
                        subtitle: Text('Age, gender, and more'),
                        trailing: Icon(Icons.add,size: 20, color: Colors.grey,),
                      ),
              
                      onTap: () {
                        if(widget.userId != null) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailsScreen(user: user!.id.toString(),),));
                        }
                      }
                  ),
                  10.height,

                  /// Add Address
                  CustomContainer(
                      border: false,
                      backgroundColor: CustomColor.whiteColor,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        minVerticalPadding: 0,
                        minTileHeight: 0,
                        contentPadding: EdgeInsets.all(0),
                        title: Text('Address'),
                        subtitle: Text('Add Address',),
                        trailing: Icon(Icons.add,color: Colors.grey,),
                      ),
                      // onTap: () async{
                      //   if(widget.userId != null)
                      //     bool? result = await  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen(userId: user!.id.toString(),),));
                      // }
                      onTap: () async {
                        if (widget.userId != null) {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAddressScreen(userId: user!.id.toString()),
                            ),
                          );

                          // If result is true, refresh user data
                          if (result == true) {
                            await getUserData(widget.userId.toString());
                          }
                        }
                      }

                  ),
                  10.height,

                  if (user?.homeAddress != null || user?.workAddress != null || user?.otherAddress != null)
                  CustomContainer(
                    margin: EdgeInsets.zero,
                    backgroundColor: CustomColor.whiteColor,
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user?.homeAddress != null)
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            minTileHeight: 0,
                            minVerticalPadding: 0,
                            minLeadingWidth: 0,
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: const Icon(Icons.home),
                            title: const Text("Home Address"),
                            subtitle: Text(_formatAddress(user!.homeAddress!),),
                          ),
                        if (user?.workAddress != null)
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            minTileHeight: 0,
                            minVerticalPadding: 0,
                            minLeadingWidth: 0,
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: const Icon(Icons.work),
                            title: const Text("Work Address"),
                            subtitle: Text(
                              _formatAddress(user!.workAddress!),
                            ),
              
                          ),
                        if (user?.otherAddress != null)
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            minTileHeight: 0,
                            minVerticalPadding: 0,
                            minLeadingWidth: 0,
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: const Icon(Icons.location_pin),
                            title: const Text("Other Address"),
                            subtitle: Text(
                              _formatAddress(user!.otherAddress!),
                            ),
                          ),
                      ],
                    ),
                  ),
                  50.height
              
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  String _formatAddress(dynamic address) {
    return [
      address.houseNumber,
      address.landmark,
      address.fullAddress,
      address.city,
      address.state,
      address.pinCode,
    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');
  }

}


Widget shimmerProfileView(BuildContext context) {
  return  Stack(
    alignment: AlignmentDirectional.topStart,
    children: [
      // Cover Image
      Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ShimmerBox(height: 280, width: double.infinity)),

      // Profile Container
      Padding(
        padding: const EdgeInsets.only(top: 250.0, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Details Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(height: 16, width: 120),
                        Row(
                          children: [
                            ShimmerBox(height: 24, width: 24, borderRadius: BorderRadius.circular(4)),
                            const SizedBox(width: 8),
                            ShimmerBox(height: 24, width: 24, borderRadius: BorderRadius.circular(4)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Name, Phone, Email + KYC
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(height: 18, width: 160),
                            const SizedBox(height: 6),
                            ShimmerBox(height: 14, width: 100),
                            const SizedBox(height: 4),
                            ShimmerBox(height: 14, width: 140),
                          ],
                        ),
                        ShimmerBox(
                          height: 28,
                          width: 60,
                          borderRadius: BorderRadius.circular(20),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Additional Details
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child:Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 16, width: 140),
                        const SizedBox(height: 4),
                        ShimmerBox(height: 12, width: 100),
                      ],
                    ),
                    ShimmerBox(height: 20, width: 20, borderRadius: BorderRadius.circular(4)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Address
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 16, width: 100),
                        const SizedBox(height: 4),
                        ShimmerBox(height: 12, width: 80),
                      ],
                    ),
                    ShimmerBox(height: 20, width: 20, borderRadius: BorderRadius.circular(4)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}
