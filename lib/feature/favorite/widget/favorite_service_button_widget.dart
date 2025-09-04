import 'package:flutter/material.dart';

class FavoriteServiceButtonWidget extends StatefulWidget {
  const FavoriteServiceButtonWidget({super.key});

  @override
  State<FavoriteServiceButtonWidget> createState() => _FavoriteServiceButtonWidgetState();
}

class _FavoriteServiceButtonWidgetState extends State<FavoriteServiceButtonWidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.white,
      ),
    );
  }
}
