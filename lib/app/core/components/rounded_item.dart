import 'package:flutter/material.dart';
import 'package:mensageiro/app/core/components/svg_asset.dart';
import 'package:mensageiro/app/core/components/text.dart';
import 'package:mensageiro/app/core/constants/colors.dart';
import 'package:mensageiro/app/core/constants/fonts_sizes.dart';

class RoundedItem extends StatelessWidget {
  final String icon;
  final String? title;
  final String? subtitle;
  final double? iconSize;
  final double? size;
  final double? fontSize;
  final double? subtitleFontSize;
  final String? fontWeight;
  final Color? iconColor;
  final Color? backgroundcolor;
  final bool? boxShadow;
  const RoundedItem({
    super.key,
    required this.icon,
    this.title,
    this.subtitle,
    this.iconSize,
    this.iconColor,
    this.backgroundcolor,
    this.size,
    this.fontSize,
    this.fontWeight,
    this.boxShadow,
    this.subtitleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size ?? 54,
          width: size ?? 54,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundcolor ?? AppColors.lightGrey,
              boxShadow: [
                if (boxShadow ?? false)
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    offset: const Offset(0, 8),
                    blurRadius: 8,
                    spreadRadius: -5,
                  ),
              ]),
          child: Center(
            child: SizedBox(
              height: iconSize ?? 14,
              width: iconSize ?? 14,
              child: AppSvgAsset(
                image: icon,
                color: iconColor ?? AppColors.grey,
              ),
            ),
          ),
        ),
        if (title != null) const SizedBox(height: 10),
        if (title != null)
          AppText(
            text: title ?? '',
            color: AppColors.black,
            fontWeight: fontWeight ?? 'bold',
            fontSize: fontSize ?? AppFontSize.fz06,
            textAlign: TextAlign.center,
          ),
        if (title != null) const SizedBox(height: 2),
        if (title != null)
          AppText(
            text: subtitle ?? '',
            fontSize: subtitleFontSize ?? AppFontSize.fz05,
          ),
      ],
    );
  }
}
