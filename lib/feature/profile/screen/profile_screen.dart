import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../more/model/user_model.dart';
import '../../more/repository/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserService _userService;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String? userId;
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserSession>(context, listen: false);
      userId = provider.userId;

      if (userId == null) {
        // अगर लॉगिन नहीं है तो pop करके वापस ले जाए या मैसेज दिखाएं
        setState(() => isLoading = false);
        return;
      }

      _fetchUserData(userId!);
    });
  }

  Future<void> _fetchUserData(String id) async {
    final result = await _userService.fetchUserById(id);
    if (result != null) {
      setState(() {
        user = result;
        _nameController.text = result.fullName ?? '';
        _emailController.text = result.email ?? '';
        _phoneController.text = result.mobileNumber ?? '';
        _addressController.text = '' ?? '';
        _countryController.text = '' ?? '';
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Profile', showBackButton: true,),
      body: isLoading
          ?  Center(child: CircularProgressIndicator(color: CustomColor.appColor,))
          : userId == null
          ?  Center(child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(CustomImage.nullImage),),
              15.height,
              Text("Please sign in to view your profile."),
              100.height
            ],
          ))
          : user == null
          ? const Center(child: Text("No user data found."))
          : Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,

              Center(
                child: CustomContainer(
                  border: true,
                  height: 100,width: 100,
                  assetsImg: CustomImage.nullImage,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField("Name", "Enter your full name", _nameController),
                  _buildField("Phone", "Enter your mobile number", _phoneController),
                  _buildField("Email", "Enter your email address", _emailController),
                  _buildField("Address", "Enter your address", _addressController),
                  _buildField("Country", "Enter your country", _countryController),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomLabelFormField(
        context,
        label,
        hint: hint,
        controller: controller,
        keyboardType: TextInputType.text,
      ),
    );
  }

}
