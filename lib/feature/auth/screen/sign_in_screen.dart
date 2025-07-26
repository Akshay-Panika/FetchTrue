import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_logo.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_alert_dialog.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../repository/sign_in_service.dart';
import '../user_notifier/user_notifier.dart';

class SignInScreen extends StatefulWidget {
  final Function(bool) onToggle;
  const SignInScreen({super.key, required this.onToggle});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _mainController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  bool _obscureText = true;
  bool _isLoading = false;

  String? prefixText;
  String inputLabel = 'Email/Phone';

  @override
  void initState() {
    super.initState();
    _mainController.addListener(() {
      setState(() {
        _updateInputLabel(_mainController.text);
      });
    });
  }


  void _updateInputLabel(String input) {
    if (RegExp(r'^\d+$').hasMatch(input)) {
      inputLabel = 'Phone';
      prefixText = '+91 ';
    } else if (input.contains('@') || RegExp(r'[a-zA-Z]').hasMatch(input)) {
      inputLabel = 'Email';
      prefixText = null;
    } else {
      inputLabel = 'Email/Phone';
      prefixText = null;
    }
  }

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final input = _mainController.text.trim();
    final password = _passwordController.text.trim();

    String email = "";
    String mobileNumber = "";

    if (RegExp(r'^\d{10}$').hasMatch(input)) {
      mobileNumber = input;
    } else if (input.contains('@')) {
      // email = input;
      email = input.toLowerCase();
    } else {
      showCustomSnackBar(context, "Please enter a valid email or 10-digit phone number.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await SignInService.signIn(
        mobileNumber: mobileNumber,
        email: email,
        password: password,
      );

      setState(() => _isLoading = false);

      if (response != null) {
        /// ✅ Use centralized UserSession (no SharedPreferences here)
        await Provider.of<UserSession>(context, listen: false).login(
          response.user.id,
          response.token,
          response.user.fullName,
          response.user.email,
          response.user.createdAt
        );

        showCustomSnackBar(context, "Login Success: ${response.user.fullName}");
        Navigator.pop(context, true); // return success
      } else {
        showCustomSnackBar(context, "Login failed. Please check your credentials.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showCustomSnackBar(context, "Login Error: ${e.toString()}");
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
                height: 180,
            )),
            30.height,

            CustomLabelFormField(
              context,
              inputLabel,
              hint: 'Enter email or phone number',
              prefixText: prefixText,
              controller: _mainController,
              keyboardType: TextInputType.text,
              isRequired: true,
            ),

            15.height,

            CustomLabelFormField(context, 'Password',
                hint: 'Enter Password',
                controller: _passwordController,
                keyboardType: TextInputType.text,
                isRequired: true,
                obscureText: _obscureText ? true : false,
                suffixIcon: InkWell(
                  onTap: (){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon( _obscureText ? Icons.visibility_off : Icons.visibility,color: CustomColor.appColor,),)
            ),
            50.height,

            CustomButton(
              label: 'Sign In',
              onPressed: _signIn,
              isLoading: _isLoading,
            ),
            10.height,

            /// Forgot Password
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Forgot Password')),
                );
              },
              child: Text(
                'Forgot Password ?',
                style: TextStyle(color: CustomColor.appColor),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account ?'),
                TextButton(
                  onPressed: () {
                    widget.onToggle(true); // Go to SignUpScreen
                  },
                  child: Text('Sign Up', style: textStyle14(context, color: CustomColor.appColor),),
                ),
              ],
            ),
            20.height,
            
            
            Row(
              children: [
                Expanded(child: CustomContainer(padding: EdgeInsetsDirectional.symmetric(vertical: 0.5,), backgroundColor: CustomColor.appColor,)),
                Text('Or Continue with'),
                Expanded(child: CustomContainer(padding: EdgeInsetsDirectional.symmetric(vertical: 0.5,), backgroundColor: CustomColor.appColor,)),
              ],
            ),
            30.height,
            Row(
              spacing: 50,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(onTap: () => CustomAlertDialog(context,title: 'Alert!', content: 'Dear Franchise This Feature Is Not Valid', onConfirm: () {}, ),child: Image.asset(CustomIcon.googleIcon)),
                InkWell(onTap: () => CustomAlertDialog(context,title: 'Alert!', content: 'Dear Franchise This Feature Is Not Valid', onConfirm: () {}, ),child: Image.asset(CustomIcon.facebookIcon)),
                InkWell(onTap: () => CustomAlertDialog(context,title: 'Alert!', content: 'Dear Franchise This Feature Is Not Valid', onConfirm: () {}, ),child: Image.asset(CustomIcon.instagramIcon)),
              ],
            )

          ],
        ),
      ),
    );
  }
}
