import 'package:fetchtrue/feature/refund_policy/model/refundpolicy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../repository/refundpolicy_service.dart';



class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({super.key});

  @override
  State<RefundPolicyScreen> createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen> {
  late Future<List<RefundPolicyModel>> _htmlFuture;

  @override
  void initState() {
    super.initState();
    _htmlFuture = RefundPolicyService().fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Refund Policy', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: FutureBuilder<List<RefundPolicyModel>>(
            future: _htmlFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final dataList = snapshot.data ?? [];

              return ListView.separated(
                itemCount: dataList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final policy = dataList[index];
                  return Html(data: policy.content);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
