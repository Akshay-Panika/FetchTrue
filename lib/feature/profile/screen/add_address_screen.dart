import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../model/address_model.dart';
import '../repository/address_service.dart';


class AddAddressScreen extends StatefulWidget {
  final String userId;
  const AddAddressScreen({super.key, required this.userId});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final int tagCount = 3;
  int selectedIndex = 0;

  bool isLoading = false;

  final Map<String, String> displayLabels = {
    'homeAddress': 'Home',
    'workAddress': 'Work',
    'otherAddress': 'Other',
  };
  final List<String> labels = ['homeAddress', 'workAddress', 'otherAddress'];
  final List<IconData> icons = [Icons.home, Icons.work, Icons.location_pin];

  final ValueNotifier<String> selectedState = ValueNotifier('');
  final ValueNotifier<String> selectedCity = ValueNotifier('');
  final ValueNotifier<List<String>> cityList = ValueNotifier([]);

  final Map<String, List<String>> stateCityMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Rajkot'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi'],
  };

  @override
  void initState() {
    super.initState();
    countryController.text = 'India';

    selectedState.addListener(() {
      cityList.value = stateCityMap[selectedState.value] ?? [];
      selectedCity.value = '';
    });
  }

  @override
  void dispose() {
    houseNumberController.dispose();
    landmarkController.dispose();
    fullAddressController.dispose();
    pinCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    final model = AddressModel(
      addressType: labels[selectedIndex],
      address: Address(
        houseNumber: houseNumberController.text.trim(),
        landmark: landmarkController.text.trim(),
        state: selectedState.value,
        city: selectedCity.value,
        pinCode: pinCodeController.text.trim(),
        country: countryController.text.trim(),
        fullAddress: fullAddressController.text.trim(),
      ),
    );

    // Validation
    if (model.address.houseNumber.isEmpty ||
        model.address.landmark.isEmpty ||
        model.address.fullAddress.isEmpty ||
        model.address.state.isEmpty ||
        model.address.city.isEmpty ||
        model.address.pinCode.isEmpty) {
      setState(() => isLoading = false);

      showCustomSnackBar(context, 'Please fill all required fields');
      return;
    }

    final success = await AddressService.updateUserAddress(widget.userId, model);

    setState(() => isLoading = false);

    if (success) {
      showCustomSnackBar(context, 'Address updated successfully!');
      Navigator.pop(context, true);
    } else {
      showCustomSnackBar(context, 'Failed to update address.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: const CustomAppBar(title: 'Add Address', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomLabelFormField(
                      context,
                      'House/Flat/Floor Number',
                      controller: houseNumberController,
                      hint: 'Enter here...',
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomLabelFormField(
                      context,
                      'Landmark',
                      controller: landmarkController,
                      hint: 'Enter here...',
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              15.height,
              CustomLabelFormField(
                context,
                'Complete Address',
                controller: fullAddressController,
                hint: 'Enter here...',
                keyboardType: TextInputType.text,
                isRequired: true,
              ),
              15.height,
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
              15.height,
              Row(
                children: [
                  Expanded(
                    child: CustomLabelFormField(
                      context,
                      'Pin Code',
                      controller: pinCodeController,
                      hint: 'Enter here...',
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomLabelFormField(
                      context,
                      "Country",
                      controller: countryController,
                      isRequired: true,
                      hint: 'India',
                      enabled: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              25.height,
              Text('Save As', style: textStyle16(context)),
              10.height,
              Row(
                children: List.generate(
                  labels.length,
                      (index) {
                    final labelKey = labels[index];

                    // Filter only Home, Work, Other
                    if (!displayLabels.containsKey(labelKey)) return const SizedBox.shrink();

                    return CustomContainer(
                      border: true,
                      color: CustomColor.whiteColor,
                      borderColor: selectedIndex == index
                          ? CustomColor.appColor
                          : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      margin: const EdgeInsets.only(right: 10),
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            icons[index],
                            color: selectedIndex == index
                                ? CustomColor.appColor
                                : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            displayLabels[labelKey]!,
                            style: textStyle14(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              50.height,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomContainer(
                      border: true,
                      borderColor: CustomColor.appColor,
                      color: CustomColor.whiteColor,
                      onTap: isLoading ? null : _handleSave,
                      child: Center(
                        child: isLoading
                            ?  SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: CustomColor.appColor,),
                        )
                            : Text("SAVE", style: textStyle16(context)),
                      ),
                    ),
                  ),
                ],
              ),
              10.height,
            ],
          ),
        ),
      ),
    );
  }
}
