import 'package:flutter/material.dart';

class FavoriteProviderButtonWidget extends StatefulWidget {
  final String providerId;

  const FavoriteProviderButtonWidget({
    super.key,
    required this.providerId,
  });

  @override
  State<FavoriteProviderButtonWidget> createState() => _FavoriteProviderButtonWidgetState();
}

class _FavoriteProviderButtonWidgetState extends State<FavoriteProviderButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: IconButton(
        onPressed: () {

        },
        icon: Icon(
         Icons.favorite_border,
          color: Colors.red,
        ),
      ),
    );
  }
}
