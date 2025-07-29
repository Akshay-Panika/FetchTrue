import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../../auth/repository/user_service.dart';
import '../model/user_model.dart';
import '../../my_lead/widget/leads_details_widget.dart';
import '../repository/user_additional_details_service.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  final String user;
  const AdditionalDetailsScreen({super.key, required this.user});

  @override
  State<AdditionalDetailsScreen> createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();

  String? gender;
  String? maritalStatus;
  String? bloodGroup;

  final ValueNotifier<String> selectedBloodGroups = ValueNotifier('');
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  UserModel? _user; // ✅ fetched user data

  @override
  void initState() {
    super.initState();
    fetchUser();
  }
  bool isSaving = false;

  Future<void> fetchUser() async {
    try {
      final user = await UserService().fetchUserById(widget.user);
      _user = user;
      populateFields(user!);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  void populateFields(UserModel user) {
    gender = user.gender?.capitalize();
    maritalStatus = user.maritalStatus?.capitalize();

    final blood = user.bloodGroup?.toUpperCase() ?? '';
    selectedBloodGroups.value = bloodGroups.contains(blood) ? blood : '';

    if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
      try {
        final date = DateTime.parse(user.dateOfBirth!);
        dobController.text =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      } catch (_) {
        dobController.text = '';
      }
    }

    educationController.text = user.education ?? '';
    professionController.text = user.profession ?? '';
    emergencyContactController.text = user.emergencyContact ?? '';
  }


  @override
  void dispose() {
    dobController.dispose();
    educationController.dispose();
    professionController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return  Scaffold(
        appBar: CustomAppBar(title: 'Additional Details', showBackButton: true,),
        body: Center(child: CircularProgressIndicator(color: CustomColor.appColor,)),
      );
    }

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
                    activeColor: CustomColor.appColor,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  const Text("Male"),
                  15.width,

                  Radio<String>(
                    value: "Female",
                    groupValue: gender,
                    activeColor: CustomColor.appColor,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  const Text("Female"),
                  15.width,

                  Radio<String>(
                    value: "Other",
                    groupValue: gender,
                    activeColor: CustomColor.appColor,
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
                    activeColor: CustomColor.appColor,
                    onChanged: (value) => setState(() => maritalStatus = value),
                  ),
                  const Text("Single"),
                  15.width,

                  Radio<String>(
                    value: "Married",
                    activeColor: CustomColor.appColor,
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

              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus(); // hide keyboard

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    setState(() {
                      dobController.text = formattedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomLabelFormField(
                    context,
                    'DOB',
                    controller: dobController,
                    hint: 'Select Date of Birth',
                    keyboardType: TextInputType.none,
                    isRequired: true,
                  ),
                ),
              ),

              15.height,

              CustomLabelFormField(
                context,
                'Education',
                hint: 'Enter here...',
                controller: educationController,
                keyboardType: TextInputType.text,
                isRequired: true,
              ),
              15.height,

              CustomLabelFormField(
                context,
                'professional',
                hint: 'Enter here...',
                controller: professionController,
                keyboardType: TextInputType.text,
                isRequired: true,
              ),
              15.height,

              CustomLabelFormField(
                context,
                'Emergency Contact',
                hint: 'Enter here...',
                controller: emergencyContactController,
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
                        child: Center(
                          child: isSaving
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: CustomColor.appColor,
                            ),
                          )
                              : Text("SAVE", style: textStyle16(context)),
                        ),

                        // onTap: () async {
                        //   if (_formKey.currentState!.validate()) {
                        //     setState(() => isSaving = true); // Start loading
                        //
                        //     final Map<String, dynamic> data = {
                        //       "gender": gender?.toLowerCase(),
                        //       "maritalStatus": maritalStatus?.toLowerCase(),
                        //       "bloodGroup": selectedBloodGroups.value.toLowerCase(),
                        //       "dateOfBirth": dobController.text.trim(),
                        //       "education": educationController.text.trim(),
                        //       "profession": professionController.text.trim(),
                        //       "emergencyContact": emergencyContactController.text.trim(),
                        //     };
                        //
                        //     try {
                        //       await UserAdditionalDetailsService().updateAdditionalDetails(
                        //         userId: widget.user,
                        //         data: data,
                        //       );
                        //
                        //       showCustomSnackBar(context, 'Details updated successfully');
                        //
                        //       Navigator.pop(context);
                        //     } catch (e) {
                        //       showCustomSnackBar(context, 'Error: $e');
                        //
                        //     } finally {
                        //       if (mounted) setState(() => isSaving = false); // Stop loading
                        //     }
                        //   }
                        // }

                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            // Extra manual validations
                            if (gender == null || gender!.isEmpty) {
                              showCustomSnackBar(context, 'Please select gender');
                              return;
                            }

                            if (maritalStatus == null || maritalStatus!.isEmpty) {
                              showCustomSnackBar(context, 'Please select marital status');
                              return;
                            }

                            if (selectedBloodGroups.value.isEmpty) {
                              showCustomSnackBar(context, 'Please select blood group');
                              return;
                            }

                            if (dobController.text.isEmpty) {
                              showCustomSnackBar(context, 'Please enter date of birth');
                              return;
                            }

                            if (educationController.text.trim().isEmpty) {
                              showCustomSnackBar(context, 'Please enter education details');
                              return;
                            }

                            if (professionController.text.trim().isEmpty) {
                              showCustomSnackBar(context, 'Please enter profession');
                              return;
                            }

                            if (emergencyContactController.text.trim().length != 10 ||
                                !RegExp(r'^\d+$').hasMatch(emergencyContactController.text.trim())) {
                              showCustomSnackBar(context, 'Please enter valid 10-digit emergency contact number');
                              return;
                            }

                            setState(() => isSaving = true); // Start loading

                            final Map<String, dynamic> data = {
                              "gender": gender?.toLowerCase(),
                              "maritalStatus": maritalStatus?.toLowerCase(),
                              "bloodGroup": selectedBloodGroups.value.toLowerCase(),
                              "dateOfBirth": dobController.text.trim(),
                              "education": educationController.text.trim(),
                              "profession": professionController.text.trim(),
                              "emergencyContact": emergencyContactController.text.trim(),
                            };

                            try {
                              await UserAdditionalDetailsService().updateAdditionalDetails(
                                userId: widget.user,
                                data: data,
                              );

                              showCustomSnackBar(context, 'Details updated successfully');
                              Navigator.pop(context);
                            } catch (e) {
                              showCustomSnackBar(context, 'Error: $e');
                            } finally {
                              if (mounted) setState(() => isSaving = false); // Stop loading
                            }
                          }
                        }


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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
