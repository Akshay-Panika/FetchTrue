import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import 'id_card_screen.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'ID Card',
      'icon': Icons.verified,
      'screenBuilder': () => IDCardScreen(),
    },
    {
      'title': 'Certificate',
      'icon': Icons.lightbulb_outline,
      'screenBuilder': () => Scaffold(),
    },
    {
      'title': 'Appointment Letter',
      'icon': Icons.wifi,
      'screenBuilder': () => Scaffold(),
    },
    {
      'title': 'Franchise',
      'icon': Icons.video_library,
      'screenBuilder': () => Scaffold(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Document', showBackButton: true,),

      body: SafeArea(
        child: Column(
          children: [
            10.height,
        
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              padding: EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.11 / 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final item = _services[index];
        
                return CustomContainer(
                  border: true,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    final screenBuilder = item['screenBuilder'] as Widget Function();
                    if (screenBuilder != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => screenBuilder()),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomContainer(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            item['icon'],
                            size: 30,
                            color: CustomColor.appColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          item['title'],
                          style: textStyle12(context, color: CustomColor.appColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        
        
            Expanded(child: CustomContainer(
              border: true,
              backgroundColor: CustomColor.whiteColor,
            ))
          ],
        ),
      ),
    );
  }
}
