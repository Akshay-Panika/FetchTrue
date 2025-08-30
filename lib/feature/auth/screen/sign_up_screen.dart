import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/auth/firebase_uth/verify_number_service.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_logo.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../../../core/costants/text_style.dart';
import '../repository/sign_up_service.dart';

class SignUpScreen extends StatefulWidget {
  final Function(bool) onToggle;
  const SignUpScreen({super.key, required this.onToggle});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _raffController = TextEditingController();

  final VerifyNumberService _verifyNumberService = VerifyNumberService();
  final SignUpService _signUpService = SignUpService();

  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
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

            /// Full Name
            CustomLabelFormField(
              context,
              'Full name',
              hint: 'Enter full name',
              controller: _fullNameController,
              keyboardType: TextInputType.text,
              isRequired: true,
              enabled: !_isOtpVerified,
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
                    Expanded(child:
                    CustomFormField(
                      context,
                      hint: 'Enter phone number',
                      controller: _phoneController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      enabled: !_isOtpVerified,
                    ),
                    ),
                  ],
                ),
              ],
            ),
            15.height,

            /// Verify Button
            if (!_isOtpVerified)
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: CustomButton(
                  isLoading: _isLoading,
                  label: 'Verify Number',
                  onPressed: () async {
                    final fullName = _fullNameController.text.trim();
                    final phone = _phoneController.text.trim().replaceAll(" ", "");

                    if (fullName.isEmpty || phone.isEmpty) {
                      showCustomSnackBar(
                          context, 'Please enter full name and phone number first');
                      return;
                    }

                    if (fullName.length < 3) {
                      showCustomSnackBar(context, 'Please Enter correct name');
                      return;
                    }

                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(fullName)) {
                      showCustomSnackBar(context, 'Full name can contain only letters and spaces');
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
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
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
              ),

            /// User Info Fields (Always shown)
            if (_isOtpVerified)
              Column(
                children: [
                  CustomLabelFormField(
                    context,
                    'Email',
                    hint: 'Enter email id',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                  ),
                  15.height,

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
                  15.height,

                  CustomLabelFormField(
                    context,
                    'Referral Code (Optional)',
                    hint: 'Enter referral code',
                    controller: _raffController,
                    keyboardType: TextInputType.text,
                    isRequired: false,
                  ),
                  50.height,

                  CustomButton(
                    isLoading: _isLoading,
                    label: 'Sign Up',

                      onPressed: () async {
                        final email = _emailController.text.trim().toLowerCase();
                        final password = _passwordController.text.trim();
                        final confirmPassword = _confirmPasswordController.text.trim();
                        final name = _fullNameController.text.trim();
                        final phone = _phoneController.text.trim();
                        final referredBy = _raffController.text.trim();

                        // 🛑 Empty field check
                        if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
                          showCustomSnackBar(context, 'Please fill all required fields');
                          return;
                        }

                        // 📧 Email validation
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                          showCustomSnackBar(context, 'Please enter a valid email address');
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
                          final response = await _signUpService.registerUser(
                            fullName: name,
                            email: email,
                            mobileNumber: phone,
                            password: password,
                            referredBy: referredBy,
                            isAgree: true,
                          );

                          if (response.statusCode == 200) {
                            showCustomSnackBar(context, '🎉 Registration successful');
                            widget.onToggle(false); // Navigate to Sign In
                          } else {
                            showCustomSnackBar(context, 'Something went wrong');
                          }
                        } catch (e) {
                          showCustomSnackBar(context, e.toString());
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      }


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

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final VerifyNumberService verifyService;
  const VerifyOtpScreen({super.key, required this.phoneNumber, required this.verifyService});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: const CustomAppBar(title: 'Verify OTP', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/image/otpImage.jpg', height: 280),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Enter the verification code sent to ',
                    style: textStyle14(context, color: CustomColor.descriptionColor),
                  ),
                  TextSpan(
                    text: '+91 ${widget.phoneNumber}',
                    style: textStyle14(context, color: CustomColor.greenColor),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Wrong Number?", style: textStyle14(context)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      onChanged: (value) => _onOtpChanged(value, index),
                      decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 50),
            CustomButton(
              label: 'Verify OTP',
              isLoading: _isVerifying,
              onPressed: () async {
                final otp = _controllers.map((e) => e.text.trim()).join();

                if (otp.length != 6 || otp.contains(RegExp(r'\D'))) {
                  showCustomSnackBar(context, 'Please enter a valid 6-digit OTP');
                  return;
                }

                setState(() => _isVerifying = true);
                try {
                  final verified = await widget.verifyService.verifyOtp(otp);
                  if (verified) {
                    Navigator.pop(context, true);
                  } else {
                    showCustomSnackBar(context, 'OTP verification failed');
                  }
                } catch (e) {
                  showCustomSnackBar(context, 'Something went wrong otp');
                } finally {
                  setState(() => _isVerifying = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
