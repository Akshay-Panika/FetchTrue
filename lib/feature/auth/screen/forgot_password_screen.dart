import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/feature/auth/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../firebase_uth/verify_number_service.dart';
import '../repository/forgot_password_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final VerifyNumberService _verifyNumberService = VerifyNumberService();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();

  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Forgot Password', showBackButton: true,),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: _isOtpVerified ? 150 : 300,
                    child: Image.asset(CustomLogo.fetchTrueLogo),
                  ),
                ),

                /// Phone Field
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
                      enabled: !_isOtpVerified,
                    ),
                    ),
                  ],
                ),


                /// Password
                if (_isOtpVerified)
                Column(
                  children: [
                    20.height,

                    CustomLabelFormField(
                        context,
                        'Password',
                        hint: 'Enter password',
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        isRequired: true,
                        obscureText: _obscureText,
                        suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon( _obscureText ? Icons.visibility_off : Icons.visibility,color: CustomColor.appColor,),)
                    ),
                    15.height,

                    CustomLabelFormField(
                        context,
                        'Confirm Password',
                        hint: 'Enter confirm password',
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.text,
                        isRequired: true,
                        obscureText: _obscureText,
                        suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon( _obscureText ? Icons.visibility_off : Icons.visibility,color: CustomColor.appColor,),)
                    ),
                  ],
                )
              ],
            ),

            /// Verify Button
            Column(
                children: [
                  200.height,
                  if (!_isOtpVerified)
                  CustomButton(
                    isLoading: _isLoading,
                    label: 'Verify Number',
                    onPressed: () async {
                      final phone = _phoneController.text.trim().replaceAll(" ", "");

                      if (phone.isEmpty) {
                        showCustomSnackBar(context, 'Please enter phone number ');
                        return;
                      }

                      if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                        showCustomSnackBar(context, 'Please enter a valid 10-digit phone number');
                        return;
                      }

                      setState(() => _isLoading = true);

                      try {
                        await _verifyNumberService.sendOtp(
                          phone,
                          onCodeSent: (verificationId) async {
                            setState(() => _isLoading = false);
                            final result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => VerifyOtpScreen(
                                phoneNumber: phone,
                                verifyService: _verifyNumberService,
                              ),
                            ),
                            );
                            if (result == true) {
                              setState(() => _isOtpVerified = true);
                            }
                          },
                        );
                      } catch (e) {
                        setState(() => _isLoading = false);
                        showCustomSnackBar(context, e.toString());
                      }
                    },
                  ),

                  if (_isOtpVerified)
                  CustomButton(
                      isLoading: _isLoading,
                      label: 'Save Password',

                      onPressed: () async {
                        final password = _passwordController.text.trim();
                        final confirmPassword = _confirmPasswordController.text.trim();
                        final phone = _phoneController.text.trim();

                        // 🛑 Empty field check
                        if (password.isEmpty || phone.isEmpty) {
                          showCustomSnackBar(context, 'Please fill all required fields');
                          return;
                        }


                        final lowered = password.toLowerCase();

                        // 🔐 Password length check
                        if (password.length < 8 || password.length > 15) {
                          showCustomSnackBar(context, 'Password must be between 8 to 15 characters.');
                          return;
                        }

                        // 🚫 Block strictly sequential numbers like "12345678"
                        bool hasStrictSequentialNumbers(String input) {
                          for (int i = 0; i <= input.length - 4; i++) {
                            int a = int.tryParse(input[i]) ?? -100;
                            int b = int.tryParse(input[i + 1]) ?? -100;
                            int c = int.tryParse(input[i + 2]) ?? -100;
                            int d = int.tryParse(input[i + 3]) ?? -100;

                            if (b == a + 1 && c == b + 1 && d == c + 1) {
                              return true;
                            }
                          }
                          return false;
                        }

                        // 🚫 Block strictly sequential alphabets like "abcdefg"
                        bool hasStrictSequentialAlphabets(String input) {
                          for (int i = 0; i <= input.length - 4; i++) {
                            int a = input.codeUnitAt(i);
                            int b = input.codeUnitAt(i + 1);
                            int c = input.codeUnitAt(i + 2);
                            int d = input.codeUnitAt(i + 3);

                            if (b == a + 1 && c == b + 1 && d == c + 1) {
                              return true;
                            }
                          }
                          return false;
                        }

                        if (hasStrictSequentialNumbers(lowered) || hasStrictSequentialAlphabets(lowered)) {
                          showCustomSnackBar(context, 'Avoid using sequential patterns like "1234" or "abcd" in password.');
                          return;
                        }

                        // 🔁 Confirm password match
                        if (password != confirmPassword) {
                          showCustomSnackBar(context, 'Passwords do not match');
                          return;
                        }

                        // ✅ Everything passed
                        setState(() => _isLoading = true);

                        try {
                          final forgotService = ForgotPasswordService(); // singleton ApiClient internally
                          await forgotService.forgotPasswordUser(
                            mobileNumber: phone,
                            newPassword: password,
                          );

                          showCustomToast('🎉 Password reset successful');
                          Navigator.pop(context); // Navigate to Sign In

                        } catch (e) {
                          showCustomSnackBar(context, e.toString());
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      }
                  ),
                ],
              ) ,
          ],
        ),
      )
    );
  }
}
