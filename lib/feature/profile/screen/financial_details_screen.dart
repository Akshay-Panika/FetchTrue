import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_text_tield.dart';

class FinancialDetailsScreen extends StatelessWidget {
  FinancialDetailsScreen({super.key});

  final TextEditingController annualIncomeController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  final ValueNotifier<String> selectedIncomeType = ValueNotifier('');

  final List<String> incomeTypes = [
    'Salaried',
    'Self-Employed',
    'Business',
    'Freelancer',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Financial Details', showBackButton: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔽 Income Type Dropdown
            CustomDropdownField(
              headline:'Income Type',
              label: 'Select your income type',
              items: incomeTypes,
              selectedValue: selectedIncomeType,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            /// 💰 Annual Income
            CustomLabelFormField(
              context,
              'Annual Income',
              hint: 'Enter your annual income',
              controller: annualIncomeController,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            /// 🧾 PAN Number
            CustomLabelFormField(
              context,
              'PAN Number',
              hint: 'Enter your PAN number',
              controller: panController,
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            /// 🏦 Bank Name
            CustomLabelFormField(
              context,
              'Bank Name',
              hint: 'Enter your bank name',
              controller: bankNameController,
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            /// 🔢 Account Number
            CustomLabelFormField(
              context,
              'Account Number',
              hint: 'Enter your account number',
              controller: accountNumberController,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            /// 🏷️ IFSC Code
            CustomLabelFormField(
              context,
              'IFSC Code',
              hint: 'Enter IFSC code',
              controller: ifscController,
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }
}
