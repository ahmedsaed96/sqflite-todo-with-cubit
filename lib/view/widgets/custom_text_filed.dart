import 'package:flutter/material.dart';

Widget customTextField({
  String? hintText,
  IconData? icon,
  TextEditingController? textEditingController,
  String? val,
  String? field,
  Function? onTap,
  bool? disableKeyBoard = false,
}) =>
    TextFormField(
      readOnly: disableKeyBoard!,
      controller: textEditingController,
      onTap: () => onTap!(),
      validator: (value) {
        if (val!.isEmpty) {
          return "$field must not be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: const OutlineInputBorder(),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
