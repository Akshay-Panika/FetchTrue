import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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


                  Center(child: Image.asset(CustomLogo.fetchTrueLogo,height: 100,)),

                  CustomFormField(context, 'Full name',
                      hint: 'Enter full name',
                      controller: _fullNameController,
                      keyboardType: TextInputType.text,
                      isRequired: true),
                  15.height,

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Phone',
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children:  [
                            TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                        ),
                      ),
                      5.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                            Container(
                            height: 48,width: 50,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade300)
                            ),
                            child: Center(child: Text('+ 91', style: TextStyle(color: CustomColor.appColor,fontWeight: FontWeight.w500),)),
                          ),
                          10.width,
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                hintStyle: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
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
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              validator: (value) => null,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
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
                      Text('Already have an account ?'),
                      TextButton(
                        onPressed: () {
                          widget.onToggle(false); // Go back to SignInScreen
                        },
                        child: Text('Sign In', style: textStyle14(context, color: CustomColor.appColor)),
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

