import 'package:flutter/material.dart';
import 'package:mensageiro/app/core/components/svg_asset.dart';
import 'package:mensageiro/app/core/components/text.dart';
import 'package:mensageiro/app/core/constants/colors.dart';
import 'package:mensageiro/app/core/constants/const.dart';
import 'package:mensageiro/app/core/constants/fonts_sizes.dart';

class CustomContactCard extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Color color;
  final double? padding;
  const CustomContactCard(
      {super.key,
      required this.icon,
      required this.color,
      required this.title,
      this.padding,
      this.subtitle,
      this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding?? AppConst.sidePadding - 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.newGrey,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.all(10),
                child: AppSvgAsset(
                  image: icon,
                  color: color,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: title,
                            fontSize: AppFontSize.fontSize6,
                            // maxLines: 2,
                            fontWeight: 'medium',
                          ),
                          if (subtitle != null)
                            AppText(
                              text: subtitle ?? '',
                              color: subtitleColor ?? AppColors.green,
                              fontSize: AppFontSize.fz05,
                              maxLines: 2,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
