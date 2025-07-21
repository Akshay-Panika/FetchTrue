import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../more/model/user_model.dart';

class UpdateInfoScreen extends StatelessWidget {
  final UserModel user;
  const UpdateInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Update Info', showBackButton: true,),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 15,
          children: [
            CustomLabelFormField(context, 'Name', hint: 'Update Name', keyboardType: TextInputType.text),
            CustomLabelFormField(context, 'Phone', hint: 'Update Phone Number', keyboardType: TextInputType.text),
            CustomLabelFormField(context, 'Email Id', hint: 'Update Email Id', keyboardType: TextInputType.text),

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
    );
  }
}
