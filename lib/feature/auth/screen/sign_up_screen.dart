import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_logo.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_tield.dart';

class SignUpScreen extends StatefulWidget {
  final Function(bool) onToggle;
  const SignUpScreen({super.key, required this.onToggle});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _raffController = TextEditingController();

  bool _obscureText = true;
  bool _isOtpVerified = false; // ✅ Only controls verify button visibility

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            Center(child: Image.asset(CustomLogo.fetchTrueLogo, height: 100)),

            CustomFormField(
              context,
              'Full name',
              hint: 'Enter full name',
              controller: _fullNameController,
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
            15.height,

            /// Phone Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: textStyle14(context,
                            color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: textStyle14(context,
                              color: CustomColor.descriptionColor,
                              fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        validator: (value) => null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            15.height,

            /// ✅ Show verify button only if OTP not verified
            if (!_isOtpVerified)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CustomButton(
                  isLoading: false,
                  label: 'Verify Number',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VerifyOtpScreen()),
                    );
                    if (result == true) {
                      setState(() {
                        _isOtpVerified = true; // ✅ Hide verify button only
                      });
                    }
                  },
                ),
              ),

            /// User Info Fields (Always shown)
            if (_isOtpVerified)
             Column(
               children: [
                 CustomFormField(
                   context,
                   'Email',
                   hint: 'Enter email id',
                   controller: _emailController,
                   keyboardType: TextInputType.emailAddress,
                   isRequired: true,
                 ),
                 15.height,

                 CustomFormField(
                   context,
                   'Password',
                   hint: 'Enter password',
                   controller: _passwordController,
                   keyboardType: TextInputType.text,
                   isRequired: true,
                   obscureText: _obscureText,
                 ),
                 15.height,

                 CustomFormField(
                   context,
                   'Confirm Password',
                   hint: 'Enter confirm password',
                   controller: _confirmPasswordController,
                   keyboardType: TextInputType.text,
                   isRequired: true,
                   obscureText: _obscureText,
                 ),
                 15.height,

                 CustomFormField(
                   context,
                   'Referral Code (Optional)',
                   hint: 'Enter referral code',
                   controller: _raffController,
                   keyboardType: TextInputType.text,
                   isRequired: false,
                 ),
                 10.height,

                 Align(
                   alignment: Alignment.centerRight,
                   child: TextButton.icon(
                     onPressed: () {
                       setState(() {
                         _obscureText = !_obscureText;
                       });
                     },
                     icon: Icon(
                         _obscureText ? Icons.visibility_off : Icons.visibility,
                         color: CustomColor.appColor),
                     label: Text('Show Password',
                         style: textStyle12(context, color: CustomColor.appColor)),
                   ),
                 ),
                 20.height,

                 CustomButton(
                   isLoading: false,
                   label: 'Sign Up',
                   onPressed: () => null,
                 ),
               ],
             ) ,
            30.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account ?'),
                TextButton(
                  onPressed: () => widget.onToggle(false),
                  child: Text('Sign In', style: textStyle14(context, color: CustomColor.appColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: const CustomAppBar(showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.height,
            Text('Verify OTP', style: textStyle18(context, color: CustomColor.appColor)),
            12.height,
            Text(
              'A 6-digit verification code has been sent to your number/email.',
              style: TextStyle(color: CustomColor.descriptionColor, fontSize: 16),
            ),
            100.height,

            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            20.height,
            Center(
              child: Text("Didn't receive the code? Resend in 00:30",
                  style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            ),
            40.height,
            CustomButton(
              isLoading: false,
              label: 'Verify OTP',
              onPressed: () {
                // ✅ return success result
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
