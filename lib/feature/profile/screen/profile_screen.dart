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
import '../../more/model/user_model.dart';
import '../../more/repository/user_service.dart';


class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

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

  final UserService _userService = UserService();
  UserModel? _userData;
  bool _isLoading = true;
  File? _selectedProfile;

  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    fetchUserProfile();

    selectedState.addListener(() {
      cityList.value = stateCityMap[selectedState.value] ?? [];
      selectedCity.value = '';
    });
  }

  Future<void> fetchUserProfile() async {
    final data = await _userService.fetchUserById(userId);

    if (data != null) {
      setState(() {
        _userData = data;
        _isLoading = false;

        _nameController.text = data.fullName;
        _emailController.text = data.email;
        _phoneController.text = data.mobileNumber;
        _addressController.text = data.toJson()['address'] ?? '';
        _countryController.text = data.toJson()['country'] ?? 'India';

        selectedState.value = data.toJson()['state'] ?? '';
        selectedCity.value = data.toJson()['city'] ?? '';
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load user data")),
      );
    }
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
      setState(() => _selectedProfile = image);
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
        child:
        _isLoading ? Center(child: CircularProgressIndicator(color: CustomColor.appColor,)) :
        SingleChildScrollView(
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

              CustomLabelFormField(
                context,
                'Name',
                hint: 'Enter name',
                keyboardType: TextInputType.text,
                controller: _nameController,
                isRequired: true,
              ),
              10.height,

              CustomLabelFormField(
                context,
                'Phone',
                hint: 'Enter phone no',
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                isRequired: true,
              ),
              10.height,

              CustomLabelFormField(
                context,
                'Email',
                hint: 'Enter email id',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                isRequired: true,
              ),
              10.height,

              CustomLabelFormField(
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

              CustomLabelFormField(
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
