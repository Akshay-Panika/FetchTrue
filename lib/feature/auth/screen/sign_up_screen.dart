import 'package:bizbooster2x/core/costants/custom_logo.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/services.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../../../helper/api_helper.dart';

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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Center(child: Image.asset(CustomLogo.fetchTrueLogo,height: 150,)),

                  CustomFormField(context, 'Full name',
                      hint: 'Enter full name',
                      controller: _fullNameController,
                      keyboardType: TextInputType.text,
                      isRequired: true),
                  15.height,

                  CustomFormField(context, 'Phone',
                      hint: 'Enter phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.text,
                      isRequired: true),
                  15.height,

                  CustomFormField(context, 'Email',
                      hint: 'Enter email id',
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      isRequired: true),
                  15.height,

                  CustomFormField(context, 'Password',
                      hint: 'Enter password',
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                      obscureText: _obscureText ? true : false),
                  15.height,

                  CustomFormField(context, 'Confirm Password',
                      hint: 'Enter confirm password',
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                      obscureText: _obscureText ? true : false),
                  15.height,

                  CustomFormField(context, 'Referral Code (Optional)',
                      hint: 'Enter referral code',
                      controller: _raffController,
                      keyboardType: TextInputType.text,
                      isRequired: false),
                  10.height,

                  /// Show/Hide Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon( _obscureText ? Icons.visibility_off:Icons.visibility, color: CustomColor.appColor,),
                      label: Text('Show Password', style: textStyle12(context, color: CustomColor.appColor),),
                    ),
                  ),
                  20.height,

                ],
              ),

              Column(
                children: [
                  CustomButton(
                    label:  'Sign Up',
                    onPressed: () => null,
                  ),
                  20.height,

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

