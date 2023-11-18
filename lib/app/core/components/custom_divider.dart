import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 0,
      height: 1,
      endIndent: 2,
      color: Color(0xFFefefef),
      thickness: 2,
    );
  }
}