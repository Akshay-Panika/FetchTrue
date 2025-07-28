import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_text_tield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _showOtp = false;
  bool _showPasswordFields = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _otpControllers.map((e) => e.text.trim()).join();
    if (otp.length == 6) {
      setState(() => _showPasswordFields = true);
    }
  }

  void _onKeyPressed(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _otpControllers[index].text.isEmpty &&
        index > 0) {
      _otpControllers[index - 1].text = '';
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Forgot Password', showBackButton: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [

            /// Phone Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset(CustomLogo.fetchTrueLogo, height: 150,)),
                RichText(
                  text: const TextSpan(
                    text: 'Phone',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
                  ),
                ),
                5.height,
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text('+91',
                            style: TextStyle(
                                color: CustomColor.appColor, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    10.width,
                    Expanded(child:
                    CustomFormField(
                      context,
                      hint: 'Enter phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                      enabled: true,
                    ),
                    ),
                  ],
                ),
              ],
            ),


            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CustomButton(
                label: 'Verify',
                onPressed: () {
                  if (_phoneController.text.length == 10) {
                    setState(() {
                      _showOtp = true;
                      _showPasswordFields = false;
                      for (var controller in _otpControllers) {
                        controller.clear();
                      }
                    });
                    _focusNodes[0].requestFocus();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter valid phone number')),
                    );
                  }
                },

              ),
            ),

            if (_showOtp)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 48,
                      child: RawKeyboardListener(
                        focusNode: FocusNode(), // for key events
                        onKey: (event) => _onKeyPressed(event, index),
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) => _onOtpChanged(value, index),
                          decoration: const InputDecoration(
                            hintText: '0',
                            counterText: '',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            if (_showPasswordFields) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password changed successfully")),
                  );
                },
                child: const Text("Reset Password"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
