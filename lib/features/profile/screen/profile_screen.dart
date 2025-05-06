import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_text_tield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = "Akshay Panika";
    _emailController.text = "akshay@example.com";
    _phoneController.text = "+91 8989207770";
    _addressController.text = "123, Waidhan singrauli mp";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    print("Profile Updated:");
    print("Name: ${_nameController.text}");
    print("Email: ${_emailController.text}");
    print("Phone: ${_phoneController.text}");
    print("Address: ${_addressController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // Profile Picture and Name Section
            Stack(
              children: [
                CustomContainer(
                  width: 100,
                  height: 100,
                border: true,
                assetsImg: 'assets/image/Null_Profile.jpg',
                ),
                
                Positioned(
                    bottom: 0, right: 0,
                    child: CircleAvatar(
                        backgroundColor: Colors.grey.shade50,
                        child: Icon(Icons.edit, color: CustomColor.appColor,)))
              ],
            ),
            SizedBox(height: 10),

            // Profile Form Fields with CustomTextField
            CustomTextField(
              controller: _nameController,
              labelText: "Full Name",
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: _emailController,
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: _phoneController,
              labelText: "Phone Number",
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: _addressController,
              labelText: "Address",
            ),
            SizedBox(height: 50),

            // Update Profile Button
            CustomButton(text: "Update Profile",),
          ],
        ),
      ),
    );
  }
}
