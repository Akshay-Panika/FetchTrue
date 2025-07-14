import 'package:fetchtrue/core/costants/custom_image.dart';
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
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _isOtpVerified ? 150 : 300,
                child: Image.asset(CustomLogo.fetchTrueLogo),
              ),
            ),

            // Center(child: Image.asset(CustomLogo.fetchTrueLogo, height: _isOtpVerified ?100 : 300)),

            CustomFormField(
              context,
              'Full name',
              hint: 'Enter full name',
              controller: _fullNameController,
              keyboardType: TextInputType.text,
              isRequired: true,
              enabled: _isOtpVerified ?false :true
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
                              borderSide: BorderSide(color: Colors.grey.shade300)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.grey.shade300)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300)
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300)
                          ),
                          filled: true,
                          // fillColor: Colors.white,
                          fillColor: _isOtpVerified ? Colors.grey.shade200 : CustomColor.whiteColor,
                          enabled: _isOtpVerified ? false :true,
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
      appBar: const CustomAppBar(title: 'Verify OTP', showBackButton: true),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/image/otpImage.jpg',
                  height: 300,
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ OTP Description
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Enter the verification code sent to ',
                      style: textStyle14(context, color: CustomColor.descriptionColor),
                    ),
                    TextSpan(
                      text: '+91 XXXX XXXX XX ',
                      style: textStyle14(context, color: CustomColor.greenColor),
                    ),
                    TextSpan(
                      text: 'Wrong Number ?',
                      style: textStyle14(context, color: CustomColor.blackColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ OTP TextFields
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ Resend Info
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Didn't receive the code? ",
                        style: textStyle14(context, color: CustomColor.descriptionColor),
                      ),
                      TextSpan(
                        text: 'Resend in 00:30',
                        style: textStyle14(context, color: CustomColor.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),

              /// ✅ Verify OTP Button
              CustomButton(
                isLoading: false,
                label: 'Verify OTP',
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}
