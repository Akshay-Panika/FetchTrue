import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/customer/customer_bloc.dart';
import '../bloc/customer/customer_event.dart';
import '../bloc/customer/customer_state.dart';
import '../repository/customer_service.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

   int? _selectedCustomer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Customer List', showBackButton: true, showSearchIcon: true,),

      body:BlocProvider(
        create: (_) => CustomerBloc(CustomerService())..add(GetCustomer()),
        child:  BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            }

            else if(state is CustomerLoaded){

              final customer = state.customerModel;

              if (customer.isEmpty) {
                return const Center(child: Text('No Category found.'));
              }


              return  Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: customer.length,
                  itemBuilder: (context, index) {
                      final data = customer[index];
                    return CustomContainer(
                      backgroundColor: CustomColor.whiteColor,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child:Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,    // disables ripple
                          highlightColor: Colors.transparent, // disables highlight
                        ),
                        child: ExpansionTile(
                          // initiallyExpanded: true,
                          backgroundColor: CustomColor.whiteColor,
                          iconColor: CustomColor.appColor,
                          shape: InputBorder.none,
                          childrenPadding: EdgeInsets.zero,
                          collapsedShape: InputBorder.none,
                          leading: CircleAvatar(backgroundImage: AssetImage(CustomImage.nullImage),),
                          title: Text(data.fullName, style: textStyle14(context),),
                          subtitle: Text('FT ID: ${data.customerId}', style: textStyle12(context, color: CustomColor.descriptionColor),),
                          children: [
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Phone: ${data.phone}'),
                                    Text('Email: ${data.email}'),
                                    Text('Address: Address ${data.address}'),
                                  ],
                                ),

                                Checkbox(
                                  activeColor: CustomColor.appColor,
                                  value: _selectedCustomer == index,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCustomer = value! ? index : null;

                                      if (value) {
                                        final selectedCustomerData = {
                                          '_id': data.id,
                                          'userId': data.userId,
                                          'fullName': data.fullName,
                                          'phone': data.phone,
                                        };
                                        Navigator.pop(context, selectedCustomerData);
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );

            }

            else if (state is CustomerError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),

    );
  }
}
