import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../../../helper/Image_picker_helper.dart';

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
  final TextEditingController _countryController = TextEditingController();

  final ValueNotifier<String> selectedState = ValueNotifier('');
  final ValueNotifier<String> selectedCity = ValueNotifier('');
  final ValueNotifier<List<String>> cityList = ValueNotifier([]);

  final Map<String, List<String>> stateCityMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Rajkot'],
  };

  File? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _nameController.text = "Akshay Panika";
    _emailController.text = "akshay@example.com";
    _phoneController.text = "+91 8989207770";
    _addressController.text = "123, Waidhan singrauli mp";
    _countryController.text = 'India';

    selectedState.addListener(() {
      cityList.value = stateCityMap[selectedState.value] ?? [];
      selectedCity.value = '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> pickLogo() async {
    final image = await ImagePickerHelper.pickImage();
    if (image != null && mounted) {
      setState(() {
        _selectedProfile = image;
      });
    }
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
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Profile Picture and Edit Button
              Center(
                child: Stack(
                  children: [
                    CustomContainer(
                      width: 110,
                      height: 110,
                      border: true,
                      padding: EdgeInsets.zero,
                      backgroundColor: CustomColor.whiteColor,
                      // borderRadius:,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: _selectedProfile != null
                            ? Image.file(_selectedProfile!, fit: BoxFit.cover)
                            : Image.asset('assets/image/Null_Profile.jpg', fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => pickLogo(),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(Icons.edit, color: CustomColor.appColor, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              20.height,

              CustomFormField(
                context,
                'Name',
                hint: 'Enter name',
                keyboardType: TextInputType.text,
                controller: _nameController,
                isRequired: true,
              ),
              10.height,

              CustomFormField(
                context,
                'Phone',
                hint: 'Enter phone no',
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                isRequired: true,
              ),
              10.height,

              CustomFormField(
                context,
                'Email',
                hint: 'Enter email id',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                isRequired: true,
              ),
              10.height,

              CustomFormField(
                context,
                'Address',
                hint: 'Enter address',
                keyboardType: TextInputType.text,
                controller: _addressController,
                isRequired: true,
              ),
              10.height,

              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      headline: "State",
                      label: "Select State",
                      items: stateCityMap.keys.toList(),
                      selectedValue: selectedState,
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: cityList,
                      builder: (context, cities, _) {
                        return CustomDropdownField(
                          headline: "City",
                          label: "Select City",
                          items: cities,
                          selectedValue: selectedCity,
                        );
                      },
                    ),
                  ),
                ],
              ),
              10.height,

              CustomFormField(
                context,
                "Country",
                isRequired: true,
                hint: 'India',
                enabled: false,
                controller: _countryController,
                keyboardType: TextInputType.text,
              ),

              SizedBox(height: dimensions.screenHeight * 0.04),

              CustomButton(
                label: "Update Profile",
                onPressed: _updateProfile,
              ),

              SizedBox(height: dimensions.screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
