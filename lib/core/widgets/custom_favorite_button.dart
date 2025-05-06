import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFavoriteButton extends StatelessWidget {
  const CustomFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 9,
            offset: Offset(0, 2), // नीचे की तरफ हल्का शैडो
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(Icons.favorite_border, color: Colors.red,),
      ),
    );
  }
}
