import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/features/auth/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/custom_text_tield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

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
    // Basic validation to check if fields are empty
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
    } else {
      // Proceed with the sign-in process
      print('Sign In Successful!');
      // You can add Firebase or any other backend sign-in logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    // appBar: CustomAppBar(title: '',),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [

            SizedBox(height: 20),
            Text('Welcome!', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            SizedBox(height: 20),


            CustomContainer(
              height: 200,
              margin: EdgeInsets.all(0),
            ),
            SizedBox(height: 12),

            /// Sign In Form Fields
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone',
              icon: Icons.phone,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              icon: Icons.lock,
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 20),

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
                  label: Text(_obscurePassword ? 'Show Password' : 'Hide Password',),)

              ],
            ),

            /// Sign In Button
            CustomContainer(
              backgroundColor: CustomColor.appColor,
              onTap: _signIn,
              child: Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            /// Forgot Password Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Forgot Password')));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: CustomColor.appColor),
                  ),
                ),
              ],
            ),

            /// Don't have an account? Sign Up Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



