import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mensageiro/app/core/components/text.dart';
import 'package:mensageiro/app/core/constants/colors.dart';
import 'package:mensageiro/app/core/constants/fonts_sizes.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double? fontSize;
  const PageTitle({super.key, required this.title, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: AppText(
        text: title,
        maxLines: 10,
        fontSize: fontSize ?? AppFontSize.fz10,
        fontWeight: 'medium',
        color: AppColors.black,
      ),
    );
  }
}
