// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';

typedef MyValidator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  String label;
  TextEditingController controller;
  TextInputType keyboardType;
  bool obscureText;
  MyValidator validator;
  Widget? suffixIcon;

  CustomTextFormField(
      {required this.label,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      required this.validator,
      this.suffixIcon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: label,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor)),
            suffixIcon: suffixIcon,
            errorMaxLines: 2 //el error at most 2 lines
            ),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
