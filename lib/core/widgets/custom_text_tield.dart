import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';

import '../costants/text_style.dart';

Widget CustomFormField(
    BuildContext context,
    String label,
    {
      bool isRequired = false,
      bool enabled = true,
      int maxLines = 1,
      int? maxLength,
      String? hint,
      bool obscureText = false,
      required TextInputType  keyboardType,
      final TextEditingController? controller,
      String? Function(String?)? validator,
      VoidCallback? onTap
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: isRequired
              ? const [
            TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
              : [],
        ),
      ),
      5.height,
      TextFormField(
        onTap: onTap,
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        obscureText: obscureText,
        style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Colors.grey.shade300)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator: validator,
      ),
    ],
  );
}