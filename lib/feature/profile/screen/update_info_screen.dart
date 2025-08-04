import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../bloc/user_bloc/user_event.dart';
import '../model/user_model.dart';
import '../repository/info_service.dart';

class UpdateInfoScreen extends StatefulWidget {
  final UserModel user;
  const UpdateInfoScreen({super.key, required this.user});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool isLoading = false; // 🔄 Loader control

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.mobileNumber);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSave() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name और Email खाली नहीं हो सकते")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final success = await InfoService().updateUserInfo(
      userId: widget.user.id,
      fullName: name,
      email: email,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      showCustomSnackBar(context, 'User info saved');
      context.read<UserBloc>().add(FetchUserById(widget.user.id));
      Navigator.pop(context, true);
    } else {
      showCustomSnackBar(context, 'User info note saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Update Info', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomLabelFormField(
              context,
              'Name',
              hint: 'Update Name',
              keyboardType: TextInputType.text,
              controller: _nameController,
            ),
            SizedBox(height: 15),
            CustomLabelFormField(
              context,
              'Phone',
              hint: 'Update Phone Number',
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              enabled: false,
            ),
            SizedBox(height: 15),
            CustomLabelFormField(
              context,
              'Email Id',
              hint: 'Update Email Id',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomContainer(
                    border: true,
                    borderColor: CustomColor.appColor,
                    backgroundColor: CustomColor.whiteColor,
                    onTap: isLoading ? null : _onSave,
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: CustomColor.appColor))
                          : Text("SAVE", style: textStyle16(context)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
