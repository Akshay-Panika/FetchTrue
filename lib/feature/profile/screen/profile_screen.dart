import 'dart:io';

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/repository/user_service.dart';
import '../../more/model/user_model.dart';
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
      getUserData(widget.userId!);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> getUserData(String userId) async {
    user = await userService.fetchUserById(userId);
    setState(() => isLoading = false);
  }


  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', showBackButton: true,),

      body:
      isLoading
          ? Center(child: CircularProgressIndicator())
          :Stack(
        alignment: AlignmentDirectional.topStart,
        children: [

          Container(
            height: 280,
            width: double.infinity,
            color: Colors.grey,
            child: selectedImage != null ? Image.file(selectedImage!, fit: BoxFit.cover,)
                : Image.asset(CustomImage.nullImage, fit: BoxFit.cover,),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 250.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              IconButton(onPressed: () => null, icon: Icon(Icons.mode_edit_outline_outlined)),
                              IconButton( onPressed: () async{
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
                            child: Text('KYC', style: textStyle14(context,color: CustomColor.greyColor),),)
                        ],
                      )
                    ],
                  ),
                ),
                10.height,

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
                    trailing: Icon(Icons.arrow_forward_ios,size: 20, color: Colors.grey,),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailsScreen(),)),
                ),
                10.height,

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
                    trailing: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen(),)),
                ),
                10.height,
              ],
            ),
          )
        ],
      ),
    );
  }
}
