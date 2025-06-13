import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isConfirmed = false;

  void _handleDelete() {
    if (_isConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             backgroundColor: Colors.white,
             content: Text('Account deletion request submitted',style: textStyle14(context, color: CustomColor.appColor),)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
            backgroundColor: Colors.white,
            content: Text('Please confirm to proceed', style: textStyle14(context, color: CustomColor.appColor),)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Delete Account', showBackButton: true,),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 30, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to delete your account?",
                  style: textStyle18(context, color: CustomColor.redColor)
                ),
                const SizedBox(height: 16),
                Text(
                  "Deleting your account is permanent and will erase all your data including profile, history, and preferences from our servers.",
                  style: textStyle16(context, fontWeight: FontWeight.w400)
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      activeColor: CustomColor.appColor,
                      value: _isConfirmed,
                      onChanged: (value) {
                        setState(() {
                          _isConfirmed = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text("I understand the consequences and want to proceed."),
                    )
                  ],
                ),
                const Spacer(),
                CustomButton(label: 'Delete My Account',onPressed: _handleDelete,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
