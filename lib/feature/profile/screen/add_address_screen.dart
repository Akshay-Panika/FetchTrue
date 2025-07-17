import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  int selectedIndex = 0;

  final List<String> labels = ['Home', 'Work', 'Other'];
  final List<IconData> icons = [Icons.home, Icons.work, Icons.location_pin];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Add Address', showBackButton: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabelFormField(context, 'House/Flat/Floor Number', hint: 'Enter here...', keyboardType: TextInputType.text, isRequired: true),
              15.height,
        
              CustomLabelFormField(context, 'Complete Address', hint: 'Enter here...', keyboardType: TextInputType.text, isRequired: true),
              15.height,
        
              CustomLabelFormField(context, 'Landmark (Optional)', hint: 'Enter here...', keyboardType: TextInputType.text, isRequired: false),
              25.height,
        
        
              Text('Save', style: textStyle16(context),),
              15.height,
        
              Row(
                children: List.generate(labels.length, (index) => CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(right: 10),
                  child: TextButton.icon(onPressed: () => null, label: Text(labels[index], style: textStyle14(context),), icon: Icon(icons[index], color: CustomColor.appColor,),),
                ),),
              ),
              const Spacer(),
              
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomContainer(
                      border: true,
                      borderColor: CustomColor.appColor,
                      backgroundColor: CustomColor.whiteColor,
                      onTap: () {},
                      child: Center(child:  Text("Save", style: textStyle16(context),)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
