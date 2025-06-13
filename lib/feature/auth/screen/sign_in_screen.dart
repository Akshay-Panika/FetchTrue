import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_logo.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../model/sign_in_model.dart';
import '../repository/sign_in_service.dart';

class SignInScreen extends StatefulWidget {
  final Function(bool) onToggle;
  const SignInScreen({super.key, required this.onToggle});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;


  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 🛑 Basic validation
    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar(context, '❌ Please enter both email and password');
      return;
    }

    // 📧 Email format check (if needed)
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      showCustomSnackBar(context, '❌ Please enter a valid email address');
      return;
    }

    setState(() {_isLoading = true;});

    final model = SignInModel(email: email, password: password);

    final response = await SignInService().loginUser(model);

    setState(() {_isLoading = false;});

    /// ✅ On Success
    if (response['success'] == true) {
      final userData = response['data'];
      final token = userData['token'];
      final userId = userData['user']['_id'];
      final user = userData['user']['fullName'];

     // Optionally store token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user', user);

      showCustomSnackBar(context, '✅ ${response['message']}, $user');
      Navigator.pop(context);
    }
    /// On Error
    else {
      showCustomSnackBar(context, '❌ ${response['message']}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            30.height,
        
            Center(
                child: Image.asset(
              CustomLogo.fetchTrueLogo,
              height: 200,
            )),
            30.height,

            CustomFormField(context, 'Email/Phone',
                hint: 'Enter email or phone number',
                controller: _emailController,
                keyboardType: TextInputType.text,
                isRequired: true),
            15.height,
        
            CustomFormField(context, 'Password',
                hint: 'Enter Password',
                controller: _passwordController,
                keyboardType: TextInputType.text,
                isRequired: true,
                obscureText: _obscureText ? true : false),
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
        
            CustomButton(
              label: 'Sign In',
              onPressed: _signIn,
              isLoading: _isLoading,
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
      ),
    );
  }
}
