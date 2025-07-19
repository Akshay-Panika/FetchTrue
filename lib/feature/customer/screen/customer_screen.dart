import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../helper/Contact_helper.dart';
import '../bloc/customer/customer_bloc.dart';
import '../bloc/customer/customer_event.dart';
import '../bloc/customer/customer_state.dart';
import '../repository/customer_service.dart';

class CustomerScreen extends StatefulWidget {
  final bool? isMenu;
  final String userId;
  const CustomerScreen({super.key, this.isMenu, required this.userId});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<TextEditingController> _messageControllers = [];
  int? _selectedCustomer;

  @override
  void dispose() {
    for (var controller in _messageControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Customer List',
        showBackButton: true,

      ),
      body: SafeArea(
        child: BlocProvider(
          create: (_) =>
          CustomerBloc(CustomerService())..add(GetCustomer()),
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return LinearProgressIndicator(
                  backgroundColor: CustomColor.appColor,
                  color: CustomColor.whiteColor,
                  minHeight: 2.5,
                );
              } else if (state is CustomerLoaded) {
                // final customer = state.customerModel;
                final customer = state.customerModel.where((customerId) =>
                customerId.userId == widget.userId).toList();

                // Initialize _messageControllers safely
                if (_messageControllers.length != customer.length) {
                  _messageControllers = List.generate(
                    customer.length, (index) => TextEditingController(),
                  );
                }

                if (customer.isEmpty) {
                  return  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 35,backgroundImage: AssetImage(CustomImage.nullImage),),
                      20.height,
                      Text('No Customer found.', style: textStyle14(context, color: CustomColor.descriptionColor),),
                    ],
                  ));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: customer.length,
                  itemBuilder: (context, index) {
                    final data = customer[index];
                    return CustomContainer(
                      backgroundColor: CustomColor.whiteColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                     CircleAvatar(
                                      backgroundImage:
                                      AssetImage(CustomImage.nullImage),
                                    ),
                                    10.width,
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(data.fullName,
                                            style: textStyle14(context)),
                                        Text('FT ID: ${data.customerId}',
                                            style: textStyle12(context,
                                                color: CustomColor
                                                    .descriptionColor)),
                                      ],
                                    ),
                                  ],
                                ),

                                widget.isMenu == true ? SizedBox.shrink():
                                Checkbox(
                                  activeColor: CustomColor.appColor,
                                  value: _selectedCustomer == index,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCustomer =
                                      value! ? index : null;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Phone: ${data.phone}'),
                                      Text('Email: ${data.email}'),
                                      Text('Address: ${data.address}'),
                                    ],
                                  ),
                                ),
                                CustomContainer(
                                  margin: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Row(
                                    children: [
                                       Icon(Icons.call,
                                          size: 16,
                                          color: CustomColor.appColor),
                                      5.width,
                                      Text('Call Now',
                                          style: textStyle14(context,
                                              color: CustomColor.appColor)),
                                    ],
                                  ),
                                  onTap: () {
                                    ContactHelper.call(data.phone);
                                  },
                                )
                              ],
                            ),
                            15.height,

                            widget.isMenu == true ? SizedBox.shrink():
                            chatInputField(
                              context,
                              controller: _messageControllers[index],
                              onSend: () {
                                final message = _messageControllers[index].text.trim();

                                if (_selectedCustomer != null) {
                                  final selectedCustomer = customer[_selectedCustomer!];
                                  final selectedCustomerData = {
                                    '_id': selectedCustomer.id,
                                    'userId': selectedCustomer.userId,
                                    'fullName': selectedCustomer.fullName,
                                    'phone': selectedCustomer.phone,
                                    'message': message,
                                  };
                                  Navigator.pop(context, selectedCustomerData);
                                } else {
                                  showCustomSnackBar(context, 'Please select a customer.');
                                }
                              },
                              enabled: _selectedCustomer == index, /// Only selected row is active
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is CustomerError) {
                return Center(child: Text(state.errorMessage));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

Widget chatInputField(
    BuildContext context, {
      required TextEditingController controller,
      required VoidCallback onSend,
      required bool enabled,
    }) {
  return Row(
    children: [
      Expanded(
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: null,
          style: textStyle14(
            context,
            color: enabled ? CustomColor.descriptionColor : Colors.grey, // Optional faded text
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Notes for your query',
            hintStyle: textStyle14(
              context,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
      20.width,
      CustomContainer(
        border: true,
        margin: EdgeInsets.zero,
        backgroundColor: enabled ? CustomColor.appColor : Colors.transparent,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        onTap: enabled ? onSend : null,
        child: Center(
          child: Text(
            'Add Now',
            style: textStyle14(
              context,
              color: enabled ? Colors.white : Colors.black45,
            ),
          ),
        ),
      )
    ],
  );
}
