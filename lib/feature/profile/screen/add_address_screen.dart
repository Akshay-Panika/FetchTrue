import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import '../../../core/widgets/custom_dropdown_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _countryController = TextEditingController();
  final int tagCount = 3;
  int selectedIndex = 0;

  final List<String> labels = ['Home', 'Work', 'Other'];
  final List<IconData> icons = [Icons.home, Icons.work, Icons.location_pin];

  final ValueNotifier<String> selectedState = ValueNotifier('');
  final ValueNotifier<String> selectedCity = ValueNotifier('');
  final ValueNotifier<List<String>> cityList = ValueNotifier([]);

  final Map<String, List<String>> stateCityMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Rajkot'],
  };

  @override
  void initState() {
    super.initState();
    _countryController.text = 'India';

    selectedState.addListener(() {
      cityList.value = stateCityMap[selectedState.value] ?? [];
      selectedCity.value = '';
    });
  }

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
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
                      hint: 'Enter here...',
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                  ),
                  10.width,

                  Expanded(
                    child: CustomLabelFormField(
                      context,
                      "Country",
                      isRequired: true,
                      hint: 'India',
                      enabled: false,
                      controller: _countryController,
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
                  tagCount,
                      (index) => CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    borderColor: selectedIndex == index
                        ? CustomColor.appColor
                        : Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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
                        6.width,
                        Text(
                          labels[index],
                          style: textStyle14(context),
                        ),
                      ],
                    ),
                  ),
                ),
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
              10.height,
            ],
          ),
        ),
      ),
    );
  }
}
