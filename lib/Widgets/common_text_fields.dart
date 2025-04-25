import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:tasker/utils/extensions.dart';

class CommonTextFields extends StatelessWidget {
  const CommonTextFields({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.maxlines,
    this.suffixIcon,
    this.readOnly = false, 
    this.validator,
  });

  final String title;
  final String hintText;
  final TextEditingController? controller;
  final int? maxlines;
  final Widget? suffixIcon;
  final bool readOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge,
        ),
        const Gap(10),
        TextFormField(
          readOnly: readOnly,
          controller: controller,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          maxLines: maxlines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: suffixIcon,
          ),
          onChanged: (value) {},
          validator: validator
        )
      ],
    );
  }
}
