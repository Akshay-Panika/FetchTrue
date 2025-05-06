import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_tield.dart';

class SignUpScreen extends StatefulWidget {
  final Function(bool) onToggle;

  const SignUpScreen({super.key, required this.onToggle});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _raffController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    // Basic validation to check if fields are empty
    if (_firstNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
    } else if (_passwordController.text != _confirmPasswordController.text) {
      // Check if password and confirm password match
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
    } else {
      // Proceed with the sign-up process
      print('Sign Up Successful!');
      // You can add Firebase or any other backend sign-up logic here
    }
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
                  SizedBox(height: 20),
                  Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  CustomContainer(
                    height: 100,
                    backgroundColor: Colors.transparent,
                    margin: EdgeInsets.all(0),
                    child: Center(child: Image.asset('assets/auth/signinImg.png', color: CustomColor.appColor.withOpacity(0.3),)),
                  ),

                  // Sign Up Form Fields
                  CustomTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    icon: null,
                  ),


                  CustomTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
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
                    obscureText: _obscureConfirmPassword,
                  ),

                  CustomTextField(
                    controller: _raffController,
                    labelText: 'Referral Code',
                    icon: null,
                    keyboardType: TextInputType.phone,
                  ),


                  /// Show/Hide Password Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

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
                            label: Text(_obscurePassword ? 'Show Password' : 'Hide Password',),)

                        ],
                      ),
                    ],
                  ),

                ],
              ),

              Column(
                children: [
                  /// Sign Up Button
                  CustomButton(
                    text:  'Sign Up',
                    onTap: _signUp,
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

