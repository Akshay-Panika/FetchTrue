import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewSubmitDetailsScreen extends StatefulWidget {
  const NewSubmitDetailsScreen({super.key});

  @override
  State<NewSubmitDetailsScreen> createState() => _NewSubmitDetailsScreenState();
}

class _NewSubmitDetailsScreenState extends State<NewSubmitDetailsScreen> {

  int _selectLocation = 0;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Customer Details', showBackButton: true,),

      body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            _formField(context,"Name", isRequired: true, hint: 'Enter Name...',),
            10.height,

            _formField(context,"Phone", isRequired: true,hint: 'Enter Phone No...'),
            15.height,

            CustomContainer(
              border: true,
              margin: EdgeInsets.zero,
              height: dimensions.screenHeight*0.17,
              backgroundColor: CustomColor.greenColor.withOpacity(0.1),
            ),
            15.height,

            RichText(
              text: TextSpan(
                text: 'Location',
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                ]
              ),
            ),
            5.height,

            Row(
              children: [
                _buildLocationCard(
                    onTap: () {
                      setState(() {
                        _selectLocation = 0;
                      });
                    },
                    context, label: 'Home', icon: Icons.home, color: _selectLocation == 0 ? CustomColor.appColor : null),
                10.width,
                _buildLocationCard(
                    onTap: () {
                      setState(() {
                        _selectLocation = 1;
                      });
                    },
                    context, label: 'Office', icon: Icons.shopping_bag, color: _selectLocation == 1 ? CustomColor.appColor : null),
                10.width,

                _buildLocationCard(
                    onTap: () {
                      setState(() {
                        _selectLocation = 2;
                      });
                    },
                    context, label: 'Other', icon: Icons.location_on, color: _selectLocation == 2 ? CustomColor.appColor : null),

              ],
            ),
            15.height,

            _formField(context,"Address", isRequired: true,hint: 'Enter Service Address...'),
            10.height,

            Row(
              children: [
                Expanded(child: _formField(context,"House", isRequired: true,hint: 'House No...')),
                10.width,
                Expanded(child: _formField(context,"City", isRequired: true, hint: 'Enter City...')),
              ],
            ),
            10.height,

            Row(
              children: [
                Expanded(child: _formField(context,"Status", isRequired: true, hint: 'Enter Status...')),
                10.width,
                Expanded(child: _formField(context,"Country", isRequired: true, hint: 'India', enabled: false)),
              ],
            ),
            SizedBox(height: dimensions.screenHeight*0.04,),

            CustomButton(text: 'Save Data',)
          ],
        ),
      )),
    );
  }

  Widget _formField(
      BuildContext context,
      String label,
      {
        bool isRequired = false,
        String? initialValue,
        bool enabled = true,
        int maxLines = 1,
        String? hint,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            children: isRequired
                ? const [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                : [],
          ),
        ),
        5.height,
        TextFormField(
          initialValue: initialValue,
          enabled: enabled,
          maxLines: maxLines,
          style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
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
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

Widget _buildLocationCard(BuildContext context,{
  VoidCallback? onTap,
  IconData? icon, String? label, Color? color}){
  return Expanded(
    child: CustomContainer(
      border: true,
      onTap: onTap ,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color ?? CustomColor.descriptionColor, size: 16,),
          5.width,
          Text(label!, style: textStyle12(context, color: color ?? CustomColor.descriptionColor),)
        ],
      ),
    ),
  );
}
