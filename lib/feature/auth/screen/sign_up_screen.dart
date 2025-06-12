import 'package:bizbooster2x/core/costants/custom_logo.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../../../helper/api_helper.dart';
import '../../../model/sign_up_model.dart';

class SignUpScreen extends StatefulWidget {
  final Function(bool) onToggle;

  const SignUpScreen({super.key, required this.onToggle});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _raffController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _raffController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showCustomSnackBar(context,'Please fill all the fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showCustomSnackBar(context,'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = UserRegistrationModel(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      referredBy: _raffController.text.trim(),
      isAgree: true,
    );

    // await registerUser(context,user);

    setState(() {
      _isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Center(child: Image.asset(CustomLogo.fetchTrueLogo,height: 150,)),
                  

                  CustomTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    icon: null,
                  ),

                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: null,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    icon: null,
                    keyboardType: TextInputType.phone,
                  ),

                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: null,
                    obscureText: _obscurePassword,
                  ),

                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: null,
                    obscureText: _obscurePassword,
                  ),

                  CustomTextField(
                    controller: _raffController,
                    labelText: 'Referral Code ( Optional )',
                    icon: null,
                    keyboardType: TextInputType.phone,
                  ),


                  /// Show/Hide Password Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(_obscurePassword ?Icons.check_box_outline_blank:Icons.check_box_outlined),
                        label: Text(_obscurePassword ? 'Show Password' : 'Hide Password',),),
                    ],
                  ),
                  SizedBox(height: 20,),

                ],
              ),

              Column(
                children: [
                  /// Sign Up Button
                  !_isLoading?
                  CustomButton(
                    text:  'Sign Up',
                    onTap: _signUp,
                  ):Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(CustomColor.appColor),
                      ),
                    ),
                  SizedBox(height: 20,),

                  /// Already have an account? Login Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          widget.onToggle(false); // Go back to SignInScreen
                        },
                        child: Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}

