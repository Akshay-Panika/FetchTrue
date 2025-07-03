import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../model/add_customer_model.dart';
import '../repository/add_customer_service.dart';

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
    if (_formKey.currentState!.validate()) {
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
        final result = await AddCustomerService.createCustomer(newCustomer);

        showCustomSnackBar(context, result != null
            ? "✅ Customer Created: ${result.fullName}"
            : "❌ Failed to create customer");

      } catch (e) {

        showCustomSnackBar(context,"❌ Error: ${e.toString()}");
      } finally {
        setState(() => _isLoading = false); // ✅ Loader off
      }
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
              _formField(context,"Name", isRequired: true, hint: 'Enter Name...', controller: fullName),
              10.height,

              _formField(context,"Phone", isRequired: true,hint: 'Enter Phone No...', controller: phone,),
              15.height,

              _formField(context,"Email", isRequired: true,hint: 'Enter Email Id...', controller: email,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              15.height,

              Center(
                child: _descriptionField(context,
                  "Description (Optional)",
                  controller: description,
                  isRequired: false,
                  hint: "Enter full details here...",
                  onChanged: (val) {
                    // handle changes
                  },
                ),
              ),
              15.height,

              _formField(context,"Address", isRequired: true,hint: 'Enter Service Address...', controller: address),
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

              _formField(context,"Country", isRequired: true, hint: 'India', enabled: false, controller: country),
              SizedBox(height: dimensions.screenHeight*0.04,),

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

  Widget _formField(
      BuildContext context,
      String label,
      {
        required TextEditingController  controller,
        bool isRequired = false,
        bool enabled = true,
        int maxLines = 1,
        String? hint,
        String? Function(String?)? validator
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
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: hint,
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
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

Widget _descriptionField(
    BuildContext context,
    String label, {
      required TextEditingController  controller,
      bool isRequired = false,
      bool enabled = true,
      int maxLines = 5,
      String? hint,
      Function(String)? onChanged,
      String? Function(String?)? validator,
    }) {
  return Column(
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
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        style: textStyle14(
          context,
          color: CustomColor.descriptionColor,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint ?? 'Write a detailed description...',
          hintStyle: textStyle14(
            context,
            color: CustomColor.descriptionColor,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onChanged: onChanged,
        validator: validator ??
            (isRequired
                ? (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Description is required';
              }
              return null;
            }
                : null),
      ),
    ],
  );
}
