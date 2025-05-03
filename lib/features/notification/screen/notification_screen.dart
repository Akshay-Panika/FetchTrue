import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int? _selectedServiceIndex; // nullable index

  final List<String> _services = [
    'Onboarding',
    'Business',
    'Branding & Marketing',
    'Legal Services',
    'Home Services',
    'IT Services',
    'Education',
    'Finance Services',
    'Franchise',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _selectedServiceIndex = null;
        });
        return true; // allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Appbar')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectedServiceIndex != null ? Center(
              child: Text(
                _services[_selectedServiceIndex!],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.11 / 1,
              ),
              itemBuilder: (context, index) {
                return CustomContainer(
                  onTap: () {
                    setState(() {
                      _selectedServiceIndex = index;
                    });
                  },
                  padding: EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomContainer(
                          margin: EdgeInsets.all(0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          _services[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
