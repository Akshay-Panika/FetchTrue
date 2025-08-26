import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:fetchtrue/feature/customer/repository/customer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../model/add_customer_model.dart';

class AddCustomerScreen extends StatefulWidget {
  final String userId;
  const AddCustomerScreen({super.key, required this.userId});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {

  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final description = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController();

  final ValueNotifier<String> selectedState = ValueNotifier('');
  final ValueNotifier<String> selectedCity = ValueNotifier('');
  final ValueNotifier<List<String>> cityList = ValueNotifier([]);

  final Map<String, List<String>> stateCityMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Rajkot'],
  };


  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    country.text = 'India';
    selectedState.addListener(() {
      cityList.value = stateCityMap[selectedState.value] ?? [];
      selectedCity.value = '';
    });
  }

  void _submitForm() async {
    if (fullName.text.trim().isEmpty) {
      showCustomSnackBar(context, "Name is required");
      return;
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName.text.trim())) {
      showCustomSnackBar(context, "Please enter valid name");
      return;
    }

    if (phone.text.trim().isEmpty) {
      showCustomSnackBar(context, "Phone number is required");
      return;
    } else if (phone.text.trim().length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone.text.trim())) {
      showCustomSnackBar(context, "Enter a valid 10-digit phone number");
      return;
    }

    if (email.text.trim().isEmpty) {
      showCustomSnackBar(context, "Email is required");
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text.trim())) {
      showCustomSnackBar(context, "Enter a valid email address");
      return;
    }

    if (address.text.trim().isEmpty) {
      showCustomSnackBar(context, "Address is required");
      return;
    }

    if (selectedState.value.isEmpty) {
      showCustomSnackBar(context, "Please select a State");
      return;
    }

    if (selectedCity.value.isEmpty) {
      showCustomSnackBar(context, "Please select a City");
      return;
    }

    setState(() => _isLoading = true);

    final newCustomer = AddCustomerModel(
      fullName: fullName.text.trim(),
      phone: phone.text.trim(),
      email: email.text.trim(),
      description: description.text.trim(),
      address: address.text.trim(),
      city: selectedCity.value,
      state: selectedState.value,
      country: country.text.trim(),
      user: widget.userId,
    );

    try {
      final result = await CustomerRepository.createCustomer(newCustomer);

      if (result != null) {
        showCustomSnackBar(context, "Customer Created: ${result.fullName}");

        Navigator.pop(context, {
          "_id": result.id,
          "userId": result.user,
          "fullName": result.fullName,
          "phone": result.phone,
          "message": result.description,
        });

      } else {
        showCustomSnackBar(context, "Failed to create customer");
      }
    } catch (e) {
      showCustomSnackBar(context, "Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    fullName.dispose();
    phone.dispose();
    email.dispose();
    address.dispose();
    country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Customer Details', showBackButton: true,),

      body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,
              CustomLabelFormField(context, "Name", isRequired: true,
                  hint: 'Enter Name...',
                  controller: fullName,
                  keyboardType: TextInputType.text),
              10.height,

              CustomLabelFormField(context, "Phone", isRequired: true,
                  hint: 'Enter Phone No...',
                  controller: phone,
                  keyboardType: TextInputType.number),
              15.height,

              CustomLabelFormField(context, "Email", isRequired: true,
                hint: 'Enter Email Id...',
                controller: email,
                keyboardType: TextInputType.text,),
              15.height,

              CustomDescriptionField(context,
                "Description (Optional)",
                controller: description,
                isRequired: false,
                hint: "Enter full details here...",
              ),
              15.height,

              CustomLabelFormField(context, "Address", isRequired: true,
                  hint: 'Enter Service Address...',
                  controller: address,
                  keyboardType: TextInputType.text),
              10.height,

              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      headline: "State",
                      label: "Select State",
                      items: stateCityMap.keys.toList(),
                      selectedValue: selectedState,
                    ),
                  ),
                  10.width,

                  Expanded(
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: cityList,
                      builder: (context, cities, _) {
                        return CustomDropdownField(
                          headline: "City",
                          label: "Select City",
                          items: cities,
                          selectedValue: selectedCity,
                        );
                      },
                    ),
                  )
                ],
              ),
              10.height,

              CustomLabelFormField(context, "Country", isRequired: true,
                  hint: 'India',
                  enabled: false,
                  controller: country,
                  keyboardType: TextInputType.text),
              SizedBox(height: dimensions.screenHeight * 0.04,),

              CustomButton(
                label: 'Save Data',
                isLoading: _isLoading,
                onPressed: _submitForm,
              )
            ],
          ),
        ),
      )),
    );
  }
}
