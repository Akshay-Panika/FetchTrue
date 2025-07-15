import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdviserScreen extends StatelessWidget {
  const AdviserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final advisers = List.generate(10, (index) => {
      'name': 'Adviser ${index + 1}',
      'title': 'Senior Consultant',
      'bio': 'Experienced adviser with over 10+ years in strategic consulting and client management.',
      'image': 'https://i.pravatar.cc/150?img=${index + 10}'
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(title: 'Advisers', showBackButton: true),
      body: SafeArea(
        child: ListView.builder(
          itemCount: advisers.length,
          padding:EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final adviser = advisers[index];
            return AdviserCard(
              name: adviser['name']!,
              title: adviser['title']!,
              imageUrl: adviser['image']!,
              bio: adviser['bio']!,
            );
          },
        ),
      ),
    );
  }
}

class AdviserCard extends StatelessWidget {
  final String name;
  final String title;
  final String imageUrl;
  final String bio;

  const AdviserCard({
    super.key,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.bio,
  });

  void exportBio(BuildContext context) {
    Clipboard.setData(ClipboardData(text: bio));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bio copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backgroundColor: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          /// Row with image + name/title + actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              /// Name & Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              /// Call + Msg
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(onTap: () => null,child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,),),
                    30.width,

                    InkWell(onTap: () => null,child: Image.asset(CustomIcon.whatsappIcon, height: 25,),),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),

          /// Bio Text & Export
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    bio,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "Export Bio",
                  icon: const Icon(Icons.share_outlined, color: Colors.black54),
                  onPressed: () => exportBio(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
