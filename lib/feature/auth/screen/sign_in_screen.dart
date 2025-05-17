import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';

import '../../../core/costants/custom_logo.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_tield.dart';

class SignInScreen extends StatefulWidget {
  final Function(bool) onToggle;
  const SignInScreen({super.key, required this.onToggle});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
    } else {
      print('Sign In Successful!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ListView(
        children: [
         30.height,

          Center(child: Image.asset(CustomLogo.bizBooster, height: 80,)),
          50.height,

          CustomTextField(
            controller: _phoneController,
            labelText: 'Email/Phone *',
            hintText: 'Enter email or phone number',
            icon: null,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12),

          CustomTextField(
            controller: _passwordController,
            labelText: 'Password *',
            hintText: 'Enter your password',
            icon: null,
            obscureText: _obscurePassword,
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
                icon: Icon(
                  _obscurePassword
                      ? Icons.check_box_outline_blank
                      : Icons.check_box_outlined,
                ),
                label: Text(
                  _obscurePassword ? 'Show Password' : 'Hide Password',
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),

          CustomButton(
            text:  'Sign In',
            onTap: _signIn,
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Forgot Password')),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: CustomColor.appColor),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  widget.onToggle(true); // Go to SignUpScreen
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
