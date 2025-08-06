import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/advisers/model/advisor_model.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';

import '../repojetory/advisor_service.dart';


class AdviserScreen extends StatefulWidget {
  const AdviserScreen({super.key});

  @override
  State<AdviserScreen> createState() => _AdviserScreenState();
}

class _AdviserScreenState extends State<AdviserScreen> {
  late Future<List<AdvisorModel>> advisorsFuture;

  @override
  void initState() {
    super.initState();
    advisorsFuture = AdvisorService().fetchAdvisors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(title: 'Advisers', showBackButton: true),
      body: SafeArea(
        child: FutureBuilder<List<AdvisorModel>>(
          future: advisorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No advisors available'));
            }

            final advisers = snapshot.data!;
            return ListView.builder(
              itemCount: advisers.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final adviser = advisers[index];
                return AdviserCard(
                  name: adviser.name,
                  imageUrl: adviser.imageUrl,
                  rating: adviser.rating.toInt(),
                  phoneNumber: adviser.phoneNumber,
                  description: adviser.chat,
                  language: adviser.language,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AdviserCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int rating;
  final int phoneNumber;
  final String language;
  final String description;
  const AdviserCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.phoneNumber,
    required this.language,
    required this.description,
  });


  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backgroundColor: Colors.white,
      margin:  EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile 
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              15.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: textStyle14(context,)),
                    Text(language, style: textStyle14(context,fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => ContactHelper.call(phoneNumber.toString()),
                      child: Image.asset(
                        CustomIcon.phoneIcon,
                        height: 25,
                        color: CustomColor.appColor,
                      ),
                    ),
                   50.width,
                    InkWell(
                      onTap: () => ContactHelper.whatsapp(phoneNumber.toString(), 'Hello!'),
                      child: Image.asset(
                        CustomIcon.whatsappIcon,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(color: Colors.grey.shade300),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Description\n$description',style: textStyle14(context, fontWeight: FontWeight.w400),),
              ),
              IconButton(
                tooltip: "Export Bio",
                icon: const Icon(Icons.share_outlined, color: Colors.black54),
                onPressed: () => null
              ),
            ],
          ),
        ],
      ),
    );
  }
}
