import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

//se crea como static para no importar la instancia de la clase
class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon:
          prefixIcon != null ? Icon(prefixIcon, color: MyColors.primaryColor) : null,
    );
  }
}
