import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';

class InputDecorationsPayment {
  static InputDecoration paymentInputDecoration({
    String hintText,
    String labelText,
    IconData prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: MyColors.primaryColor)
          : null,
    );
  }
}
