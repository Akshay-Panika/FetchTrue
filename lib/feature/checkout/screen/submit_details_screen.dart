import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';

class SubmitDetailsScreen extends StatelessWidget {
  const SubmitDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Submit Details', showBackButton: true,),

      body: SingleChildScrollView(
        child: Column(
          children: [
            20.height,
            _sectionHeader(context,"Customer Details"),
            _sectionCard(
              children: [
                _formField("Name", isRequired: true,),
                _formField("Mobile No.", isRequired: true, ),
                _formField("Address", isRequired: true,  maxLines: 3, hint: "Requirements"),
              ],
            ),
            20.height,
            
            _sectionHeader(context,"Service Details"),
            _sectionCard(
              children: [
                _formField("Service Name", initialValue: "Amazon Merchant Onboarding", enabled: false, ),
                _formField("Module", initialValue: "Onboarding", enabled: false,),
              ],
            ),

            10.height,
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  '* indicates mandatory fields',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(
                onPressed: () => Navigator.pop(context),
                label: 'Proceed To Checkout',),
            )
            ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context,String title) {
    return CustomContainer(
      border: true,
      margin: EdgeInsets.zero,
      borderRadius: false,
      backgroundColor: Colors.white,
      child: Center(
        child: Text(title, style: textStyle14(context)),
      ),
    );
  }

  Widget _sectionCard({required List<Widget> children}) {
    return CustomContainer(
      border: true,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _formField(
      String label, {
        bool isRequired = false,
        String? initialValue,
        bool enabled = true,
        int maxLines = 1,
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: isRequired
                  ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
         5.height,
          TextFormField(
            initialValue: initialValue,
            enabled: enabled,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Colors.grey.shade400)
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)
              ),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)
              ),
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
