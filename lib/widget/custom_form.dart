// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final String hinttext;
  final double height;
  final RegExp validationsRegx;
  final bool obsecuretext;
  final void Function(String?) onsaved;
  const CustomForm({
    super.key,
    required this.hinttext,
    required this.height, 
    required this.validationsRegx,
    this.obsecuretext = false,
    required this.onsaved
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onsaved,
        obscureText: obsecuretext,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: hinttext),
            validator: (value){
              if(value!=null && validationsRegx .hasMatch(value)){
                return null;
              }
              return "enter valid ${hinttext.toLowerCase()}";
            },
      ),
    );
  }
}
