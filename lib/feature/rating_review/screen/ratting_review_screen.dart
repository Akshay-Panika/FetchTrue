import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class RatingReviewScreen extends StatefulWidget {
  const RatingReviewScreen({super.key});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  int deliveryRating = 0;
  int productRating = 0;
  String productReview = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ratings and Reviews',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🚚 Delivery Rating Card
                CustomContainer(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Left Text Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "How was your service provider experience?",
                              style: textStyle16(context),
                            ),
                            5.height,
                            const Text(
                              "with Ganesh",
                              style: TextStyle(color: Colors.grey),
                            ),
                            12.height,
                            /// ⭐ Compact Rating Row for Delivery
                            Row(
                              children: List.generate(
                                5,
                                    (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      deliveryRating = index + 1;
                                    });
                                  },
                                  child: Icon(
                                    Icons.star,
                                    size: 22,
                                    color: index < deliveryRating ? Colors.amber : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      /// Right Image
                      Image.asset(CustomImage.nullImage, height: 50),
                    ],
                  ),
                ),

                /// 🛒 Product Review Section
                 Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "Please tell us about service in your order",
                    style: TextStyle(color: CustomColor.descriptionColor),
                  ),
                ),

                CustomContainer(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Product Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomContainer(
                              margin: EdgeInsets.zero,
                              assetsImg: CustomImage.thumbnailImage,
                              height: 100,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  'Toyshine 4-Strings Acoustic Guitar...',
                                  style: textStyle16(context),
                                  overflow: TextOverflow.clip,
                                ),
                                10.height,
                                /// ⭐ Compact Rating Row for Product
                                Row(
                                  children: List.generate(
                                    5,
                                        (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          productRating = index + 1;
                                        });
                                      },
                                      child: Icon(
                                        Icons.star,
                                        size: 22,
                                        color: index < productRating ? Colors.amber : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      15.height,

                      /// Feedback Text Field
                      TextField(
                        maxLines: 4,
                        onChanged: (value) {
                          setState(() {
                            productReview = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Tell us about your experience",
                          hintStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.height,


            /// ✅ Submit Button
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(
                label: 'Submit',
                onPressed: () {
                  // 👇 Handle submission logic
                  print("Delivery Rating: $deliveryRating");
                  print("Product Rating: $productRating");
                  print("Review: $productReview");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Review submitted successfully!"),
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
