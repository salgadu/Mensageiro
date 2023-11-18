import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mensageiro/app/core/components/svg_asset.dart';
import 'package:mensageiro/app/core/components/text.dart';
import 'package:mensageiro/app/core/constants/colors.dart';
import 'package:mensageiro/app/core/constants/fonts_sizes.dart';
import 'package:mensageiro/app/core/utils/text_styles.dart';

// ignore: must_be_immutable
class TitleTextField extends StatefulWidget {
  void Function()? onTap;
  void Function()? onEditingComplete;
  void Function()? onTapTextField;
  List<TextInputFormatter>? inputFormatters;
  TextEditingController? controller;
  String? title;
  String? hintText;
  String? errorText;
  bool isValid;
  bool selectedAllText;
  Color colorTitle;
  String fontWeight;
  String? hintFontWeight;
  String? prefixText;
  String? icon;
  FocusNode? focusNode;
  String? prefixIcon;
  double fontSizeTitle;
  double fontSizeField;
  double? fontSizeHint;
  double prefixIconSize;
  double suffixIconSize;
  double moreHeightTitle;
  bool readOnly;
  bool autofocus;
  bool underlineOff;
  int? maxLines;
  final EdgeInsets? contentPadding;
  TextAlign textAlign;
  TextInputType? keyboardType;
  Function(String)? onChanged;
  TextCapitalization textCapitalization;
  String? suffixIcon;
  final Color? borderColor;

  TitleTextField(
      {Key? key,
      this.icon,
      this.prefixIcon,
      this.onTap,
      this.onEditingComplete,
      this.onTapTextField,
      this.inputFormatters,
      this.controller,
      this.title,
      this.hintText,
      this.errorText,
      this.keyboardType,
      this.maxLines,
      this.textAlign = TextAlign.start,
      this.readOnly = false,
      this.isValid = true,
      this.selectedAllText = false,
      this.colorTitle = AppColors.black,
      this.fontWeight = "regular",
      this.textCapitalization = TextCapitalization.none,
      this.prefixText,
      this.prefixIconSize = 20,
      this.suffixIconSize = 20,
      this.fontSizeTitle = AppFontSize.fontSize5,
      this.fontSizeField = AppFontSize.fontSize5,
      this.fontSizeHint,
      this.onChanged,
      this.autofocus = false,
      this.moreHeightTitle = 0,
      this.underlineOff = false,
      this.suffixIcon,
      this.hintFontWeight,
      this.focusNode,
      this.borderColor,
      this.contentPadding})
      : super(key: key) {
    if (controller != null && selectedAllText) {
      controller!.selection =
          TextSelection(baseOffset: 0, extentOffset: controller!.text.length);
    }
  }

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          AppText(
            text: "${widget.title}",
            fontSize: widget.fontSizeTitle,
            height: 1,
            fontWeight: widget.fontWeight,
            color: widget.colorTitle,
          ),
        SizedBox(height: widget.moreHeightTitle),
        TextField(
          autofocus: widget.autofocus,
          // ignore: prefer_if_null_operators
          maxLines: widget.maxLines != null
              ? widget.maxLines
              : widget.keyboardType != null
                  ? null
                  : 1,
          minLines: null, textAlign: widget.textAlign,
          onTap: widget.onTapTextField,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          readOnly: widget.readOnly,
          cursorColor: AppColors.black,
          inputFormatters: widget.inputFormatters,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          style: textStyle(
            fontWeight: 'bold',
            fontFamilyFallback: ['regular'],
            fontSize: widget.fontSizeField,
            color: widget.isValid ? AppColors.black : AppColors.normalRed,
          ),
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            errorMaxLines: 2,
            errorStyle: textStyle(
              fontFamilyFallback: ['regular'],
              color: AppColors.normalRed,
              fontSize: AppFontSize.fontSize4,
            ),
            error: widget.errorText != null
                ? Row(
                    children: [
                      AppText(
                        text: widget.errorText!,
                        fontSize: AppFontSize.fz05,
                        color: AppColors.normalRed,
                        fontWeight: 'bold',
                      )
                    ],
                  )
                : null,
            errorBorder: widget.underlineOff
                ? InputBorder.none
                : const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.normalRed,
                      width: 2,
                    ),
                  ),
            enabledBorder: widget.underlineOff
                ? InputBorder.none
                : widget.errorText == null
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? const Color(0xFFefefef),
                          width: 2,
                        ),
                      )
                    : const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.normalRed,
                          width: 2,
                        ),
                      ),
            border: widget.errorText != null
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderColor ?? const Color(0xFFefefef),
                    ),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.normalRed,
                      width: 2,
                    ),
                  ),
            focusedBorder: widget.underlineOff
                ? InputBorder.none
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderColor ?? const Color(0xFFefefef),
                      width: 2,
                    ),
                  ),
            // errorText: widget.errorText,
            prefixText: widget.prefixText,
            prefixStyle: textStyle(
              fontSize: widget.fontSizeField,
              fontWeight: 'bold',
              color: widget.isValid ? AppColors.black : AppColors.normalRed,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: AppSvgAsset(
                        image: widget.prefixIcon ?? "close.svg",
                        imageH: widget.prefixIconSize,
                        color: widget.isValid
                            ? AppColors.grey
                            : AppColors.normalRed,
                      ),
                    ),
                  )
                : null,
            prefixIconConstraints:
                BoxConstraints(maxWidth: widget.prefixIconSize + 10),
            suffixIconConstraints:
                const BoxConstraints(maxWidth: 18, maxHeight: 18),
            suffixIcon: widget.onTap != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: widget.onTap,
                        child: AppSvgAsset(
                          image: widget.icon ?? "close.svg",
                          imageH: widget.suffixIconSize,
                          color: widget.isValid
                              ? AppColors.grey
                              : AppColors.normalRed,
                        ),
                      ),
                    ),
                  )
                : widget.suffixIcon != null
                    ? AppSvgAsset(
                        image: widget.suffixIcon!,
                        imageH: widget.suffixIconSize,
                        color: widget.isValid
                            ? AppColors.grey
                            : AppColors.normalRed,
                      )
                    : widget.errorText != null
                        ? const AppSvgAsset(
                            image: 'exclamation.svg',
                            imageH: 14,
                            imageW: 14,
                            color: AppColors.normalRed,
                          )
                        : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: widget.hintFontWeight ?? 'regular',
              fontSize: widget.fontSizeHint ?? AppFontSize.fz06,
              color: AppColors.grey,
            ),
          ),
        ),
        // Divider(
        //   color:
        //       widget.isValid ? AppColors.lightGrey : AppColors.normalRed,
        //   indent: 0,
        //   height: 0,
        //   endIndent: 0,
        //   thickness: 2,
        // ),
      ],
    );
  }
}
