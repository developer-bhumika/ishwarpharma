import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final Color? hintTextColor;
  final FontWeight? hintTextFontWeight;
  final double? hintTextFontSize;
  final bool? obSecureText;
  final TextInputType? keyBoardType;
  final String? labelText;
  final bool? readOnly;
  final bool? isDense;
  void Function()? onTap;
  final double? radius;
  final void Function(String)? onChange;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  // ignore: use_key_in_widget_constructors
  CommonTextField({
    this.controller,
    this.hintText,
    this.maxLines,
    this.hintTextColor,
    this.hintTextFontSize,
    this.hintTextFontWeight,
    this.keyBoardType,
    this.obSecureText,
    this.labelText,
    this.readOnly,
    this.isDense,
    this.onTap,
    this.radius,
    this.onChange,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? CommonText(
                text: labelText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.dartFontColor,
              )
            : const SizedBox(),
        labelText != null ? const SizedBox(height: 5) : const SizedBox(),
        TextFormField(
          cursorColor: AppColor.primaryColor,
          maxLines: maxLines ?? 1,
          keyboardType: keyBoardType ?? TextInputType.text,
          obscureText: obSecureText ?? false,
          readOnly: readOnly ?? false,
          onTap: readOnly ?? false ? onTap : null,
          inputFormatters: inputFormatters,
          onChanged: onChange,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColor.black),
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon ?? const SizedBox(),
            isDense: isDense,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.borderColorProduct),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.borderColorProduct),
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.borderColorProduct),
              borderRadius: BorderRadius.circular(6),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.borderColorProduct),
              borderRadius: BorderRadius.circular(6),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.borderColorProduct),
              borderRadius: BorderRadius.circular(6),
            ),
            hintText: hintText,
            filled: true,
            fillColor: AppColor.lightGreen,
            hintStyle: TextStyle(
              color: hintTextColor ?? AppColor.black.withOpacity(0.70),
              fontWeight: hintTextFontWeight ?? FontWeight.w400,
              fontSize: hintTextFontSize ?? 14,
            ),
          ),
        ),
      ],
    );
  }
}
