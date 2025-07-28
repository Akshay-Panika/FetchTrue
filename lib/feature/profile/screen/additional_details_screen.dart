import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_text_tield.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  const AdditionalDetailsScreen({super.key});

  @override
  State<AdditionalDetailsScreen> createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? gender;
  String? maritalStatus;
  String? nationality;
  String? bloodGroup;
  String? emergencyContact;
  String? panNumber;
  String? aadharNumber;

  final ValueNotifier<String> selectedBloodGroups = ValueNotifier('');
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Additional Details', showBackButton: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,

              Text("Gender", style: textStyle16(context)),
              Row(
                children: [
                  Radio<String>(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  const Text("Male"),
                  15.width,

                  Radio<String>(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  const Text("Female"),
                  15.width,

                  Radio<String>(
                    value: "Other",
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  const Text("Other"),
                ],
              ),
              15.height,

              Text("Marital Status", style: textStyle16(context)),
              Row(
                children: [
                  Radio<String>(
                    value: "Single",
                    groupValue: maritalStatus,
                    onChanged: (value) => setState(() => maritalStatus = value),
                  ),
                  const Text("Single"),
                  15.width,

                  Radio<String>(
                    value: "Married",
                    groupValue: maritalStatus,
                    onChanged: (value) => setState(() => maritalStatus = value),
                  ),
                  const Text("Married"),
                ],
              ),
              15.height,

              ValueListenableBuilder<String>(
                valueListenable: selectedBloodGroups,
                builder: (context, value, _) {
                  return CustomDropdownField(
                    headline: "Blood Group",
                    label: "Select Blood Group",
                    items: bloodGroups,
                    selectedValue: selectedBloodGroups,
                  );
                },
              ),
              15.height,

              CustomLabelFormField(
                context,
                'DOB',
                hint: 'Enter here...',
                keyboardType: TextInputType.text,
                isRequired: true,
              ),
              15.height,

              CustomLabelFormField(
                context,
                'Education',
                hint: 'Enter here...',
                keyboardType: TextInputType.text,
                isRequired: true,
              ),
              15.height,

              CustomLabelFormField(
                context,
                'professional',
                hint: 'Enter here...',
                keyboardType: TextInputType.text,
                isRequired: true,
              ),
              15.height,

              CustomLabelFormField(
                context,
                'Emergency Contact',
                hint: 'Enter here...',
                keyboardType: TextInputType.number,
                isRequired: true,
              ),
              50.height,

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CANCEL",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomContainer(
                      border: true,
                      borderColor: CustomColor.appColor,
                      backgroundColor: CustomColor.whiteColor,
                      onTap: () {},
                      child: Center(
                        child: Text("SAVE", style: textStyle16(context)),
                      ),
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
